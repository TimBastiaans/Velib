use Velib;
GO

--Trigger voor BR1
CREATE TRIGGER BR1_leverancier_info
ON dbo.LEVERANCIER
AFTER INSERT,UPDATE
AS
begin
if @@rowcount=0 return
set nocount on
begin try
	if exists(select 1 from inserted where TELEFOONNUMMER is null and E_MAILADRES is null)
		raiserror('Geen telefoonnummer of emailadres, een van de twee is nodig',16,1)
end try
begin catch
	throw 
end catch
end		
GO

--testcases voor BR1

--insert meerdere goede rijen, werkt wel
begin transaction
insert into LEVERANCIER (LEVERANCIERID, NAAM, TELEFOONNUMMER, E_MAILADRES) values
('1', 'Da best leverancier', '0673664657', 'dikemail@gmail.com'),
('2', 'Da second best leverancier', NULL, 'dikemail@gmail.com'),
('3', 'Da third best leverancier', '0673894762', NULL)
select * from LEVERANCIER
rollback transaction

--insert een combinatie van goede en foute rijen, werkt niet
begin transaction
insert into LEVERANCIER (LEVERANCIERID, NAAM, TELEFOONNUMMER, E_MAILADRES) values
('1', 'Da best leverancier', NULL, 'dikemail@gmail.com'),
('2', 'Da second best leverancier', NULL, NULL)
select * from LEVERANCIER
rollback transaction
go

--################################################  END BR1  ############################################################

--Trigger voor BR2
CREATE TRIGGER BR2_abonnement_info
ON dbo.KLANTHEEFTABONNEMENT
AFTER INSERT,UPDATE
AS
begin
if @@rowcount=0 return
set nocount on
begin try
	if exists(select 1 from inserted where CREDITKAARTNUMMER is null and PREPAIDTEGOED is null)
		raiserror('Geen creditkaartnummer of prepaid, een van de twee is nodig',16,1)
	if exists(select 1 from inserted where CREDITKAARTNUMMER is not null and PREPAIDTEGOED is not null)
		raiserror('Prepaidtegoed is niet nodig als er een creditkaartnummer is',16,1)
end try
begin catch
	throw 
end catch
end		
GO

--test cases
begin transaction
insert into KLANT values
('1', 'Jaco', 'Schalij', 'tha place', '6536TB', '1995-11-13', '1', '0'),
('2', 'Tim', 'Achternaam', 'tha other place', '6136KL', '1995-11-13', '1', '0'),
('3', 'Spongebob', 'Squarepants', 'an ananas under the sea', '9482IK', '1995-11-13', '0', '1')
insert into ABONNEMENTTYPE values
('kortstandard', '2', 'week', '0'),
('standard', '40', 'year', '1')
commit transaction

--insert meerdere goede rijen.
begin transaction
insert into KLANTHEEFTABONNEMENT values
('standard', '1', '2017-11-28 11:54:13', '2018-11-28 11:54:13', '833929', NULL, '1'),
('standard', '2', '2017-11-28 11:54:13', '2018-11-28 11:54:13', NULL, '5.12', '1')
select * from KLANTHEEFTABONNEMENT
rollback transaction

--insert een foute rij (fout is geen creditkaart of prepaid)
begin transaction
insert into KLANTHEEFTABONNEMENT values
('standard', '1', '2017-11-28 11:54:13', '2018-11-28 11:54:13', NULL, NULL, '1')
select * from KLANTHEEFTABONNEMENT
rollback transaction

--insert een foute rij (fout is creditkaart EN prepaid)
begin transaction
insert into KLANTHEEFTABONNEMENT values
('standard', '1', '2017-11-28 11:54:13', '2018-11-28 11:54:13', '833929', '7.12', '1'),
('standard', '2', '2017-11-28 11:54:13', '2018-11-28 11:54:13', NULL, '5.12', '1')
select * from KLANTHEEFTABONNEMENT
rollback transaction
go
--###################################################  END BR2  #####################################################

--trigger voor BR3: Alleen klanten met een Long term abonnement kunnen een prepaid kaart hebben.
CREATE TRIGGER BR3_prepaid_voor_longterm
ON dbo.KLANTHEEFTABONNEMENT
AFTER INSERT,UPDATE
AS
begin
if @@rowcount=0 return
set nocount on
begin try
	if exists(select 1 from inserted i INNER JOIN ABONNEMENTTYPE t ON i.ABONNEMENTTYPE = t.ABONNEMENTTYPE 
	where i.PREPAIDTEGOED is not null and t.LONGTERM = '0')
		raiserror('Shortterm abonnement kan geen prepaidkaart hebben',16,1)
