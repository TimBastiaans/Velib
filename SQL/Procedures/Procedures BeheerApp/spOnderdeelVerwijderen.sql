use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spOnderdeelVerwijderen')
DROP PROCEDURE spOnderdeelVerwijderen
GO

CREATE PROCEDURE spOnderdeelVerwijderen
(
@ONDERDEELID integer
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
		if exists (select 1 from BESTELLING where ONDERDEELID = @ONDERDEELID)
			begin
				raiserror('Er moet nog een bestelling binnenkomen van dit onderdeel', 16,1)
			end
		if exists(select 1 from FIETSONDERDEELINWORKSHOP where ONDERDEELID = @ONDERDEELID)
			begin
				raiserror('Dit onderdeel is nog aanwezig in de magazijnen', 16, 1)
			end
		if exists (select 1 from FIETSONDERDEEL where ONDERDEELID = @ONDERDEELID)
			begin
				delete from FIETSONDERDEELBIJLEVERANCIER where ONDERDEELID = @ONDERDEELID
				delete from FIETSONDERDEEL where ONDERDEELID = @ONDERDEELID
			end
		else
			begin
				raiserror('Fietsonderdeel bestaat niet', 16, 1)
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
select * from FIETSONDERDEEL
exec spOnderdeelVerwijderen 1
select * from FIETSONDERDEEL
rollback transaction