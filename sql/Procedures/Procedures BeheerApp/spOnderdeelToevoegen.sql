use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spOnderdeelToevoegen')
DROP PROCEDURE spOnderdeelToevoegen
GO

CREATE PROCEDURE spOnderdeelToevoegen
(
@NAAM varchar(30),
@BESCHRIJVING varchar(1024),
@MAX integer,
@MIN integer
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
		IF NOT EXISTS(SELECT 1 FROM FIETSONDERDEEL where NAAM = @NAAM AND BESCHRIJVING = @BESCHRIJVING)
			BEGIN
				DECLARE @ONDERDEELID integer
				if exists( select 1 from FIETSONDERDEEL)
					begin
						select @ONDERDEELID = max(ONDERDEELID) + 1 from FIETSONDERDEEL
					end
				else
					begin
						Select @ONDERDEELID = 1
					end
						INSERT into FIETSONDERDEEL values (@ONDERDEELID, @NAAM, @BESCHRIJVING, @MAX, @MIN)
			END
		ELSE
		RAISERROR('Dit onderdeel met deze beschrijving bestaat al',16,1)	
		
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
select * from FIETSONDERDEEL
exec spOnderdeelToevoegen 'Onderdeeltje', 'Beschrijving', 30, 20
select * from FIETSONDERDEEL
rollback transaction