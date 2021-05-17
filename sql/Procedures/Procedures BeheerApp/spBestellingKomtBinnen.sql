/*																	*/ 
/* Parameters:													    */ 
/* @ORDERID Is het orderid dat is geleverd aan het magazijn			*/ 
 
use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spBestellingKomtBinnen')
DROP PROCEDURE spBestellingKomtBinnen
GO

--bestelling wordt gemarkeerd als aangekomen
--Inventaris wordt bijgewerkt
CREATE PROCEDURE spBestellingKomtBinnen
(
@orderID integer
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
		DECLARE @Workshop integer
		DECLARE @Onderdeel integer
		DECLARE @Aantal integer
		IF exists (select 1 from BESTELLING where ORDERID = @orderID)
			begin
				set @Workshop = (select WORKSHOPID FROM BESTELLING where ORDERID = @orderID)
				set @Onderdeel = (select ONDERDEELID FROM BESTELLING where ORDERID = @orderID)
				set @Aantal = (select AANTAL FROM BESTELLING where ORDERID = @orderID)
				delete from BESTELLING where ORDERID = @orderID
				IF exists (select 1 from FIETSONDERDEELINWORKSHOP where ONDERDEELID = @Onderdeel and WORKSHOPID = @Workshop)
					begin
					update FIETSONDERDEELINWORKSHOP set AANTAL += @Aantal where ONDERDEELID = @Onderdeel and WORKSHOPID = @Workshop
					end;
				ELSE
					begin
					insert into FIETSONDERDEELINWORKSHOP values(@Onderdeel, @Workshop, @Aantal)
					end;
			end;
		ELSE
			BEGIN
			raiserror('Bestelling bestaat niet',16,1)
			END;
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



--test cases
select * from FIETSONDERDEEL
select * from LEVERANCIER
select * from FIETSONDERDEELBIJLEVERANCIER
select * from WORKSHOP
select * from FIETSONDERDEELINWORKSHOP
select * from BESTELLING

--bestelling '1' bestaat en komt binnen (werkt wel)
begin transaction

select * from BESTELLING
select * from FIETSONDERDEELINWORKSHOP
exec spBestellingKomtBinnen @orderID = '1'
select * from BESTELLING
select * from FIETSONDERDEELINWORKSHOP
rollback transaction

--bestelling '4' bestaat niet (werkt niet)
begin transaction
select * from BESTELLING
select * from FIETSONDERDEELINWORKSHOP
exec spBestellingKomtBinnen @orderID = '4'
select * from BESTELLING
select * from FIETSONDERDEELINWORKSHOP
rollback transaction