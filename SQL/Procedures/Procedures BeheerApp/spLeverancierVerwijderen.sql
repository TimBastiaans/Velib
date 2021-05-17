use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spLeverancierVerwijderen')
DROP PROCEDURE spLeverancierVerwijderen
GO

CREATE PROCEDURE spLeverancierVerwijderen
(
@LEVERANCIERID INT
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
		if exists (SELECT 1 FROM BESTELLING WHERE LEVERANCIERID = @LEVERANCIERID)
			begin
				RAISERROR('Er moet nog een bestelling binnenkomen van deze leverancier.', 16,1)
			end
		if exists (SELECT 1 FROM LEVERANCIER WHERE LEVERANCIERID = @LEVERANCIERID)
			begin
				DELETE FROM FIETSONDERDEELBIJLEVERANCIER WHERE LEVERANCIERID = @LEVERANCIERID
				DELETE FROM LEVERANCIER WHERE LEVERANCIERID = @LEVERANCIERID
			end
		else
			begin
				RAISERROR('Leverancier bestaat niet', 16, 1)
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
select * from LEVERANCIER
exec spLeverancierVerwijderen 1
select * from LEVERANCIER
rollback transaction