use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spWerknemerVerwijderen')
DROP PROCEDURE spWerknemerVerwijderen
GO

CREATE PROCEDURE spWerknemerVerwijderen
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
		
		IF exists(select 1 from WERKNEMER where WERKNEMERID = @WERKNEMERID)
		begin
		delete from MONTEURDIENST where WERKNEMERID = @WERKNEMERID
		delete from dbo.ADMIN where WERKNEMERID = @WERKNEMERID
		delete from reparatie where WERKNEMERID = @WERKNEMERID
		delete from WERKNEMER where WERKNEMERID = @WERKNEMERID
		end
		else
		begin
		raiserror('Deze werknemer bestaat niet, dus je probleem is eigenlijk al opgelost', 16, 1)
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
select * from WERKNEMER WHERE WERKNEMERID = 1
exec spWerknemerVerwijderen 1
select * from WERKNEMER WHERE WERKNEMERID = 1
rollback transaction