end try
begin catch
	throw 
end catch
end		
GO

select * from ABONNEMENTTYPE

--test cases
--insert twee goede rijen (een kort abbo met een creditkaart, en een long abbo met een prepaidkaart)
begin transaction
insert into KLANTHEEFTABONNEMENT values
('kortstandard', '1', '2017-11-28 11:54:13', '2018-11-28 11:54:13', '833929', NULL, '0'),
('standard', '2', '2017-11-28 11:54:13', '2018-11-28 11:54:13', NULL, '5.12', '1')
select * from KLANTHEEFTABONNEMENT
rollback transaction

--insert een longterm abbo met een prepaid kaart, en een shortterm abbo met een prepaidkaart, result in error
begin transaction
insert into KLANTHEEFTABONNEMENT values
('standard', '1', '2017-11-28 11:54:13', '2018-11-28 11:54:13', NULL, '7.12', '1'),
('kortstandard', '2', '2017-11-28 11:54:13', '2018-11-28 11:54:13', NULL, '5.12', '1')
select * from KLANTHEEFTABONNEMENT
rollback transaction
go
--################################################  END BR3  ###########################################################

--Trigger BR4
CREATE TRIGGER BR4_max_onderdelen
ON Bestelling
AFTER INSERT, UPDATE
AS
begin
if @@rowcount=0 return
set nocount on
begin try
	if exists(select 1 from inserted i	INNER JOIN FIETSONDERDEEL o ON i.ONDERDEELID = o.ONDERDEELID 
										INNER JOIN BESTELLING b ON i.ONDERDEELID = b.ONDERDEELID and i.WORKSHOPID = b.WORKSHOPID  
										INNER JOIN FIETSONDERDEELINWORKSHOP foiw ON i.ONDERDEELID = foiw.ONDERDEELID and i.WORKSHOPID = foiw.WORKSHOPID 
	where i.AANTAL +  b.AANTAL + foiw.AANTAL > o.MAXIMUM_AANTAL)
		raiserror('Teveel besteld',16,1)
	if exists(select 1 from inserted i inner join FIETSONDERDEEL f on i.ONDERDEELID = f.ONDERDEELID where i.AANTAL > f.MAXIMUM_AANTAL)
		raiserror('Teveel besteld', 16, 1)
	if exists(select 1 from inserted i inner join FIETSONDERDEELINWORKSHOP foiw on i.ONDERDEELID = foiw.ONDERDEELID 
										inner join FIETSONDERDEEL f on i.ONDERDEELID = f.ONDERDEELID
										where foiw.AANTAL + i.AANTAL > f.MAXIMUM_AANTAL and i.WORKSHOPID = foiw.WORKSHOPID)
		raiserror('Teveel besteld', 16, 1)
end try
begin catch
	throw 
end catch
end		
GO

select * from LEVERANCIER

--test cases

--situatie beschrijving: workshop 1 heeft 10 zadels, er zijn er 5 besteld, en er kunnen er maximaal 20 zijn.
--dus er kunnen er nog 5 besteld worden, maar niet 6
begin transaction
insert into FIETSONDERDEEL values
('1', 'zadel', 'om op te zitten tijdens het fietsen', '20', '0')
insert into WORKSHOP values
('1', 'fietspad'),
('2', 'fietspad')
insert into LEVERANCIER values
('1', 'Da best leverancier', '0673664657', 'dikemail@gmail.com')

insert into FIETSONDERDEELBIJLEVERANCIER values
('1', '1', '20.00')--zadel is te koop bij Da best leverancier voor 20 euro
insert into BESTELLING values
('1', '1', '1', '1', '2017-11-28 11:54:13', '5'),
('6', '2', '1', '1', '2017-11-28 11:54:13', '9')--er zijn 9 zadels besteld voor workshop 2
insert into FIETSONDERDEELINWORKSHOP values
('1', '1', '10')--er zijn 10 zadels in workshop 1
commit transaction

delete from BESTELLING
select * from FIETSONDERDEELINWORKSHOP
--kan wel
begin transaction
insert into BESTELLING values
('2', '1', '1', '1', '2017-11-28 11:54:13', '4')--er zijn 4 zadels besteld voor workshop 1
rollback transaction

