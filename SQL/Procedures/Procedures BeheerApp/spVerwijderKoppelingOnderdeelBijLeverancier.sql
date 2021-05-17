use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spVerwijderKoppelingOnderdeelBijLeverancier')
DROP PROCEDURE spVerwijderKoppelingOnderdeelBijLeverancier
GO

CREATE PROCEDURE spVerwijderKoppelingOnderdeelBijLeverancier
(
@ONDERDEEL integer,
@LEVERANCIER integer
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
		if exists(select 1 from BESTELLING where LEVERANCIERID = @LEVERANCIER and ONDERDEELID = @ONDERDEEL)
			begin
				raiserror('Er moet nog een bestelling binnenkomen', 16, 1)
			end
		if exists(select 1 from FIETSONDERDEELBIJLEVERANCIER where LEVERANCIERID = @LEVERANCIER and ONDERDEELID = @ONDERDEEL)
			begin
				delete from dbo.FIETSONDERDEELBIJLEVERANCIER where LEVERANCIERID = @LEVERANCIER and ONDERDEELID = @ONDERDEEL
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
exec spVerwijderKoppelingOnderdeelBijLeverancier 1, 1
select * from FIETSONDERDEELBIJLEVERANCIER
rollback transaction