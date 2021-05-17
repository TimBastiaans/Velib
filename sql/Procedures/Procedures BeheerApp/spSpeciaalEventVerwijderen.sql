/* Procedure spSpeciaalEventVerwijderen									*/ 
/* Parameters:														    */ 
/* @EVENTNAAM is de naam van de procedure die verwijderd wordt			*/ 
/* @EVENTDATUM is de datum van het evenement							*/ 

use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spSpeciaalEventVerwijderen')
DROP PROCEDURE spSpeciaalEventVerwijderen
GO

CREATE PROCEDURE spSpeciaalEventVerwijderen
@EVENTID INT
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
		IF EXISTS (SELECT 1 FROM SPECIAAL_EVENEMENT WHERE EVENTID = @EVENTID)
			BEGIN
			DELETE STATION_IN_SPECIAAL_EVENEMENT
			WHERE EVENTID = @EVENTID

			DELETE SPECIAAL_EVENEMENT
			WHERE EVENTID = @EVENTID

			END
		ELSE 
		RAISERROR('Dit evenement bestaat niet op deze datum.',16,1)
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

