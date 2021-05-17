/* Procedure Klant Pakt Fiets											*/ 
/* Parameters:															*/ 
/* @StationID is het station waar de fiets vandaan komt					*/ 
/* @KLANTID is de persoon dat de fiets terug zet						*/ 
/* @fietspostID is het id waar welke fietspost de fiets is uitgehaald 	*/ 

use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spKlantPaktFiets')
DROP PROCEDURE spKlantPaktFiets
GO


CREATE procedure spKlantPaktFiets
(
	@klantID INTEGER,
	@stationID INTEGER,
	@fietspostID INTEGER
)
AS
begin
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
set nocount on
set xact_abort off
declare @TranCount int;
set @TranCount = @@trancount;
if @TranCount > 0 
	save transaction savePoint;
else
	begin transaction;
begin try 

	IF NOT EXISTS (SELECT 1 FROM STATION WHERE STATIONID = @stationID)
	RAISERROR ('Dit station bestaat niet',16,1)
	
	DECLARE @fietsID INT = 0
	-- check of de fiets aanwezig is.
	if exists(select 1 from FIETSPOST f where f.STATIONID = @stationID and f.FIETSPOSTID = @fietspostID)
		set @fietsID = (select FIETSID from FIETSPOST f where f.STATIONID = @stationID and f.FIETSPOSTID = @fietspostID)
	else
		raiserror('Er is geen fiets op deze plek', 16, 1)

	if exists(select 1 from KLANTHEEFTABONNEMENT k 
				INNER JOIN ABONNEMENTTYPE a on k.ABONNEMENTTYPE = a.ABONNEMENTTYPE 
				where k.KLANTID = @klantID 
				and a.LONGTERM = '1' 
				and k.PREPAIDTEGOED is not null 
				and k.EIND_TIJD > GETDATE())
	begin
		if ((select PREPAIDTEGOED from KLANTHEEFTABONNEMENT where KLANTID = @klantID and EIND_TIJD > GETDATE()) > 0)
		begin
			delete from FIETSPOST where FIETSID = @fietsID
			insert into UITGELEENDE_FIETS values(@fietsID,@klantID, GETDATE(), @stationID, '0')
			--insert
		end
		else
			raiserror('U heeft geen prepaidtegoed meer. Waardeer u kaart op.', 16 , 1)
	end
	else
	begin
		delete from FIETSPOST where FIETSID = @fietsID
		insert into UITGELEENDE_FIETS values(@fietsID,@klantID, GETDATE(), @stationID,'0')
	end
end try
begin catch
	if @TranCount = 0
		begin
			if xact_state() = 1 
				rollback transaction;
		end;
	else
		begin
			if xact_state() <> -1  
				rollback transaction savePoint;
		end;
	throw
end catch
END
go

--test cases

select * from KLANT
select * from KLANTHEEFTABONNEMENT
select * from ABONNEMENTTYPE
select * from FIETSPOST
select * from STATION
select * from FIETS
delete from UITGELEENDE_FIETS



insert into FIETS values ('69')
insert into FIETSPOST values ('69', '1', '21', '0')

begin transaction
insert into KLANTHEEFTABONNEMENT values
('standard', '1', '2017-11-28 11:00:00', '2018-11-28 11:00:00', null, '8.12', '0'),
('standard', '2', '2017-11-28 11:00:00', '2018-11-28 11:00:00', '7282782', null, '0'),
('kortstandard', '3', '2017-11-28 11:00:00', '2017-12-05 11:00:00', '323313', null, '0')
commit transaction


--test
begin transaction
exec spKlantPaktFiets @klantID = '1', @stationID = '1', @fietspostID = '21'
select * from FIETSPOST
select * from UITGELEENDE_FIETS
rollback transaction

UPDATE KLANTHEEFTABONNEMENT SET PREPAIDTEGOED = '-1' where KLANTID = '1'

select PREPAIDTEGOED from KLANTHEEFTABONNEMENT where KLANTID= '1' and EIND_TIJD > GETDATE()

/*	17 januari test UC3 testcase 1	*/
begin transaction
exec spKlantPaktFiets @klantID = '4', @stationID = '1', @fietspostID = '1'
select * from FIETSPOST
select * from UITGELEENDE_FIETS
rollback transaction

/*	17 januari test UC3 testcase 2	*/
begin transaction
exec spKlantPaktFiets @klantID = '2', @stationID = '1', @fietspostID = '1'
select * from FIETSPOST
select * from UITGELEENDE_FIETS
rollback transaction

/*	17 januari test UC3 testcase 3	*/
begin transaction
exec spKlantPaktFiets @klantID = '4', @stationID = '1', @fietspostID = '1'
select * from FIETSPOST
select * from UITGELEENDE_FIETS
rollback transaction

/*	17 januari test UC3 testcase 4	*/
begin transaction
update KLANTHEEFTABONNEMENT
SET PREPAIDTEGOED = -10
WHERE KLANTID = 4
exec spKlantPaktFiets @klantID = '4', @stationID = '1', @fietspostID = '1'
select * from FIETSPOST
select * from UITGELEENDE_FIETS
rollback transaction