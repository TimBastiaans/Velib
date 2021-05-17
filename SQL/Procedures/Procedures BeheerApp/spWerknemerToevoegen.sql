use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spWerknemerToevoegen')
DROP PROCEDURE spWerknemerToevoegen
GO

CREATE PROCEDURE spWerknemerToevoegen
(
@VOORNAAM varchar(30),
@ACHTERNAAM varchar(30),
@ADRES varchar(50),
@POSTCODE varchar(10),
@WACHTWOORD varchar(max)
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
		DECLARE @WERKNEMERID integer

		if exists(select 1 from WERKNEMER)
		begin
			SELECT @WERKNEMERID = max(WERKNEMERID) + 1 from WERKNEMER
		end
		else
		begin
			SET @WERKNEMERID = 1
		end
		INSERT INTO dbo.WERKNEMER values (@WERKNEMERID, NULL, @VOORNAAM, @ACHTERNAAM, @ADRES, @POSTCODE, @WACHTWOORD, 1)
		
		IF @TranCounter = 0 AND XACT_STATE() = 1
			COMMIT TRANSACTION;
		SELECT @WERKNEMERID
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
exec spWerknemerToevoegen 'jaco', 'schalij', 'straat2', '2827dj', 'hashedw8woord'
select * from WERKNEMER
rollback transaction



