use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spControleTaakVerwijderen')
DROP PROCEDURE spControleTaakVerwijderen
GO

CREATE PROCEDURE spControleTaakVerwijderen
(
@TAAKID integer
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
		IF exists (select 1 from TAAK where TAAKID = @TAAKID)
		begin
		delete from TAAK where TAAKID = @TAAKID
		end
		else
		begin	
		raiserror('Deze taak bestaat niet', 16, 1)
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

--test
begin transaction
select * from TAAK
exec spControleTaakVerwijderen 1
select * from TAAK
rollback transaction