--kan niet
begin transaction
insert into BESTELLING values
('2', '1', '1', '1', '2017-11-28 11:54:13', '6')--er zijn 6 zadels besteld voor workshop 1
rollback transaction




--nu kan dit wel, omdat de vorige bestelling al deel is van de 10 zadels die in de workshop liggen(situatie is veranderd)
begin transaction
insert into BESTELLING values
('2', '1', '1', '1', '2017-11-28 11:54:13', '4', '0')--er zijn 4 zadels besteld voor workshop 1
rollback transaction
go
--######################################################  END BR4  ##############################################

--TRIGGER1 BR5
CREATE TRIGGER BR5_outQueue
ON FIETS
AFTER INSERT, UPDATE
AS
begin
if @@rowcount=0 return
set nocount on
begin try
	if exists(SELECT 1 FROM inserted i INNER JOIN REPARATIEQUEUE q ON i.FIETSID = q.FIETSID where i.WORKSHOPID is not null)
		raiserror('Fiets staat nog in reparatieQueue',16,1)
	if exists(SELECT 1 FROM inserted i INNER JOIN FIETSPOST q ON i.FIETSID = q.FIETSID where i.WORKSHOPID is not null)
		raiserror('Fiets staat nog in station',16,1)
	if exists(SELECT 1 FROM inserted i INNER JOIN UITGELEENDE_FIETS l ON i.FIETSID = l.FIETSID where i.WORKSHOPID is not null)
		raiserror('Fiets is uitgeleend',16,1)
end try
begin catch
	throw 
end catch
end		
GO

CREATE TRIGGER BR5_reparatieQueue
ON REPARATIEQUEUE
AFTER INSERT, UPDATE
AS
begin
if @@rowcount=0 return
set nocount on
begin try
	if exists(SELECT 1 FROM inserted i INNER JOIN FIETS q ON i.FIETSID = q.FIETSID where q.WORKSHOPID is not null)
		raiserror('Fiets staat nog in outQueue',16,1)
	if exists(SELECT 1 FROM inserted i INNER JOIN FIETSPOST q ON i.FIETSID = q.FIETSID)
		raiserror('Fiets staat nog in station',16,1)
	if exists(SELECT 1 FROM inserted i INNER JOIN UITGELEENDE_FIETS l ON i.FIETSID = l.FIETSID)
		raiserror('Fiets is uitgeleend',16,1)
end try
begin catch
	throw 
end catch
end		
GO

CREATE TRIGGER BR5_STATION
ON FIETSPOST
AFTER INSERT, UPDATE
AS
begin
if @@rowcount=0 return
set nocount on
begin try
	if exists(SELECT 1 FROM inserted i INNER JOIN REPARATIEQUEUE q ON i.FIETSID = q.FIETSID)
		raiserror('Fiets staat nog in reparatieQueue',16,1)
	if exists(SELECT 1 FROM inserted i INNER JOIN FIETS q ON i.FIETSID = q.FIETSID where q.WORKSHOPID is not null)
		raiserror('Fiets staat nog in outQueue',16,1)
	if exists(SELECT 1 FROM inserted i INNER JOIN UITGELEENDE_FIETS l ON i.FIETSID = l.FIETSID)
		raiserror('Fiets is uitgeleend',16,1)
end try
begin catch
	throw 
end catch
end		
GO

CREATE TRIGGER BR5_Lening
ON UITGELEENDE_FIETS
AFTER INSERT, UPDATE
AS
begin
if @@rowcount=0 return
set nocount on
begin try
	
	if exists(SELECT 1 FROM inserted i INNER JOIN FIETSPOST l ON i.FIETSID = l.FIETSID)
		raiserror('Fiets staat nog in station',16,1)
	if exists(SELECT 1 FROM inserted i INNER JOIN FIETS l ON i.FIETSID = l.FIETSID where l.WORKSHOPID is not null)
		raiserror('Fiets staat nog in outQ',16,1)
	if exists(SELECT 1 FROM inserted i INNER JOIN REPARATIEQUEUE l ON i.FIETSID = l.FIETSID)
		raiserror('Fiets staat nog in repQ',16,1)
end try
begin catch
	throw 
end catch
end		
GO

--de where clause zou eventueel eruit kunnen

