
USE Velib
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE [type] = 'P' AND [name] = 'spOngroundControle')
BEGIN DROP PROCEDURE spOngroundControle END
GO


--fiets hoeft niet meer gecheckt te worden
--er wordt opgeslagen welke controletaken zijn uitgevoerd
CREATE PROCEDURE spOngroundControle
	@fietsid INT,
	@werknemerid INT,
	@beschrijving VARCHAR(MAX)
AS
BEGIN
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
	if exists (SELECT 1 FROM FIETSPOST WHERE FIETSID = @fietsid)
	begin
	UPDATE FIETSPOST SET MOETGECHECKTWORDEN = '0' WHERE FIETSID = @fietsid
	INSERT ONGROUNDCONTROLE VALUES
	(@fietsid,GETDATE(),@werknemerid,@beschrijving)
	end
	else
	begin
	raiserror('Deze fiets bestaat niet.',16,1)
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

-- TEST
begin transaction
	insert FIETS values(1,null)
	insert WERKNEMER values(1,'rgsg','rsesb','rgresg','234ed','krlgleghieohglkehg')
	EXEC spOngroundControle 1,'11-11-2017','halamagalama'
	select * from ONGROUNDCONTROLE where WERKNEMERID = 1 and FIETSID = 1
rollback transaction
