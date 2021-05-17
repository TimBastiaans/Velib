USE Velib
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE [type] = 'P' AND [name] = 'spRoutingCardToevoegen')
BEGIN DROP PROCEDURE spRoutingCardToevoegen END
GO

CREATE PROCEDURE spRoutingCardToevoegen
	@team INT,
	@ritdatum DATETIME,
	@station INT
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
	IF NOT EXISTS(SELECT 1 FROM ROUTINGCARD WHERE teamid = @team)
	RAISERROR('Dit team bestaat niet.',16,1)
	IF NOT EXISTS(SELECT 1 FROM STATION WHERE STATIONID = @station)
	RAISERROR('Dit station bestaat niet.',16,1)
	IF NOT EXISTS (select 1 from ROUTINGCARD WHERE TEAMID = @team AND CAST(RITDATUM AS DATE) = CAST(@ritdatum AS DATE) AND STATIONID = @station)
		BEGIN
			INSERT ROUTINGCARD 
			VALUES(@team,@ritdatum,@station)
		END
	ELSE
	RAISERROR('Dit team rijd al op deze datum naar dit station',16,1)
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

--test
begin transaction
select * from ROUTINGCARD
exec spRoutingCardToevoegen 1, '2018-01-13 12:00:00', 1
select * from ROUTINGCARD
rollback transaction

begin transaction
select * from ROUTINGCARD
exec spRoutingCardToevoegen 1, '2018-01-13 19:00:00', 22
select * from ROUTINGCARD
rollback transaction