--test cases
--situatie: er zijn 6 fietsen, '1' staat op station, '2' staat in repQ, '3' staat in outQ
begin transaction
insert into WORKSHOP values
('3', 'ookInFrankrijk')
insert into FIETS values
('1', null),
('2', null),
('3', '3'),
('4', null),
('5', null),
('6', null)
insert into STATION values
('1', '1', '1', 'frankrijk', '40', '0')
insert into FIETSPOST values
('1', '1', '1', '0') -- fiets 1 staat in station 1
insert into REPARATIEQUEUE values
('3', '1', '2', 'Yo this bike messed up, yo', '0') -- fiets 2 staat in de repQ van workshop 3
commit transaction


--kan wel
begin transaction
insert into REPARATIEQUEUE values 
('3', '2', '4', 'bike broke', '0'),
('3', '3', '5', 'this one too', '0')
insert into FIETSPOST values
('1', '2', '6', '0')
commit transaction

--kan niet, omdat fiets nog in een station staat
begin transaction
insert into FIETSPOST values
('1', '3', '6', '0')
update FIETS set WORKSHOPID = '3' where FIETSID = '6'

rollback transaction


--#####################################  END BR5  ################################################################


CREATE TRIGGER BR6_monteurdienst
ON MONTEURDIENST
AFTER INSERT,UPDATE
AS
begin
if @@rowcount=0 return
set nocount on
begin try
	if exists(SELECT 1 FROM inserted i INNER JOIN MONTEURDIENST m ON i.WERKNEMERID = m.WERKNEMERID
				WHERE (i.START_DATUM < m.EIND_TIJD and i.START_DATUM > m.START_DATUM )OR (m.START_DATUM > i.START_DATUM and m.START_DATUM < i.EIND_TIJD))
		raiserror('Overlappende werkdiensten',16,1)
	
end try
begin catch
	throw 
end catch
end		
GO

begin transaction 
insert into WERKNEMER values
('1', 'J', 'Skizzle', 'yo momma place', '1234YM', 'wait, word')
commit transaction

--kan wel
begin transaction
insert into MONTEURDIENST values
('1', '2017-11-28 11:00:00', '3', '2017-11-28 17:00:00'),
('1', '2017-11-29 11:00:00', '3', '2017-11-29 17:00:00')
rollback transaction



--kan niet
begin transaction
insert into MONTEURDIENST values
('1', '2017-11-28 11:00:00', '3', '2017-11-28 17:00:00'),
('1', '2017-11-28 09:00:00', '3', '2017-11-28 13:00:00')
rollback transaction


--################################################  END BR6  ###############################################

--TRIGGER BR7
CREATE TRIGGER BR7_KlantHeeftMaarEenAbonnement
ON KLANTHEEFTABONNEMENT
AFTER INSERT,UPDATE
AS
begin
if @@rowcount=0 return
set nocount on
begin try
	
	if exists(select 1 from inserted i INNER JOIN KLANTHEEFTABONNEMENT k ON i.KLANTID = k.KLANTID where i.EIND_TIJD > GETDATE() and k.EIND_TIJD > GETDATE() and i.START_DATUM != k.START_DATUM)
		raiserror('Ge het toch al unne abonnement jonge',16,1)
	
end try
begin catch
	throw 
end catch
end		
GO

select * from KLANT


--kan wel, omdat het abonnement al afgelopen is
begin transaction 
insert into ABONNEMENTTYPE values
('standard', '12.20', '365', '1')
insert into KLANTHEEFTABONNEMENT values
('standard', '1', '2017-11-28 11:00:00', '2018-11-28 11:00:00', null, '1', '0')
commit transaction

--kan niet, omdat klant '1' al een lopend abonnement heeft
begin transaction 
insert into KLANTHEEFTABONNEMENT values
('standard', '1', '2017-11-26 11:00:00', '2018-11-28 11:00:00', null, '1', '0')
rollback transaction

--######################################  END BR7  ############################################################

--trigger BR8 niet meer nodig sinds 14-12
CREATE TRIGGER BR8_FietspostHeeftMaarEenFiets
ON Fietspost
AFTER INSERT,UPDATE
AS
begin
if @@rowcount=0 return
set nocount on
begin try
	if (select top 1 count(*) as total from Fietspost group by STATIONID, FIETSPOSTID order by total desc) > 1
	begin
		--select * from Fietspost
		--select * from inserted i inner join Fietspost f on i.STATIONID = f.STATIONID where i.FIETSPOST = f.FIETSPOST and i.STATIONID = f.STATIONID
		raiserror('Hier staat al een fiets',16,1)
	end
	
