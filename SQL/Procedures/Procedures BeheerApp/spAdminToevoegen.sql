use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spAdminToevoegen')
DROP PROCEDURE spAdminToevoegen
GO

CREATE PROCEDURE spAdminToevoegen
(
@WERKNEMERID integer
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
		IF EXISTS(SELECT 1 FROM [ADMIN] WHERE WERKNEMERID = @WERKNEMERID)
		RAISERROR('Deze werknemer is al een administrator',16,1)
		IF EXISTS(SELECT 1 FROM WERKNEMER WHERE WERKNEMERID = @WERKNEMERID)
		INSERT INTO dbo.ADMIN VALUES (@WERKNEMERID)
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
GO

--test
begin transaction
select * from admin
exec spAdminToevoegen 1
select * from admin
rollback transaction
