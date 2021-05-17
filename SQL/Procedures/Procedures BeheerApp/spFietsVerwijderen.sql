use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spFietsVerwijderen')
DROP PROCEDURE spFietsVerwijderen
GO

CREATE PROCEDURE spFietsVerwijderen
(
@FIETSID integer
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
		IF exists (select 1 from FIETS where FIETSID = @FIETSID)
		begin
		delete from REPARATIEQUEUE where FIETSID = @FIETSID
		delete from VOLTOOIDE_LENING where FIETSID = @FIETSID
		delete from FIETSPOST where FIETSID = @FIETSID
		delete from FIETS where FIETSID = @FIETSID
		end
		else
		begin
		raiserror('Deze fiets bestaat niet', 16, 1)
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
select * from fiets
exec spFietsVerwijderen 1
select * from fiets
rollback transaction