end try
begin catch
	throw 
end catch
end		
GO

--test cases

insert into FIETS values ('10'),('11'),('12')
select * from STATION
insert into STATION values 
('2', '2', '1', 'parijs', '40', '0')

--kan wel
begin transaction
insert into Fietspost values 
('10', '1', '7', '0'),
('11', '1', '8', '0')
rollback transaction

--kan niet, omdat fiets '10' al op fietspost 7 staat
begin transaction
insert into Fietspost values 
('10', '1', '7', '0'),
('11', '1', '8', '0'),
('12', '1', '7', '0')
rollback transaction

--############################################  END BR8  ############################################################

-- TRIGGER BR9

CREATE TRIGGER BR9_AutomatischVerlengen
ON KLANTHEEFTABONNEMENT
AFTER INSERT,UPDATE
AS
begin
if @@rowcount=0 return
set nocount on
begin try
	if exists (select 1 from KLANTHEEFTABONNEMENT a inner join ABONNEMENTTYPE t on a.ABONNEMENTTYPE = t.ABONNEMENTTYPE where t.LONGTERM = '0' and a.AUTOMATISCH_VERLENGT = '1')
		raiserror('short term abonnementen kunnen niet automatisch worden verlengt', 16, 1)
	
end try
begin catch
	throw 
end catch
end		
GO

--test cases
delete from KLANTHEEFTABONNEMENT
select * from ABONNEMENTTYPE

--klant '1' koopt een longterm abonnement en wil deze automatisch laten verlengen. (kan wel)
begin transaction
insert into KLANTHEEFTABONNEMENT values
('standard', '1', '2017-11-26 11:00:00', '2018-11-26 11:00:00', '929292', null, '1'),
('standard', '2', '2017-11-26 11:00:00', '2018-11-26 11:00:00', '929292', null, '1')
rollback transaction

--klant '1' koopt een short term abonnement en wil deze automatisch laten verlengen. (kan niet)
begin transaction
insert into KLANTHEEFTABONNEMENT values
('standard', '2', '2017-11-26 11:00:00', '2018-11-26 11:00:00', '929292', null, '1'),
('kortstandard', '1', '2017-11-26 11:00:00', '2018-11-26 11:00:00', '929292', null, '1') 
rollback transaction


--###############################################  END BR9  #######################################################

--TRIGGER BR10
--niet meer nodig sinds 9 january versie 1.3
CREATE TRIGGER BR10_OpenLening
ON LENING
AFTER INSERT,UPDATE
AS
begin
if @@rowcount=0 return
set nocount on
begin try
	if exists (select 1 from inserted i where i.[TO] is null and i.EINDSTATION is not null or i.[TO] is not null and i.EINDSTATION is null or 
												i.[TO] is null and i.PRIJS is not null or i.[TO] is not null and i.PRIJS is null or
												i.EINDSTATION is null and i.PRIJS is not null or i.EINDSTATION is not null and i.PRIJS is null)
		raiserror('dit kun je niet invullen in lening', 16, 1)
	
end try
begin catch
	throw 
end catch
end		
GO

select * from STATION
select * from KLANT
select * from FIETS
select * from REPARATIEQUEUE
delete from Fietspost where FIETSID = '1'

--klant '1' heeft fiets '1' geleend van 11 tot 12 uur, van station '1' naar station '2' (kan wel)
--klant '2' heeft fiets '12' geleend op 11 uur, en deze nog niet teruggebracht (kan wel)
begin transaction
insert into LENING values
('1', '2017-11-26 11:00:00', '1', '2017-11-26 12:00:00', '1', '2', '5.00', '0'),
('12', '2017-12-05 11:00:00', '2', null, '1', null, null, '0')
rollback transaction



--klant '1' heeft fiets '1' geleend van 11 tot 12 uur, van station '1' naar station ? (kan niet)
begin transaction
insert into LENING values
('1', '2017-11-26 11:00:00', '1', '2017-11-26 12:00:00', '1', null, '5.00', '0'),
('12', '2017-12-05 11:00:00', '1', null, '1', null, null, '0')
rollback transaction

--##########################################  END BR10  #############################################################

