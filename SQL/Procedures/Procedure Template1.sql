/* Procedure spStationVoorSpeciaalEvenementVerwijderen					*/ 
/* Parameters:														    */ 
/* @STATIONID is een station											*/ 
/* @EVENTID is een evenement dat gekoppelt is aan dit station			*/ 

use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spStationVoorSpeciaalEvenementVerwijderen')
DROP PROCEDURE spStationVoorSpeciaalEvenementVerwijderen
GO

CREATE PROCEDURE spStationVoorSpeciaalEvenementVerwijderen
@STATIONID INT,
@EVENTID DATETIME
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
			RAISERROR('Dit evenement bestaat niet.',16,1)
		IF EXISTS (SELECT 1 FROM STATION WHERE STATIONID = @STATIONID)
			RAISERROR('Dit station bestaat niet.',16,1)
		IF EXISTS (SELECT 1 FROM STATION_IN_SPECIAAL_EVENEMENT WHERE EVENTID = @EVENTID AND STATIONID = @STATIONID)	
			BEGIN
			DELETE STATION_IN_SPECIAAL_EVENEMENT
			WHERE STATIONID = @STATIONID AND EVENTID = @EVENTID 
			END
		ELSE 
		RAISERROR('Deze koppeling van station, event bestaat niet',16,1)
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

