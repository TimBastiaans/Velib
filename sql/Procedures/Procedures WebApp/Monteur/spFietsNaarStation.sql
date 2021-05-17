use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spFietsNaarStation')
DROP PROCEDURE spFietsNaarStation
GO

--fiets wordt uit de OutQueue gehaald
--fiets wordt in de aangegeven fietspost gezet
CREATE PROCEDURE spFietsNaarStation
(
@STATIONID integer,
@FIETSID integer,
@FIETSPOST integer
)
AS
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
	if exists (select 1 from FIETS where FIETSID = @FIETSID and WORKSHOPID is not null)
	begin
		UPDATE FIETS set WORKSHOPID = null where FIETSID = @FIETSID
		INSERT INTO FIETSPOST values(@STATIONID, @FIETSPOST, @FIETSID, '0')
		end
		else
		begin
			raiserror('fiets staat niet in outqueue', 16,1)
		end
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

--werkt wel
begin transaction
select * from FIETS
select * from FIETSPOST
exec spFietsNaarStation 1,3,3
select * from FIETS
select * from FIETSPOST
rollback transaction

--werkt niet omdat fiets '6' niet in een outQ staat
begin tran
exec spFietsNaarStation 1,6,3
rollback tran