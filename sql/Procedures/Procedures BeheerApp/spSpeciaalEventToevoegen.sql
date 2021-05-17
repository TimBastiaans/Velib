/* Procedure spSpeciaalEventToevoegen									*/ 
/* Parameters:														    */ 
/* @EVENT_NAAM Is de naam van het nieuwe evenement						*/ 
/* @DATUM is een datum van het nieuwe evenement							*/ 
/* @BESCHRIJVING beschrijving van het evenement							*/ 

use Velib
GO
select * from SPECIAAL_EVENEMENT

IF EXISTS(select * from sys.objects where type = 'P' AND name='spSpeciaalEventToevoegen')
DROP PROCEDURE spSpeciaalEventToevoegen
GO

CREATE PROCEDURE spSpeciaalEventToevoegen
@EVENT_NAAM VARCHAR(MAX),
@DATUM DATETIME,
@BESCHRIJVING VARCHAR(MAX) = 'None'
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
		DECLARE @EVENTID INT 

		IF EXISTS (SELECT 1 FROM SPECIAAL_EVENEMENT)
		SELECT @EVENTID = MAX(EVENTID) + 1 FROM SPECIAAL_EVENEMENT
		ELSE
		BEGIN
		SELECT @EVENTID = 1
		END

		IF NOT EXISTS (SELECT 1 FROM SPECIAAL_EVENEMENT WHERE NAAM = @EVENT_NAAM AND CAST(DATUM AS DATE) = CAST(@DATUM AS DATE))
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

