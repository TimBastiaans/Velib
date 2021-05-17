use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spKoppelOnderdeelAanLeverancier')
DROP PROCEDURE spKoppelOnderdeelAanLeverancier
GO

CREATE PROCEDURE spKoppelOnderdeelAanLeverancier
(
@ONDERDEEL integer,
@LEVERANCIER integer,
@PRIJS decimal(5,2)
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
	
	IF EXISTS (select 1 from FIETSONDERDEELBIJLEVERANCIER WHERE ONDERDEELID = @ONDERDEEL AND LEVERANCIERID = @LEVERANCIER)
	RAISERROR('Dit onderdeel bij deze leverancier is bij ons al bekent',16,1)	
	IF(@PRIJS <= 0)
	RAISERROR('De prijs moet groter zijn als 0.',16,1)

		if exists(select 1 from FIETSONDERDEEL where ONDERDEELID = @ONDERDEEL) and exists(select 1 from LEVERANCIER where LEVERANCIERID = @LEVERANCIER)
			begin
				INSERT INTO dbo.FIETSONDERDEELBIJLEVERANCIER values (@LEVERANCIER, @ONDERDEEL, @PRIJS)
			end	
		else
			begin
				raiserror('Onderdeel of leverancier bestaat niet', 16, 1)
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
select * from FIETSONDERDEELBIJLEVERANCIER
exec spKoppelOnderdeelAanLeverancier 1, 1, 2.50
select * from FIETSONDERDEELBIJLEVERANCIER
rollback transaction