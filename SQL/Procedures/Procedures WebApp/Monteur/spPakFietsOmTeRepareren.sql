
use Velib
GO
/*
stored procedure voor een werknemer van een workshop om aan te geven dat hij met een fiets bezig is.
*/

IF EXISTS(select * from sys.objects where type = 'P' AND name='spPakFietsOmTeRepareren')
DROP PROCEDURE spPakFietsOmTeRepareren
GO



CREATE PROCEDURE spPakFietsOmTeRepareren
	@FIETSID INT
AS
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 -- alternatief: IF (XACT_STATE()) = 1
		SAVE TRANSACTION ProcedureSave;
	ELSE -- alternatief: IF (XACT_STATE()) = 0
		BEGIN TRANSACTION;
	BEGIN TRY
		if exists (select 1 from REPARATIEQUEUE where FIETSID = @FIETSID and WORDT_GEREPAREERD = '1')
		raiserror('Er wordt al gewerkt aan deze fiets.', 16,1)
		IF exists (select 1 from REPARATIEQUEUE where FIETSID = @FIETSID)
		Begin
		update REPARATIEQUEUE set WORDT_GEREPAREERD = '1' where FIETSID = @FIETSID
		end
		else
		begin
		raiserror('Deze fiets stond niet in de reparatieQueue.', 16, 1)
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

begin tran

select * from REPARATIEQUEUE
begin try
exec spPakFietsOmTeRepareren 2
end try
begin catch
print 'shit is niet goed gegaan'
end catch
select * from REPARATIEQUEUE
rollback tran