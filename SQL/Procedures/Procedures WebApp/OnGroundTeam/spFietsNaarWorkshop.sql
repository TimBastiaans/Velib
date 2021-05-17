use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spFietsNaarWorkshop')
DROP PROCEDURE spFietsNaarWorkshop
GO

--fiets wordt uit het station gehaald
--fiets wordt achterin de reparatieQueue gezet
CREATE PROCEDURE spFietsNaarWorkshop
(
@WORKSHOPID integer,
@FIETSID integer,
@BESCHRIJVING varchar(1024)
)
AS
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
	if exists (select 1 from FIETSPOST where FIETSID = @FIETSID) and exists (select 1 from WORKSHOP where WORKSHOPID = @WORKSHOPID)
	begin
		DELETE FROM FIETSPOST where FIETSID = @FIETSID
		DECLARE @VOLGNUMMER int
		if exists(select 1 from REPARATIEQUEUE where WORKSHOPID = @WORKSHOPID)
		begin
			select @VOLGNUMMER = MAX(VOLGNUMMER) + 1 from REPARATIEQUEUE where WORKSHOPID = @WORKSHOPID
		end
		else
		begin
			SET @VOLGNUMMER = 1
		end
		INSERT INTO REPARATIEQUEUE values (@WORKSHOPID, @VOLGNUMMER, @FIETSID, @BESCHRIJVING, '0')
		end
		else
		begin
		raiserror('De fiets bestaat niet, of de workshop bestaat niet', 16,1)
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

--test (kan wel)
begin tran
select * from FIETSPOST
select * from REPARATIEQUEUE
exec spFietsNaarWorkshop 3, 6, 'fietst niet meer'
select * from FIETSPOST
select * from REPARATIEQUEUE
rollback tran

--test (kan niet omdat de fiets niet bestaat)
begin tran
select * from FIETSPOST
select * from REPARATIEQUEUE
exec spFietsNaarWorkshop 3, 7, 'fietst niet meer'
select * from FIETSPOST
select * from REPARATIEQUEUE
rollback tran

--test (kan niet omdat de workshop niet bestaat)
begin tran
select * from FIETSPOST
select * from REPARATIEQUEUE
exec spFietsNaarWorkshop 5, 6, 'fietst niet meer'
select * from FIETSPOST
select * from REPARATIEQUEUE
rollback tran