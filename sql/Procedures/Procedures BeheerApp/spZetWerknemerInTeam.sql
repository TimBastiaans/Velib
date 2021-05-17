USE Velib
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE [type] = 'P' AND [name] = 'spZetWerknemerInTeam')
BEGIN DROP PROCEDURE spZetWerknemerInTeam END
GO

CREATE PROCEDURE spZetWerknemerInTeam
	@WERKNEMERID INT,
	@TEAMID INT
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
	
	IF NOT EXISTS (SELECT 1 FROM ROUTINGCARD WHERE TEAMID = @TEAMID) 
	RAISERROR('Dit team bestaat niet. ',16,1)

	IF EXISTS (SELECT 1 FROM WERKNEMER WHERE WERKNEMERID = @WERKNEMERID)
		BEGIN
			UPDATE WERKNEMER
			SET TEAMID = @TEAMID
			WHERE WERKNEMERID = @WERKNEMERID
		END
	ELSE
		RAISERROR('Deze werknemer bestaat niet',16,1)
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


-- TEST
begin transaction
delete from ROUTINGCARD
delete from WERKNEMER
delete from ONGROUNDTEAM

insert WERKNEMER values (1,NULL,'fawfa','fawff', 'skadmsakdsa', '2345fd','fgkagfawgfagf')
insert ONGROUNDTEAM values (1)

--test
select * from WERKNEMER where teamid = 1 --zit er niet in
exec spZetWerknemerInTeam 1,1
select * from WERKNEMER where teamid = 1-- nu wel
rollback transaction