--TRIGGER BR14
CREATE TRIGGER BR14_LeenMetAbonnement
ON UITGELEENDE_FIETS
AFTER INSERT,UPDATE
AS
begin
if @@rowcount=0 return
set nocount on
begin try
	if not exists (select 1 from inserted i inner join KLANTHEEFTABONNEMENT k on i.KLANTID = k.KLANTID where k.EIND_TIJD > GETDATE())
		raiserror('klant heeft geen abonnement, dus je kan geen fiets lenen', 16, 1)
	
end try
begin catch
	throw 
end catch
end		
GO

--test cases

--klant '20' koopt een abonnement, en huurt een fiets (kan wel)
begin transaction
insert into KLANT values
('20', 'YO', 'MOMMA', 'iknowwhere', '6969YM', '1972-11-21', '0', '0')
insert into KLANTHEEFTABONNEMENT values
('standard', '20', '2017-12-05 11:00:00', '2018-12-05 11:00:00', '9393939', null, '0')
insert into FIETS values ('69', null)
insert into Fietspost values ('1', '8', '69', '0')
delete from Fietspost where FIETSID = '69'
insert into UITGELEENDE_FIETS values
('69', '20', '2017-12-05 11:30:00', '1', '0')
rollback transaction



--klant '20' huurt een fiets zonder een abbo te hebben (kan niet)
begin transaction
insert into KLANT values
('20', 'YO', 'MOMMA', 'iknowwhere', '6969YM', '1972-11-21', '0', '0')
--insert into KLANTHEEFTABONNEMENT values ('standard', '20', '2017-12-05 11:00:00', '2018-12-05 11:00:00', '9393939', null, '0')
insert into FIETS values ('69', null)
insert into Fietspost values ('1', '8', '69', '0')
delete from Fietspost where FIETSID = '69'
insert into UITGELEENDE_FIETS values
('69', '20', '2017-12-05 11:30:00', '1', '0')
rollback transaction

--########################################################  end br14  ####################################################


CREATE TRIGGER BR15_WerknemerWerkelijkWerkt
ON ONGROUNDCONTROLE
AFTER INSERT, UPDATE
AS
BEGIN
IF @@ROWCOUNT = 0 RETURN
SET NOCOUNT ON
BEGIN TRY

	IF NOT EXISTS(
		SELECT * FROM inserted i
		INNER JOIN WERKNEMER wgt ON wgt.WERKNEMERID = i.WERKNEMERID
		INNER JOIN ROUTINGCARD rc ON rc.TEAMID = wgt.TEAMID
		WHERE CAST(i.DATUM AS DATE) = CAST(rc.RITDATUM AS date)
		AND i.WERKNEMERID = wgt.WERKNEMERID
	)
	BEGIN
		RAISERROR ('de werknemer heeft niet gewerkt op dat moment',16,1)
	END

END TRY
BEGIN CATCH
	THROW
END CATCH
END
GO

-- testscript
begin transaction
delete from MONTEURDIENST

delete from ROUTINGCARD
delete from ONGROUNDCONTROLE
delete from ONGROUNDTEAM
delete from FIETSPOST
delete from REPARATIEQUEUE
delete from FIETS
delete from WERKNEMER
delete from STATION

insert STATION values(1,1,1,'halamagalama',23,0)
insert FIETS values(1,null)
insert ONGROUNDTEAM values(1)
insert WERKNEMER values(1, '1','michiel','idema','halamagalama','6545HA','aegaegawgeagaegahei')

insert ROUTINGCARD values(1,'12-13-2014',1)

--test deze moet goed gaan omdat de werknemer op die dag gewerkt heeft
print 'Deze moet goed gaan'
insert ONGROUNDCONTROLE values(1,'12-13-2014 10:30:14',1,'halamagalama')

--test deze moet fout gaan omdat de werknemer op die dag niet gewerkt heeft
print 'Deze moet fout gaan'
insert ONGROUNDCONTROLE values(1,'12-09-2014 10:30:14',1,'halamagalama')
rollback transaction


--############################################ END BR15  ##########################################################

--BR11, BR12, BR13

