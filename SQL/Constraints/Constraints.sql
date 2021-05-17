USE Velib
GO

IF EXISTS(select * from sys.objects where type = 'TR' AND name='BR1_leverancier_info')
DROP TRIGGER BR1_leverancier_info
GO
IF EXISTS(select * from sys.objects where type = 'TR' AND name='BR2_abonnement_info')
DROP TRIGGER BR2_abonnement_info
GO
IF EXISTS(select * from sys.objects where type = 'TR' AND name='BR3_prepaid_voor_longterm')
DROP TRIGGER BR3_prepaid_voor_longterm
GO
IF EXISTS(select * from sys.objects where type = 'TR' AND name='BR4_max_onderdelen')
DROP TRIGGER BR4_max_onderdelen
GO
IF EXISTS(select * from sys.objects where type = 'TR' AND name='BR5_outQueue')
DROP TRIGGER BR5_outQueue
GO
IF EXISTS(select * from sys.objects where type = 'TR' AND name='BR5_reparatieQueue')
DROP TRIGGER BR5_reparatieQueue
GO
IF EXISTS(select * from sys.objects where type = 'TR' AND name='BR5_STATION')
DROP TRIGGER BR5_STATION
GO
IF EXISTS(select * from sys.objects where type = 'TR' AND name='BR5_Lening')
DROP TRIGGER BR5_Lening
GO
IF EXISTS(select * from sys.objects where type = 'TR' AND name='BR6_monteurdienst')
DROP TRIGGER BR6_monteurdienst
GO
IF EXISTS(select * from sys.objects where type = 'TR' AND name='BR7_KlantHeeftMaarEenAbonnement')
DROP TRIGGER BR7_KlantHeeftMaarEenAbonnement
GO
IF EXISTS(select * from sys.objects where type = 'TR' AND name='BR8_FietspostHeeftMaarEenFiets')
DROP TRIGGER BR8_FietspostHeeftMaarEenFiets
GO
IF EXISTS(select * from sys.objects where type = 'TR' AND name='BR9_AutomatischVerlengen')
DROP TRIGGER BR9_AutomatischVerlengen
GO
IF EXISTS(select * from sys.objects where type = 'TR' AND name='BR10_OpenLening')
DROP TRIGGER BR10_OpenLening
GO
IF EXISTS(select * from sys.objects where type = 'TR' AND name='BR14_LeenMetAbonnement')
DROP TRIGGER BR14_LeenMetAbonnement
GO

IF EXISTS(select * from sys.objects where type = 'TR' AND name='BR1123')
DROP TRIGGER BR1123
GO

IF EXISTS(select * from sys.objects where type = 'TR' AND name='BR15_check_werknemer_actief_tijdens_ongroundcontrole')
DROP TRIGGER BR15_check_werknemer_actief_tijdens_ongroundcontrole
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

--######################################  END BR7  ############################################################


--trigger BR8 niet meer nodig sinds 14-12



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

--###############################################  END BR9  #######################################################

--TRIGGER BR10

--niet meer nodig sinds 9 january versie 1.3

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

--##########################################  END BR14   ##############################################################

--trigger BR15
CREATE TRIGGER BR15_check_werknemer_actief_tijdens_ongroundcontrole
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



--##########################################  END BR15   ##############################################################


--trigger br11,12,13
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

--alle triggers zijn getest in het bestand Constraints_met_tests.sql

