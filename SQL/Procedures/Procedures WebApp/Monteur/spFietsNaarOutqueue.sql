USE Velib
GO

--procedure die uitgevoerd wordt als een fiets is gerepareerd en in de outqueue gezet moet worden
--de fiets wordt uit de reparatieQueue gehaald
--de reparatieQueue wordt doorgeschoven
--fiets wordt in de outQueue gezet


IF EXISTS(SELECT 1 FROM sys.objects WHERE [type] = 'P' AND [name] = 'spFietsNaarOutqueue')
BEGIN DROP PROCEDURE spFietsNaarOutqueue END
GO

CREATE PROCEDURE spFietsNaarOutqueue
	@FIETSID INT,
	@WORKSHOP INT
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON 
SET XACT_ABORT OFF
DECLARE @TranCounter INT;
SET @TranCounter = @@TRANCOUNT;
IF @TranCounter > 0 
	SAVE TRANSACTION ProcedureSave;
ELSE 
	BEGIN TRANSACTION;
BEGIN TRY

IF NOT EXISTS (SELECT 1 FROM FIETS WHERE FIETSID = @FIETSID)
RAISERROR('Deze fiets bestaat niet',16,1)

IF NOT EXISTS (SELECT 1 FROM WORKSHOP WHERE WORKSHOPID = @WORKSHOP)
RAISERROR('Deze workshop bestaat niet',16,1)

IF EXISTS (SELECT 1 FROM REPARATIEQUEUE WHERE FIETSID = @FIETSID AND WORDT_GEREPAREERD = 1)
	BEGIN
		DECLARE @plaatsInQ integer
		select @plaatsInQ = VOLGNUMMER FROM REPARATIEQUEUE where FIETSID = @FIETSID
		DELETE FROM REPARATIEQUEUE WHERE FIETSID = @FIETSID
		UPDATE REPARATIEQUEUE SET VOLGNUMMER = VOLGNUMMER - 1 where VOLGNUMMER > @plaatsInQ AND WORKSHOPID = @WORKSHOP
		UPDATE FIETS SET WORKSHOPID = @workshop where FIETSID = @FIETSID
	END
ELSE
	RAISERROR('Deze fiets wordt niet gerepareerd.',16,1)

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
END
GO

select * from fiets
select * from REPARATIEQUEUE



-- TEST
begin transaction

	select * from REPARATIEQUEUE
	exec spFietsNaarOutqueue 2,3
	select * from FIETS
	select * from REPARATIEQUEUE
rollback transaction
