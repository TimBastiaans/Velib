/* Procedure spInventarisBijwerken																	*/ 
/* Parameters:																						*/ 
/* @ONDERDEEL onderdeel van een fiets																*/ 
/* @WORKSHOPID Dit is de workshop waar de fiets staat												*/ 
/* @PLUSOFMIN Als er een 0 meegegeven word is het - het aantal en als het een 1 is het + het aantal	*/ 


use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spInventarisBijwerken')
DROP PROCEDURE spInventarisBijwerken
GO

--aantal onderdelen in de workshop wordt aangepast
CREATE PROCEDURE spInventarisBijwerken
@WERKNEMERID INT,
@ONDERDEELID INT,
@WORKSHOPID INT,
@AANTAL INT,
@PLUSOFMIN BIT = 0
AS
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 -- alternatief: IF (XACT_STATE()) = 1
		SAVE TRANSACTION ProcedureSave;
	ELSE -- alternatief: IF (XACT_STATE()) = 0
		BEGIN TRANSACTION;
	BEGIN TRY

	IF EXISTS (SELECT 1 FROM MONTEURDIENST WHERE WERKNEMERID = @WERKNEMERID AND CAST(START_DATUM AS DATE) = CAST(GETDATE() AS DATE) AND WORKSHOPID = @WORKSHOPID) OR EXISTS(SELECT 1 FROM ADMIN WHERE WERKNEMERID = @WERKNEMERID)
	BEGIN 
			IF EXISTS(SELECT 1 FROM FIETSONDERDEELINWORKSHOP WHERE ONDERDEELID = @ONDERDEELID AND WORKSHOPID = @WORKSHOPID)
			BEGIN 
				IF (@AANTAL >= 0)
					IF(@PLUSOFMIN = 0)
						BEGIN
							Declare @totaal int
							SELECT @totaal = (AANTAL - @AANTAL) FROM FIETSONDERDEELINWORKSHOP WHERE ONDERDEELID = @ONDERDEELID AND WORKSHOPID = @WORKSHOPID 

							IF(@totaal >= 0)
								UPDATE FIETSONDERDEELINWORKSHOP
								SET AANTAL = AANTAL - @AANTAL
								WHERE ONDERDEELID = @ONDERDEELID AND WORKSHOPID = @WORKSHOPID
							ELSE
							RAISERROR('Het totaal van dit product is minder als 0',16,1)
						END
					ELSE
						UPDATE FIETSONDERDEELINWORKSHOP
						SET AANTAL = AANTAL + @AANTAL
						WHERE ONDERDEELID = @ONDERDEELID AND WORKSHOPID = @WORKSHOPID
				ELSE
				RAISERROR('Aantal kan niet lager zijn dan 0',16,1)
			END
			ELSE
				RAISERROR('Dit onderdeel ligt niet in deze workshop',16,1)
	END
		ELSE
		RAISERROR('Deze monteur is niet werkzaam in deze workshop',16,1)

		IF @TranCounter = 0 AND XACT_STATE() = 1
			COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @TranCounter = 0 
			BEGIN
				IF XACT_STATE() = 1 ROLLBACK TRANSACTION;
			END;
		ELSE
			BEGIN
				IF XACT_STATE() <> -1 ROLLBACK TRANSACTION ProcedureSave;
			END;	
		THROW
	END CATCH
GO

/*		Testcase			*/

delete from FIETSONDERDEEL where ONDERDEELID = '1'
delete from FIETSONDERDEELINWORKSHOP where ONDERDEELID = '1'

insert into FIETSONDERDEEL
values (1,'stuur','fiets',10,0)

insert into FIETSONDERDEELINWORKSHOP
values (1,1,5)

BEGIN TRAN 
EXEC spInventarisBijwerken @werknemerid = 11, @onderdeelID = 1 , @workshopID = 1, @Aantal = 1, @PLUSOFMIN = 0
select * from FIETSONDERDEELINWORKSHOP
ROLLBACK TRANSACTION

select * from MONTEURDIENST

BEGIN TRAN 
EXEC spInventarisBijwerken @werknemerid = 1, @onderdeelID = 1 , @workshopID = 1, @Aantal = 1, @PLUSOFMIN = 1
select * from FIETSONDERDEELINWORKSHOP
ROLLBACK TRANSACTION

/*Getest op 17 januari 2018 UC? Testcase?				*/
BEGIN TRAN 
UPDATE MONTEURDIENST
SET WORKSHOPid = 2 
WHERE CAST(start_datum AS DATE) = CAST(getdate() AS DATE) AND werknemerid = 1
EXEC spInventarisBijwerken @werknemerid = 1, @onderdeelID = 1 , @workshopID = 1, @Aantal = 1, @plusofmin = 1
select * from FIETSONDERDEELINWORKSHOP
ROLLBACK TRANSACTION



