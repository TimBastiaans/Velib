/* Procedure spSpeciaalEventToevoegen									*/ 
/* Parameters:														    */ 
/* @FIETSID is een fiets												*/ 
/* @WORKSHOPID Dit is de workshop waar de fiets staat					*/ 

use Velib
GO
select * from SPECIAAL_EVENEMENT

IF EXISTS(select * from sys.objects where type = 'P' AND name='spSpeciaalEventToevoegen')
DROP PROCEDURE spSpeciaalEventToevoegen
GO

CREATE PROCEDURE spSpeciaalEventToevoegen
@EVENTID INT,
@EVENT_NAAM VARCHAR(MAX),
@DATUM DATE,
@BESCHRIJVING VARCHAR(MAX) = ' '
AS
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 -- alternatief: IF (XACT_STATE()) = 1
		SAVE TRANSACTION ProcedureSave;
	ELSE -- alternatief: IF (XACT_STATE()) = 0
		BEGIN TRANSACTION;
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM SPECIAAL_EVENEMENT WHERE NAAM = @EVENT_NAAM AND DATUM = @DATUM)
		BEGIN
		INSERT INTO SPECIAAL_EVENEMENT
		VALUES(@EVENTID,@EVENT_NAAM, @DATUM, @BESCHRIJVING)
		END
		ELSE
		RAISERROR('Dit evenement bestaat op deze datum',16,1)
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


/*		Testcase			*/

