use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spFietsToevoegen')
DROP PROCEDURE spFietsToevoegen
GO

CREATE PROCEDURE spFietsToevoegen
(
@FIETSID integer,
@WORKSHOPID integer
)
AS
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
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
			IF EXISTS (SELECT 1 FROM WORKSHOP WHERE WORKSHOPID = @WORKSHOPID)
				INSERT INTO dbo.FIETS values (@FIETSID, @WORKSHOPID)
			ELSE
			RAISERROR('Deze workshop bestaat niet',16,1)
		ELSE
		RAISERROR('Dit fietsid bestaat al',16,1)

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


--test
begin transaction
select * from FIETS
exec spFietsToevoegen 3, 1
select * from FIETS
rollback transaction