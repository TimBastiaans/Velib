use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spControleTaakToevoegen')
DROP PROCEDURE spControleTaakToevoegen
GO

CREATE PROCEDURE spControleTaakToevoegen
(
@TAAK varchar(max)
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
		IF NOT EXISTS (select 1 FROM TAAK where TAAKNAAM = @TAAK)
			BEGIN
				DECLARE @TAAKID integer
				if exists(select 1 from TAAK)
					begin
						SELECT @TAAKID = max(TAAKID) + 1 from TAAK
					end
				else
					begin
						SELECT @TAAKID = 1
					end
					INSERT INTO dbo.TAAK values (@TAAKID, @TAAK)
			END
			ELSE
			RAISERROR('Deze taak bestaal al',16,1)
		
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
select * from TAAK
exec spControleTaakToevoegen 'dingen doen met de fiets'
select * from TAAK
rollback transaction