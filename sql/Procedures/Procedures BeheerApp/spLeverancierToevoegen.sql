use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spLeverancierToevoegen')
DROP PROCEDURE spLeverancierToevoegen
GO

CREATE PROCEDURE spLeverancierToevoegen
(
@NAAM varchar(30),
@TELEFOON varchar(30),
@EMAIL varchar(50)
)
AS
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
	IF NOT EXISTS (SELECT 1 FROM LEVERANCIER WHERE NAAM = @naam)
		BEGIN 
			DECLARE @LEVERANCIERID integer
			if exists( select 1 from LEVERANCIER)
				begin
					select @LEVERANCIERID = max(LEVERANCIERID) + 1 from LEVERANCIER
				end
			else
				begin
					Select @LEVERANCIERID = 1
				end	
		insert into LEVERANCIER values (@LEVERANCIERID, @NAAM, @TELEFOON, @EMAIL)
		END
		ELSE
		RAISERROR('Leverancier bestaat al',16,1)
		
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
exec spLeverancierToevoegen 'Giant', '82828', null
select * from LEVERANCIER
rollback transaction

