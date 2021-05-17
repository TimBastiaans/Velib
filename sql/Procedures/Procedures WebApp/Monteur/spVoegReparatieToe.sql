use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spVoegReparatieToe')
DROP PROCEDURE spVoegReparatieToe
GO


--Er wordt opgeslagen welke onderdelen vervangen zijn van de fiets
--Als dit in de workshop is gebeurd, dan wordt de inventaris van de workshop bijgewerkt
CREATE PROCEDURE spVoegReparatieToe
(
@WORKSHOPID integer = null,
@FIETSID integer,
@ONDERDEELID integer,
@WERKNEMERID integer
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

		IF NOT EXISTS(SELECT 1 FROM FIETS WHERE FIETSID = @FIETSID)
		RAISERROR('Fiets bestaat niet',16,1)

		IF(@WORKSHOPID != null)
		BEGIN
		IF NOT EXISTS(SELECT 1 FROM REPARATIEQUEUE WHERE FIETSID = @FIETSID)
			RAISERROR('Fiets hoeft niet gerepareerd te worden',16,1)
		END
		INSERT INTO REPARATIE values (@FIETSID, @ONDERDEELID, GETDATE(), @WERKNEMERID)

		IF (@WORKSHOPID is not null)
		BEGIN
			IF exists (SELECT 1 AANTAL FROM FIETSONDERDEELINWORKSHOP where WORKSHOPID = @WORKSHOPID and ONDERDEELID = @ONDERDEELID and AANTAL > 0) AND exists (select 1 FROM REPARATIEQUEUE WHERE FIETSID = @FIETSID)
			BEGIN
				EXEC spInventarisBijwerken @WERKNEMERID, @ONDERDEELID, @WORKSHOPID, 1, 0
				--UPDATE FIETSONDERDEELINWORKSHOP SET AANTAL = AANTAL - 1 where WORKSHOPID = @WORKSHOPID and ONDERDEELID = @ONDERDEELID
			END
			ELSE
			BEGIN
				raiserror('Dit onderdeel is niet aanwezig in de workshop', 16, 1)
			END
		END
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

select * from dbo.FIETSONDERDEELINWORKSHOP WHERE WORKSHOPID = 1 AND ONDERDEELID = 3 
begin transaction
EXEC spVoegReparatieToe 1, 21, 1, 1
select * from dbo.FIETSONDERDEELINWORKSHOP WHERE WORKSHOPID = 1 AND ONDERDEELID = 3 
rollback TRANSACTION

select * from REPARATIE
select * from REPARATIEQUEUE