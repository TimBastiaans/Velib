
use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spToggleWerknemerActief')
BEGIN DROP PROCEDURE spToggleWerknemerActief END
GO

CREATE PROCEDURE spToggleWerknemerActief(
	@werknemerID INT
)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 
		SAVE TRANSACTION ProcedureSave;
	ELSE 
		BEGIN TRANSACTION;
	BEGIN TRY
		if not exists (select 1 from WERKNEMER where WERKNEMERID = @werknemerID)
		begin
		raiserror('Deze werknemer bestaat niet.', 16,1)
		end
		else
		begin
		if exists (select 1 from WERKNEMER where WERKNEMERID = @werknemerID and ACTIEF = '1')
		begin
		UPDATE WERKNEMER
		SET ACTIEF = '0'
		WHERE WERKNEMERID = @werknemerID
		end
		else
		begin
		UPDATE WERKNEMER
		SET ACTIEF = '1'
		WHERE WERKNEMERID = @werknemerID
		end
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
END
GO


/*     test     */
begin transaction
	insert WERKNEMER values(1,null,'ergarg','rgagreg','egsegeg','rehger','sergser',1)

	--test
	select * from WERKNEMER
	exec spOntslaWerknemer 1
	select * from WERKNEMER

rollback transaction
