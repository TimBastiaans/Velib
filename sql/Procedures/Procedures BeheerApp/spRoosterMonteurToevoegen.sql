/* Procedure spRoosterMToevoegen														*/ 
/* Parameters:														    */ 
/* @WERKNEMERID een id van een medewerker van velib						*/ 
/* @START_DATUM dit is de starttijd van de dienst						*/ 
/* @EINDTIJD Dit is de eindtijd van de dienst							*/ 
/* @WORKSHOPID Dit is de workshop waar de werknemer moet werken			*/ 

use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spRoosterMToevoegen')
DROP PROCEDURE spRoosterMToevoegen
GO

CREATE PROCEDURE spRoosterMToevoegen
	@WERKNEMERID INT,
	@START_DATUM DATETIME,
	@WORKSHOPID INT,
	@EINDTIJD DATETIME	
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 -- alternatief: IF (XACT_STATE()) = 1
		SAVE TRANSACTION ProcedureSave;
	ELSE -- alternatief: IF (XACT_STATE()) = 0
		BEGIN TRANSACTION;
	BEGIN TRY
	IF NOT EXISTS (SELECT 1 FROM WERKNEMER WHERE WERKNEMERID = @WERKNEMERID)
	RAISERROR('Deze werknemer bestaat niet.',16,1)
	IF NOT EXISTS (SELECT 1 FROM WORKSHOP WHERE WORKSHOPID = @WORKSHOPID)
	RAISERROR('Deze workshop bestaat niet',16,1)
	IF @START_DATUM < GETDATE()
	RAISERROR('De startdatum mag niet in het verleden zijn.',16,1)
		IF NOT EXISTS(SELECT 1 FROM MONTEURDIENST WHERE WERKNEMERID = @WERKNEMERID AND CAST(START_DATUM AS DATE) = CAST(@START_DATUM AS DATE) OR CAST(EIND_TIJD AS DATE) = CAST(@EINDTIJD AS DATE))
			BEGIN
				IF(@START_DATUM < @EINDTIJD)
					BEGIN
						INSERT INTO MONTEURDIENST
						VALUES (@WERKNEMERID,@START_DATUM,@WORKSHOPID,@EINDTIJD) 
					END
				ELSE
					RAISERROR('De start tijd van de medewerker is later dan de eind tijd van de workshift',16,1)
			END
			ELSE 
			BEGIN
			declare @error VARCHAR(MAX) ='De werknemer '+ CAST(@werknemerID AS VARCHAR(20)) + '  Werkt al deze dag: '+ cast(CAST(@start_datum AS DATE)AS VARCHAR(20)) + ' in de workshop ' + CAST(@WORKSHOPID AS VARCHAR(20));
			RAISERROR(@error,16,1);
			END
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
				/* Transaction started before procedure called, do not roll back 
				modifications made before the procedure was called.
				If the transaction is still valid, just roll back to the 
				savepoint set at the start of the stored procedure.*/
				IF XACT_STATE() <> -1 ROLLBACK TRANSACTION ProcedureSave;
				/* If the transaction is uncommitable, a rollback to the savepoint 
				is not allowed because the savepoint rollback writes to the log. 
				Just return to the caller, which should roll back the outer transaction.*/
			END;	
		THROW
	END CATCH
GO

select * FROM MONTEURDIENST
select * FROM WERKNEMER

/*		Testcase			*/
INSERT INTO WORKSHOP
VALUES(1,'straat')

INSERT INTO WERKNEMER
VALUES(1, NULL, 'tim','pietje','straat','6539 OP','password')

INSERT INTO MONTEURDIENST
VALUES (1,'2017-12-19 12:00:00',1, '2017-12-19 19:00:00')

--GOED
BEGIN TRAN
EXEC spRoosterMToevoegen @werknemerID = 11, @start_datum = '2018-01-16 11:00:00', @WORKSHOPID = 1 ,@eindtijd = '2018-01-16 19:00:00'
select * FROM MONTEURDIENST
ROLLBACK TRAN

--FOUTMELDING 1#
BEGIN TRAN 
EXEC spRoosterMToevoegen @werknemerID = 1, @start_datum = '2017-12-19 19:00:00', @WORKSHOPID = 1 ,@eindtijd = '2017-12-19 12:00:00'
select * FROM MONTEURDIENST
ROLLBACK TRAN

--FOUTMELDING 2#
BEGIN TRAN 
INSERT INTO MONTEURDIENST
VALUES (1,'2017-12-19 10:00:00',1,'2017-12-19 11:00:00')

EXEC spRoosterMToevoegen @werknemerID = 1, @start_datum = '2017-12-19 19:00:00', @WORKSHOPID = 1 ,@eindtijd = '2017-12-19 12:00:00'
select * FROM MONTEURDIENST
ROLLBACK TRAN


SELECT * FROM dbo.MONTEURDIENST

INSERT INTO dbo.MONTEURDIENST
        ( WERKNEMERID ,
          START_DATUM ,
          WORKSHOPID ,
          EIND_TIJD
        )
VALUES  ( 1 , -- WERKNEMERID - ID_NUMMER
          '2017-12-25 12:00' , -- START_DATUM - DATUM
          1 , -- WORKSHOPID - ID_NUMMER
          '2017-12-25 16:00'  -- EIND_TIJD - DATUM
        )