CREATE TRIGGER BR1123
ON dbo.KLANTHEEFTABONNEMENT
AFTER INSERT,UPDATE
AS
begin
if @@rowcount=0 return
set nocount on
begin try
	declare @klantid int
	if exists(select 1 from inserted i inner join KLANT k on i.KLANTID = k.KLANTID where i.ABONNEMENTTYPE = 'Velib Passion Young' and k.GEBOORTEDATUM < cast(DATEADD(year, -27, getdate()) as date))
		raiserror('deze klant is te oud voor een Velib Passion Young abonnement',16,1)
	if exists(select 1 from inserted i inner join KLANT k on i.KLANTID = k.KLANTID where i.ABONNEMENTTYPE = 'Velib Passion Student' and (k.GEBOORTEDATUM < cast(DATEADD(year, -27, getdate()) as date) or k.IS_STUDENT = '0'))
		raiserror('deze klant is geen student jonger dan 27 jaar, en kan dus geen student abonnement afsluiten', 16,1)
	if exists(select 1 from inserted i inner join KLANT k on i.KLANTID = k.KLANTID where i.ABONNEMENTTYPE = 'Velib Passion Socio' and (k.GEBOORTEDATUM < cast(DATEADD(year, -26, getdate())as date) or k.IS_SOCIO = '0'))
		raiserror('deze klant is geen socio medewerker jonger dan 26 jaar, en kan dus geen socio abonnement afsluiten', 16,1)
end try
begin catch
	throw 
end catch
end		
GO

begin tran
insert into KLANT values
('1', 'Jaco', 'Schalij', 'tha place', '6536TB', '1995-11-13', '1', '0'),
('2', 'Tim', 'Achternaam', 'tha other place', '6136KL', '1975-11-13', '1', '0'),
('3', 'Spongebob', 'Squarepants', 'an ananas under the sea', '9482IK', '1995-11-13', '0', '1')
--test successcenarios
insert into KLANTHEEFTABONNEMENT values
('Velib Passion Student', '1', getdate(), DATEADD(day, 365, GETDATE()), '3422442', null, '0')
insert into KLANTHEEFTABONNEMENT values
('Velib Passion Socio', '3', getdate(), DATEADD(day, 365, GETDATE()), '3422442', null, '0')

rollback tran

begin tran
insert into KLANT values
('1', 'Jaco', 'Schalij', 'tha place', '6536TB', '1995-11-13', '1', '0'),
('2', 'Tim', 'Achternaam', 'tha other place', '6136KL', '1975-11-13', '1', '0'),
('3', 'Spongebob', 'Squarepants', 'an ananas under the sea', '9482IK', '1995-11-13', '0', '1')
--test failscenario
insert into KLANTHEEFTABONNEMENT values
('Velib Passion Young', '2', getdate(), DATEADD(day, 365, GETDATE()), '3422442', null, '0')
insert into KLANTHEEFTABONNEMENT values
('Velib Passion Student', '2', getdate(), DATEADD(day, 365, GETDATE()), '3422442', null, '0')

rollback tran


--############################################# END BR11,12,13   #################################################################



--constraint br16
alter table UITGELEENDE_FIETS add constraint BR16_EenLeningPerKlant UNIQUE(KLANTID)

--test successcenario
begin tran
select * from UITGELEENDE_FIETS
insert into FIETS values
('1', null), ('2', null)
insert into STATION values
('1', '1', '1', 'hier', '50', '0')
insert into FIETSPOST values
('1', '1', '1', '0'), ('1', '2', '2', '0')
insert into KLANT values
('1', 'Jaco', 'Schalij', 'tha place', '6536TB', '1995-11-13', '1', '0')
insert into KLANTHEEFTABONNEMENT values
('Velib Passion Student', '1', GETDATE(), DATEADD(day, 365, GETDATE()), '3422442', null, '0')
exec sp_KlantPaktFiets 1,1,1
select * from FIETSPOST
select * from UITGELEENDE_FIETS
rollback tran


--test failscenario
begin tran
select * from UITGELEENDE_FIETS
insert into FIETS values
('1', null), ('2', null)
insert into STATION values
('1', '1', '1', 'hier', '50', '0')
insert into FIETSPOST values
('1', '1', '1', '0'), ('1', '2', '2', '0')
insert into KLANT values
('1', 'Jaco', 'Schalij', 'tha place', '6536TB', '1995-11-13', '1', '0')
insert into KLANTHEEFTABONNEMENT values
('Velib Passion Student', '1', GETDATE(), DATEADD(day, 365, GETDATE()), '3422442', null, '0')
begin try
exec sp_KlantPaktFiets 1,1,1
exec sp_KlantPaktFiets 1,1,2
end try
begin catch
print 'foutje'
end catch
select * from UITGELEENDE_FIETS
rollback tran


