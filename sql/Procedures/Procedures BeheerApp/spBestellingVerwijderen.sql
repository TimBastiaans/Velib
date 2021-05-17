USE Velib
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE [type] = 'P' AND [name] = 'spBestellingVerwijderen')
BEGIN DROP PROCEDURE spBestellingVerwijderen END
GO

CREATE PROCEDURE spBestellingVerwijderen
	@id INT
AS
BEGIN
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
		IF EXISTS (SELECT 1 FROM BESTELLING WHERE ORDERID = @id)
			BEGIN
				DELETE FROM BESTELLING
				WHERE ORDERID = @id
			END
		ELSE
		RAISERROR('Deze bestelling bestaat niet',16,1)
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
END
GO


-- TEST
begin transaction
delete from FIETSONDERDEELINWORKSHOP
delete from BESTELLING
delete from FIETSONDERDEELBIJLEVERANCIER
delete from LEVERANCIER
delete from FIETSONDERDEEL
delete from WORKSHOP

insert FIETSONDERDEEL values(1,'ergg','fkjagf',300,10)
insert WORKSHOP values (1,1)
insert LEVERANCIER values (1,'efaggg',06437843,'rhs@ihre')
insert FIETSONDERDEELBIJLEVERANCIER values(1,1,23)
insert FIETSONDERDEELINWORKSHOP values(1,1,30)
insert BESTELLING values(1,1,1,1,10,0)

--test
select * from BESTELLING -- nu zit hij er nog in
exec spBestellingVerwijderen 1
select * from BESTELLING -- nu niet meer
rollback transaction