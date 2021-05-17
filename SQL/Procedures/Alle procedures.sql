-- transactie Abonnement kopen
USE Velib
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE [type] = 'P' AND [name] = 'spAbonnementKopen')
BEGIN DROP PROCEDURE spAbonnementKopen END
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spFietsRedistributie')
DROP PROCEDURE spFietsRedistributie
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spKlantPaktFiets')
DROP PROCEDURE spKlantPaktFiets
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spFiets_word_in_FIETSPOST_gezet')
DROP PROCEDURE spFiets_word_in_FIETSPOST_gezet
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spOpwaardeerKaart')
DROP PROCEDURE spOpwaardeerKaart
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spFietsNaarWorkshop')
DROP PROCEDURE spFietsNaarWorkshop
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spMarkeerFiets')
DROP PROCEDURE spMarkeerFiets
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE [type] = 'P' AND [name] = 'spOngroundControle')
BEGIN DROP PROCEDURE spOngroundControle END
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE [type] = 'P' AND [name] = 'spFietsNaarOutqueue')
BEGIN DROP PROCEDURE spFietsNaarOutqueue END
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spFietsNaarStation')
DROP PROCEDURE spFietsNaarStation
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spFietsTerugInRepQueue')
DROP PROCEDURE spFietsTerugInRepQueue
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spInventarisBijwerken')
DROP PROCEDURE spInventarisBijwerken
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE [type] = 'P' AND [name] = 'spOnderdeelbestellen')
BEGIN DROP PROCEDURE spOnderdeelbestellen END
GO


IF EXISTS(select * from sys.objects where type = 'P' AND name='spPakFietsOmTeRepareren')
DROP PROCEDURE spPakFietsOmTeRepareren
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spVoegReparatieToe')
DROP PROCEDURE spVoegReparatieToe
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spAdminToevoegen')
DROP PROCEDURE spAdminToevoegen
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spBestellingKomtBinnen')
DROP PROCEDURE spBestellingKomtBinnen
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE [type] = 'P' AND [name] = 'spBestellingVerwijderen')
BEGIN DROP PROCEDURE spBestellingVerwijderen END
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spControleTaakToevoegen')
DROP PROCEDURE spControleTaakToevoegen
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spControleTaakVerwijderen')
DROP PROCEDURE spControleTaakVerwijderen
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spFietsToevoegen')
DROP PROCEDURE spFietsToevoegen
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spFietsVerwijderen')
DROP PROCEDURE spFietsVerwijderen
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spKoppelOnderdeelAanLeverancier')
DROP PROCEDURE spKoppelOnderdeelAanLeverancier
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spLeverancierToevoegen')
DROP PROCEDURE spLeverancierToevoegen
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spLeverancierVerwijderen')
DROP PROCEDURE spLeverancierVerwijderen
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spOnderdeelToevoegen')
DROP PROCEDURE spOnderdeelToevoegen
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spOnderdeelVerwijderen')
DROP PROCEDURE spOnderdeelVerwijderen
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spRoosterMToevoegen')
DROP PROCEDURE spRoosterMToevoegen
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE [type] = 'P' AND [name] = 'spRoutingCardToevoegen')
BEGIN DROP PROCEDURE spRoutingCardToevoegen END
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spSpeciaalEventToevoegen')
DROP PROCEDURE spSpeciaalEventToevoegen
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spSpeciaalEventVerwijderen')
DROP PROCEDURE spSpeciaalEventVerwijderen
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spStationVoorSpeciaalEvenementToevoegen')
DROP PROCEDURE spStationVoorSpeciaalEvenementToevoegen
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spStationVoorSpeciaalEvenementVerwijderen')
DROP PROCEDURE spStationVoorSpeciaalEvenementVerwijderen
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spToggleWerknemerActief')
BEGIN DROP PROCEDURE spToggleWerknemerActief END
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spVerwijderKoppelingOnderdeelBijLeverancier')
DROP PROCEDURE spVerwijderKoppelingOnderdeelBijLeverancier
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spWerknemerToevoegen')
DROP PROCEDURE spWerknemerToevoegen
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spWerknemerVerwijderen')
DROP PROCEDURE spWerknemerVerwijderen
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE [type] = 'P' AND [name] = 'spZetWerknemerInTeam')
BEGIN DROP PROCEDURE spZetWerknemerInTeam END
GO

CREATE PROCEDURE spZetWerknemerInTeam
	@WERKNEMERID INT,
	@TEAMID INT
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
	
	IF NOT EXISTS (SELECT 1 FROM ROUTINGCARD WHERE TEAMID = @TEAMID) 
	RAISERROR('Dit team bestaat niet. ',16,1)

	IF EXISTS (SELECT 1 FROM WERKNEMER WHERE WERKNEMERID = @WERKNEMERID)
		BEGIN
			UPDATE WERKNEMER
			SET TEAMID = @TEAMID
			WHERE WERKNEMERID = @WERKNEMERID
		END
	ELSE
		RAISERROR('Deze werknemer bestaat niet',16,1)
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

CREATE PROCEDURE spWerknemerVerwijderen
(
@WERKNEMERID integer
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
		
		IF exists(select 1 from WERKNEMER where WERKNEMERID = @WERKNEMERID)
		begin
		delete from MONTEURDIENST where WERKNEMERID = @WERKNEMERID
		delete from dbo.ADMIN where WERKNEMERID = @WERKNEMERID
		delete from reparatie where WERKNEMERID = @WERKNEMERID
		delete from WERKNEMER where WERKNEMERID = @WERKNEMERID
		end
		else
		begin
		raiserror('Deze werknemer bestaat niet, dus je probleem is eigenlijk al opgelost', 16, 1)
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

CREATE PROCEDURE spWerknemerToevoegen
(
@VOORNAAM varchar(30),
@ACHTERNAAM varchar(30),
@ADRES varchar(50),
@POSTCODE varchar(10),
@WACHTWOORD varchar(max)
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
		DECLARE @WERKNEMERID integer

		if exists(select 1 from WERKNEMER)
		begin
			SELECT @WERKNEMERID = max(WERKNEMERID) + 1 from WERKNEMER
		end
		else
		begin
			SET @WERKNEMERID = 1
		end
		INSERT INTO dbo.WERKNEMER values (@WERKNEMERID, NULL, @VOORNAAM, @ACHTERNAAM, @ADRES, @POSTCODE, @WACHTWOORD, 1)
		
		IF @TranCounter = 0 AND XACT_STATE() = 1
			COMMIT TRANSACTION;
		SELECT @WERKNEMERID
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

CREATE PROCEDURE spVerwijderKoppelingOnderdeelBijLeverancier
(
@ONDERDEEL integer,
@LEVERANCIER integer
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
		if exists(select 1 from BESTELLING where LEVERANCIERID = @LEVERANCIER and ONDERDEELID = @ONDERDEEL)
			begin
				raiserror('Er moet nog een bestelling binnenkomen', 16, 1)
			end
		if exists(select 1 from FIETSONDERDEELBIJLEVERANCIER where LEVERANCIERID = @LEVERANCIER and ONDERDEELID = @ONDERDEEL)
			begin
				delete from dbo.FIETSONDERDEELBIJLEVERANCIER where LEVERANCIERID = @LEVERANCIER and ONDERDEELID = @ONDERDEEL
			end	
		else
			begin
				raiserror('Onderdeel of leverancier bestaat niet', 16, 1)
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

CREATE PROCEDURE spToggleWerknemerActief(
	@werknemerID INT
)
AS
BEGIN
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
		if not exists (select 1 from WERKNEMER where WERKNEMERID = @werknemerID)
		begin
		raiserror('Deze werknemer bestaat niet.', 16,1)
		end
		else
		begin
		if exists (select 1 from WERKNEMER where WERKNEMERID = @werknemerID and ACTIEF = '1')
		begin
		UPDATE WERKNEMER
		SET ACTIEF = '0'
		WHERE WERKNEMERID = @werknemerID
		end
		else
		begin
		UPDATE WERKNEMER
		SET ACTIEF = '1'
		WHERE WERKNEMERID = @werknemerID
		end
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
END
GO

CREATE PROCEDURE spStationVoorSpeciaalEvenementVerwijderen
@STATIONID INT,
@EVENTID INT
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 -- alternatief: IF (XACT_STATE()) = 1
		SAVE TRANSACTION ProcedureSave;
	ELSE -- alternatief: IF (XACT_STATE()) = 0
		BEGIN TRANSACTION;
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM SPECIAAL_EVENEMENT WHERE EVENTID = @EVENTID)
			RAISERROR('Dit evenement bestaat niet.',16,1)
		IF NOT EXISTS (SELECT 1 FROM STATION WHERE STATIONID = @STATIONID)
			RAISERROR('Dit station bestaat niet.',16,1)
		IF EXISTS (SELECT 1 FROM STATION_IN_SPECIAAL_EVENEMENT WHERE EVENTID = @EVENTID AND STATIONID = @STATIONID)	
			BEGIN
			DELETE STATION_IN_SPECIAAL_EVENEMENT
			WHERE STATIONID = @STATIONID AND EVENTID = @EVENTID 
			END
		ELSE 
		RAISERROR('Deze koppeling van station, event bestaat niet',16,1)
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


CREATE PROCEDURE spStationVoorSpeciaalEvenementToevoegen
@STATIONID INT,
@EVENTID INT
AS
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 -- alternatief: IF (XACT_STATE()) = 1
		SAVE TRANSACTION ProcedureSave;
	ELSE -- alternatief: IF (XACT_STATE()) = 0
		BEGIN TRANSACTION;
	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM SPECIAAL_EVENEMENT WHERE EVENTID = @EVENTID)
			RAISERROR('Dit evenement bestaat niet.',16,1)
		IF NOT EXISTS (SELECT 1 FROM STATION WHERE STATIONID = @STATIONID)
			RAISERROR('Dit station bestaat niet.',16,1)
		IF NOT EXISTS (SELECT 1 FROM STATION_IN_SPECIAAL_EVENEMENT WHERE EVENTID = @EVENTID AND STATIONID = @STATIONID)	
			BEGIN
			INSERT INTO STATION_IN_SPECIAAL_EVENEMENT
			VALUES(@STATIONID, @EVENTID)
			END
		ELSE 
		RAISERROR('Het station is al aan dit evenement gekoppeld.',16,1)
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

CREATE PROCEDURE spSpeciaalEventVerwijderen
@EVENTID INT
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 -- alternatief: IF (XACT_STATE()) = 1
		SAVE TRANSACTION ProcedureSave;
	ELSE -- alternatief: IF (XACT_STATE()) = 0
		BEGIN TRANSACTION;
	BEGIN TRY
		IF EXISTS (SELECT 1 FROM SPECIAAL_EVENEMENT WHERE EVENTID = @EVENTID)
			BEGIN
			DELETE STATION_IN_SPECIAAL_EVENEMENT
			WHERE EVENTID = @EVENTID

			DELETE SPECIAAL_EVENEMENT
			WHERE EVENTID = @EVENTID

			END
		ELSE 
		RAISERROR('Dit evenement bestaat niet op deze datum.',16,1)
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


CREATE PROCEDURE spSpeciaalEventToevoegen
@EVENT_NAAM VARCHAR(MAX),
@DATUM DATETIME,
@BESCHRIJVING VARCHAR(MAX) = 'None'
AS
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 -- alternatief: IF (XACT_STATE()) = 1
		SAVE TRANSACTION ProcedureSave;
	ELSE -- alternatief: IF (XACT_STATE()) = 0
		BEGIN TRANSACTION;
	BEGIN TRY
		DECLARE @EVENTID INT 

		IF EXISTS (SELECT 1 FROM SPECIAAL_EVENEMENT)
		SELECT @EVENTID = MAX(EVENTID) + 1 FROM SPECIAAL_EVENEMENT
		ELSE
		BEGIN
		SELECT @EVENTID = 1
		END

		IF NOT EXISTS (SELECT 1 FROM SPECIAAL_EVENEMENT WHERE NAAM = @EVENT_NAAM AND CAST(DATUM AS DATE) = CAST(@DATUM AS DATE))
			BEGIN
				INSERT INTO SPECIAAL_EVENEMENT
				VALUES(@EVENTID,@EVENT_NAAM, @DATUM, @BESCHRIJVING)
			END
		ELSE
			RAISERROR('Dit evenement bestaat op deze datum',16,1)
		
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
				/* Transaction started before procedure called, do not roll back 
				modifications made before the procedure was called.
				If the transaction is still valid, just roll back to the 
				savepoint set at the start of the stored procedure.*/
				IF XACT_STATE() <> -1 ROLLBACK TRANSACTION ProcedureSave;
				/* If the transaction is uncommitable, a rollback to the savepoint 
				is not allowed because the savepoint rollback writes to the log. 
				Just return to the caller, which should roll back the outer transaction.*/
			END;	
		THROW
	END CATCH
GO


CREATE PROCEDURE spRoutingCardToevoegen
	@team INT,
	@ritdatum DATETIME,
	@station INT
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
	IF NOT EXISTS(SELECT 1 FROM ROUTINGCARD WHERE teamid = @team)
	RAISERROR('Dit team bestaat niet.',16,1)
	IF NOT EXISTS(SELECT 1 FROM STATION WHERE STATIONID = @station)
	RAISERROR('Dit station bestaat niet.',16,1)
	IF NOT EXISTS (select 1 from ROUTINGCARD WHERE TEAMID = @team AND CAST(RITDATUM AS DATE) = CAST(@ritdatum AS DATE) AND STATIONID = @station)
		BEGIN
			INSERT ROUTINGCARD 
			VALUES(@team,@ritdatum,@station)
		END
	ELSE
	RAISERROR('Dit team rijd al op deze datum naar dit station',16,1)
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

CREATE PROCEDURE spRoosterMToevoegen
	@WERKNEMERID INT,
	@START_DATUM DATETIME,
	@WORKSHOPID INT,
	@EINDTIJD DATETIME	
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 -- alternatief: IF (XACT_STATE()) = 1
		SAVE TRANSACTION ProcedureSave;
	ELSE -- alternatief: IF (XACT_STATE()) = 0
		BEGIN TRANSACTION;
	BEGIN TRY
	IF NOT EXISTS (SELECT 1 FROM WERKNEMER WHERE WERKNEMERID = @WERKNEMERID)
	RAISERROR('Deze werknemer bestaat niet.',16,1)
	IF NOT EXISTS (SELECT 1 FROM WORKSHOP WHERE WORKSHOPID = @WORKSHOPID)
	RAISERROR('Deze workshop bestaat niet',16,1)
		IF NOT EXISTS(SELECT 1 FROM MONTEURDIENST WHERE WERKNEMERID = @WERKNEMERID AND CAST(START_DATUM AS DATE) = CAST(@START_DATUM AS DATE) OR CAST(EIND_TIJD AS DATE) = CAST(@EINDTIJD AS DATE))
			BEGIN
				IF(@START_DATUM < @EINDTIJD)
					BEGIN
						INSERT INTO MONTEURDIENST
						VALUES (@WERKNEMERID,@START_DATUM,@WORKSHOPID,@EINDTIJD) 
					END
				ELSE
					RAISERROR('De start tijd van de medewerker is later dan de eind tijd van de workshift',16,1)
			END
			ELSE 
			BEGIN
			declare @error VARCHAR(MAX) ='De werknemer '+ CAST(@werknemerID AS VARCHAR(20)) + '  Werkt al deze dag: '+ cast(CAST(@start_datum AS DATE)AS VARCHAR(20)) + ' in de workshop ' + CAST(@WORKSHOPID AS VARCHAR(20));
			RAISERROR(@error,16,1);
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
				/* Transaction started before procedure called, do not roll back 
				modifications made before the procedure was called.
				If the transaction is still valid, just roll back to the 
				savepoint set at the start of the stored procedure.*/
				IF XACT_STATE() <> -1 ROLLBACK TRANSACTION ProcedureSave;
				/* If the transaction is uncommitable, a rollback to the savepoint 
				is not allowed because the savepoint rollback writes to the log. 
				Just return to the caller, which should roll back the outer transaction.*/
			END;	
		THROW
	END CATCH
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



CREATE PROCEDURE spLeverancierVerwijderen
(
@LEVERANCIERID INT
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
		if exists (SELECT 1 FROM BESTELLING WHERE LEVERANCIERID = @LEVERANCIERID)
			begin
				RAISERROR('Er moet nog een bestelling binnenkomen van deze leverancier.', 16,1)
			end
		if exists (SELECT 1 FROM LEVERANCIER WHERE LEVERANCIERID = @LEVERANCIERID)
			begin
				DELETE FROM FIETSONDERDEELBIJLEVERANCIER WHERE LEVERANCIERID = @LEVERANCIERID
				DELETE FROM LEVERANCIER WHERE LEVERANCIERID = @LEVERANCIERID
			end
		else
			begin
				RAISERROR('Leverancier bestaat niet', 16, 1)
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

CREATE PROCEDURE spLeverancierToevoegen
(
@NAAM varchar(30),
@TELEFOON varchar(30),
@EMAIL varchar(50)
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
	IF NOT EXISTS (SELECT 1 FROM LEVERANCIER WHERE NAAM = @naam)
		BEGIN 
			DECLARE @LEVERANCIERID integer
			if exists( select 1 from LEVERANCIER)
				begin
					select @LEVERANCIERID = max(LEVERANCIERID) + 1 from LEVERANCIER
				end
			else
				begin
					Select @LEVERANCIERID = 1
				end	
		insert into LEVERANCIER values (@LEVERANCIERID, @NAAM, @TELEFOON, @EMAIL)
		END
		ELSE
		RAISERROR('Leverancier bestaat al',16,1)
		
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


CREATE PROCEDURE spKoppelOnderdeelAanLeverancier
(
@ONDERDEEL integer,
@LEVERANCIER integer,
@PRIJS decimal(5,2)
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
	
	IF EXISTS (select 1 from FIETSONDERDEELBIJLEVERANCIER WHERE ONDERDEELID = @ONDERDEEL AND LEVERANCIERID = @LEVERANCIER)
	RAISERROR('Dit onderdeel bij deze leverancier is bij ons al bekent',16,1)	
	IF(@PRIJS <= 0)
	RAISERROR('De prijs moet groter zijn als 0.',16,1)

		if exists(select 1 from FIETSONDERDEEL where ONDERDEELID = @ONDERDEEL) and exists(select 1 from LEVERANCIER where LEVERANCIERID = @LEVERANCIER)
			begin
				INSERT INTO dbo.FIETSONDERDEELBIJLEVERANCIER values (@LEVERANCIER, @ONDERDEEL, @PRIJS)
			end	
		else
			begin
				raiserror('Onderdeel of leverancier bestaat niet', 16, 1)
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


CREATE PROCEDURE spFietsVerwijderen
(
@FIETSID integer
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
		IF exists (select 1 from FIETS where FIETSID = @FIETSID)
		begin
		delete from REPARATIEQUEUE where FIETSID = @FIETSID
		delete from VOLTOOIDE_LENING where FIETSID = @FIETSID
		delete from FIETSPOST where FIETSID = @FIETSID
		delete from FIETS where FIETSID = @FIETSID
		end
		else
		begin
		raiserror('Deze fiets bestaat niet', 16, 1)
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

CREATE PROCEDURE spFietsToevoegen
(
@FIETSID integer,
@WORKSHOPID integer
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
		IF NOT EXISTS (SELECT 1 FROM FIETS WHERE FIETSID = @FIETSID)
			IF EXISTS (SELECT 1 FROM WORKSHOP WHERE WORKSHOPID = @WORKSHOPID)
				INSERT INTO dbo.FIETS values (@FIETSID, @WORKSHOPID)
			ELSE
			RAISERROR('Deze workshop bestaat niet',16,1)
		ELSE
		RAISERROR('Dit fietsid bestaat al',16,1)

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


CREATE PROCEDURE spControleTaakVerwijderen
(
@TAAKID integer
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
		IF exists (select 1 from TAAK where TAAKID = @TAAKID)
		begin
		delete from TAAK where TAAKID = @TAAKID
		end
		else
		begin	
		raiserror('Deze taak bestaat niet', 16, 1)
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


CREATE PROCEDURE spAdminToevoegen
(
@WERKNEMERID integer
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
		IF EXISTS(SELECT 1 FROM [ADMIN] WHERE WERKNEMERID = @WERKNEMERID)
		RAISERROR('Deze werknemer is al een administrator',16,1)
		IF EXISTS(SELECT 1 FROM WERKNEMER WHERE WERKNEMERID = @WERKNEMERID)
		INSERT INTO dbo.ADMIN VALUES (@WERKNEMERID)
		ELSE
		RAISERROR('Deze werknemer bestaat niet',16,1)
		
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



CREATE PROCEDURE spPakFietsOmTeRepareren
	@FIETSID INT
AS
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 -- alternatief: IF (XACT_STATE()) = 1
		SAVE TRANSACTION ProcedureSave;
	ELSE -- alternatief: IF (XACT_STATE()) = 0
		BEGIN TRANSACTION;
	BEGIN TRY
		if exists (select 1 from REPARATIEQUEUE where FIETSID = @FIETSID and WORDT_GEREPAREERD = '1')
		raiserror('Er wordt al gewerkt aan deze fiets.', 16,1)
		IF exists (select 1 from REPARATIEQUEUE where FIETSID = @FIETSID)
		Begin
		update REPARATIEQUEUE set WORDT_GEREPAREERD = '1' where FIETSID = @FIETSID
		end
		else
		begin
		raiserror('Deze fiets stond niet in de reparatieQueue.', 16, 1)
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


--bestelling wordt in bestellijst gezet
CREATE PROCEDURE spOnderdeelbestellen
	@workshop INT,
	@leverancier INT,
	@onderdeel INT,
	@aantal INT
AS
BEGIN
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
	DECLARE @id INT 
	IF exists (select 1 from FIETSONDERDEEL WHERE ONDERDEELID = @onderdeel)
	BEGIN
		select @id = max(ORDERID) + 1 from BESTELLING
	END 
	ELSE
	BEGIN
		select @id = 1
	END
	
	IF NOT EXISTS (select 1 from FIETSONDERDEELBIJLEVERANCIER where ONDERDEELID = @onderdeel and LEVERANCIERID = @leverancier)
		raiserror('dit onderdeel is niet te koop bij deze leverancier', 16,1)
	else
		INSERT BESTELLING VALUES (@id ,@workshop ,@leverancier ,@onderdeel ,GETDATE() ,@aantal)
	
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

IF EXISTS(select * from sys.objects where type = 'P' AND name='spInventarisBijwerken')
DROP PROCEDURE spInventarisBijwerken
GO

--aantal onderdelen in de workshop wordt aangepast
CREATE PROCEDURE spInventarisBijwerken
@WERKNEMERID INT,
@ONDERDEELID INT,
@WORKSHOPID INT,
@AANTAL INT,
@PLUSOFMIN BIT = 0
AS
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 -- alternatief: IF (XACT_STATE()) = 1
		SAVE TRANSACTION ProcedureSave;
	ELSE -- alternatief: IF (XACT_STATE()) = 0
		BEGIN TRANSACTION;
	BEGIN TRY

	IF EXISTS (SELECT 1 FROM MONTEURDIENST WHERE WERKNEMERID = @WERKNEMERID AND CAST(START_DATUM AS DATE) = CAST(GETDATE() AS DATE) AND WORKSHOPID = @WORKSHOPID) OR EXISTS(SELECT 1 FROM ADMIN WHERE WERKNEMERID = @WERKNEMERID)
	BEGIN 
			IF EXISTS(SELECT 1 FROM FIETSONDERDEELINWORKSHOP WHERE ONDERDEELID = @ONDERDEELID AND WORKSHOPID = @WORKSHOPID)
			BEGIN 
				IF (@AANTAL >= 0)
					IF(@PLUSOFMIN = 0)
						BEGIN
							Declare @totaal int
							SELECT @totaal = (AANTAL - @AANTAL) FROM FIETSONDERDEELINWORKSHOP WHERE ONDERDEELID = @ONDERDEELID AND WORKSHOPID = @WORKSHOPID 

							IF(@totaal >= 0)
								UPDATE FIETSONDERDEELINWORKSHOP
								SET AANTAL = AANTAL - @AANTAL
								WHERE ONDERDEELID = @ONDERDEELID AND WORKSHOPID = @WORKSHOPID
							ELSE
							RAISERROR('Het totaal van dit product is minder als 0',16,1)
						END
					ELSE
						UPDATE FIETSONDERDEELINWORKSHOP
						SET AANTAL = AANTAL + @AANTAL
						WHERE ONDERDEELID = @ONDERDEELID AND WORKSHOPID = @WORKSHOPID
				ELSE
				RAISERROR('Aantal kan niet lager zijn dan 0',16,1)
			END
			ELSE
				RAISERROR('Dit onderdeel ligt niet in deze workshop',16,1)
	END
		ELSE
		RAISERROR('Deze monteur is niet werkzaam in deze workshop',16,1)

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


--De beschrijving van de kapotte fiets wordt aangepast
CREATE PROCEDURE spFietsTerugInRepQueue
	@FIETSID INT,
	@BESCHRIJVING VARCHAR(MAX) = null
AS
	SET TRANSACTION  ISOLATION LEVEL REPEATABLE READ 
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 -- alternatief: IF (XACT_STATE()) = 1
		SAVE TRANSACTION ProcedureSave;
	ELSE -- alternatief: IF (XACT_STATE()) = 0
		BEGIN TRANSACTION;
	BEGIN TRY
		IF exists (select 1 from REPARATIEQUEUE where FIETSID = @FIETSID and WORDT_GEREPAREERD = '0')
			raiserror('Deze fiets staat al in de reparatiequeue', 16, 1)
		IF exists (select 1 from REPARATIEQUEUE where FIETSID = @FIETSID)
			Begin
				update REPARATIEQUEUE set WORDT_GEREPAREERD = '0' where FIETSID = @FIETSID
				update REPARATIEQUEUE set BESCHRIJVING = @BESCHRIJVING where FIETSID = @FIETSID
			end
		else
			begin
				raiserror('Deze fiets stond niet in de reparatieQueue', 16, 1)
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


--fiets wordt uit de OutQueue gehaald
--fiets wordt in de aangegeven fietspost gezet
CREATE PROCEDURE spFietsNaarStation
(
@STATIONID integer,
@FIETSID integer,
@FIETSPOST integer
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
	if exists (select 1 from FIETS where FIETSID = @FIETSID and WORKSHOPID is not null)
	begin
		UPDATE FIETS set WORKSHOPID = null where FIETSID = @FIETSID
		INSERT INTO FIETSPOST values(@STATIONID, @FIETSPOST, @FIETSID, '0')
		end
		else
		begin
			raiserror('fiets staat niet in outqueue', 16,1)
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


CREATE PROCEDURE spFietsNaarOutqueue
	@FIETSID INT,
	@WORKSHOP INT
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

IF NOT EXISTS (SELECT 1 FROM FIETS WHERE FIETSID = @FIETSID)
RAISERROR('Deze fiets bestaat niet',16,1)

IF NOT EXISTS (SELECT 1 FROM WORKSHOP WHERE WORKSHOPID = @WORKSHOP)
RAISERROR('Deze workshop bestaat niet',16,1)

IF EXISTS (SELECT 1 FROM REPARATIEQUEUE WHERE FIETSID = @FIETSID AND WORDT_GEREPAREERD = 1)
	BEGIN
		DECLARE @plaatsInQ integer
		select @plaatsInQ = VOLGNUMMER FROM REPARATIEQUEUE where FIETSID = @FIETSID
		DELETE FROM REPARATIEQUEUE WHERE FIETSID = @FIETSID
		UPDATE REPARATIEQUEUE SET VOLGNUMMER = VOLGNUMMER - 1 where VOLGNUMMER > @plaatsInQ AND WORKSHOPID = @WORKSHOP
		UPDATE FIETS SET WORKSHOPID = @workshop where FIETSID = @FIETSID
	END
ELSE
	RAISERROR('Deze fiets bevindt zich niet in de reparatie que.',16,1)

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

--fiets hoeft niet meer gecheckt te worden
--er wordt opgeslagen welke controletaken zijn uitgevoerd
CREATE PROCEDURE spOngroundControle
	@fietsid INT,
	@werknemerid INT,
	@beschrijving VARCHAR(MAX)
AS
BEGIN
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
	if exists (SELECT 1 FROM FIETSPOST WHERE FIETSID = @fietsid)
	begin
	UPDATE FIETSPOST SET MOETGECHECKTWORDEN = '0' WHERE FIETSID = @fietsid
	INSERT ONGROUNDCONTROLE VALUES
	(@fietsid,GETDATE(),@werknemerid,@beschrijving)
	end
	else
	begin
	raiserror('Deze fiets bestaat niet.',16,1)
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
END
GO

--fiets wordt gemarkeerd als MoetGechecktWorden
CREATE PROCEDURE spMarkeerFiets
(
@FIETSID INT
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
	if exists (select 1 from FIETSPOST where FIETSID = @FIETSID and MOETGECHECKTWORDEN = '0')
	begin
		UPDATE FIETSPOST SET MOETGECHECKTWORDEN = '1' where FIETSID = @FIETSID
		end
		else
		begin
		raiserror('deze fiets bestaat niet, of is al gemarkeerd om gecheckt te worden', 16,1)
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

CREATE PROCEDURE spOpwaardeerKaart
(
@KLANTID integer,
@GELD numeric(5,2)
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

	IF NOT EXISTS (SELECT 1 FROM KLANT WHERE KLANTID = @KLANTID)
	RAISERROR('Klant Bestaat niet',16,1)

	IF(@GELD < 0.50)
	RAISERROR('Je kan niet minder dan € 0,50 opwaarderen. ',16,1)

		IF exists (select 1 from KLANTHEEFTABONNEMENT where KLANTID = @klantID and PREPAIDTEGOED is not null and EIND_TIJD > GETDATE())
			begin
				UPDATE KLANTHEEFTABONNEMENT SET PREPAIDTEGOED += @geld where KLANTID = @KLANTID and EIND_TIJD > GETDATE()
			end;
		ELSE
			BEGIN
			raiserror('klant heeft geen prepaid abonnement',16,1)
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

CREATE PROCEDURE spFiets_word_in_FIETSPOST_gezet
 @FIETSID INT,
 @KLANTID INT,
 @EINDSTATION INT,
 @FIETSPOST INT
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 -- alternatief: IF (XACT_STATE()) = 1
		SAVE TRANSACTION ProcedureSave;
	ELSE -- alternatief: IF (XACT_STATE()) = 0
		BEGIN TRANSACTION;
	BEGIN TRY
		IF EXISTS (select 1 AS Aantal_Stations from FIETSPOST F
						INNER JOIN STATION S 
						ON F.STATIONID = S.STATIONID
						WHERE F.STATIONID = @EINDSTATION
						GROUP BY F.STATIONID, S.CAPACITEIT
						HAVING COUNT(F.STATIONID) >= S.CAPACITEIT
					)
				BEGIN
				/* Gebruiker krijgt eenmalig 15 minuten extra tijd */
					IF Exists (select 1 from UITGELEENDE_FIETS where FIETSID = @FIETSID AND KLANTID = @KLANTID AND EXTRA_TIJD = 0 )
						BEGIN
						UPDATE UITGELEENDE_FIETS 
						SET EXTRA_TIJD = 1
						WHERE FIETSID = @FIETSID
						AND KLANTID = @KLANTID AND EXTRA_TIJD = 0
						COMMIT TRAN
						PRINT'Het fietsstation is vol u krijgt 15 minuten extra tijd';
						RETURN;
						END
				END
/*		 Klant moet een abonnement hebben		*/
		IF EXISTS(SELECT 1 FROM KLANTHEEFTABONNEMENT where KLANTID = @KLANTID)
			BEGIN
			DECLARE @ABONNEMENTTYPE VARCHAR(50)
			DECLARE @LEENTIJD int = 0
			DECLARE @BEGINTIJD DATETIME
			DECLARE @EINDTIJD DATETIME
			DECLARE @EXTRATIJD int = 0
			DECLARE @PRIJS numeric(5,2) = 0
			DECLARE @MESSAGE VARCHAR(MAX) = ''
			SELECT @EINDTIJD = GETDATE(), @BEGINTIJD = start_tijd_lening FROM UITGELEENDE_FIETS WHERE KLANTID = @KLANTID AND FIETSID = @FIETSID
			SELECT @ABONNEMENTTYPE = ABONNEMENTTYPE FROM KLANTHEEFTABONNEMENT K INNER JOIN UITGELEENDE_FIETS L ON K.KLANTID = L.KLANTID WHERE L.KLANTID = @KLANTID AND L.start_tijd_lening > K.START_DATUM
			SELECT @LEENTIJD = DATEDIFF(minute,@BEGINTIJD,@EINDTIJD)
			
			IF EXISTS(SELECT 1 FROM STATION WHERE STATIONID = @EINDSTATION AND V_PLUS = 1)
				BEGIN
					SET @EXTRATIJD = 15;
				IF EXISTS(SELECT 1 FROM UITGELEENDE_FIETS WHERE KLANTID = @KLANTID AND FIETSID = @FIETSID)
					SET @EXTRATIJD = @EXTRATIJD + 15
				END 
/*==========================================================*/
/*			Prijs berekening velib Solidarity				*/
/*==========================================================*/
			IF(@ABONNEMENTTYPE = 'Velib Solidarity')
				BEGIN
				SELECT @LEENTIJD = @LEENTIJD - @EXTRATIJD - 45
				SET @MESSAGE = @MESSAGE + '- klant abonnement is Velib Solidarity' + CHAR(13);
					IF(@LEENTIJD > 0 AND @LEENTIJD <= 30)
						SET @PRIJS = 1
					IF(@LEENTIJD >= 30 AND @LEENTIJD < 60)
						SET @PRIJS = 3
					IF(@LEENTIJD >= 60)
						BEGIN
							IF(@LEENTIJD <90)	
								set @PRIJS = 7
							ELSE
								SELECT @PRIJS = (@LEENTIJD - 60) / 30 * 4 + 3
						END
				END
/*==========================================================*/
/*			Prijs berekening velib Classic					*/
/*==========================================================*/
				IF(@ABONNEMENTTYPE = 'Velib Classic')
					BEGIN
					SELECT @LEENTIJD = @LEENTIJD - @EXTRATIJD - 30
					SET @MESSAGE = @MESSAGE + '- klant abonnement is Velib classic' + CHAR(13);
						IF(@LEENTIJD > 0 AND @LEENTIJD <= 30)
							SET @PRIJS = 1
						IF(@LEENTIJD >= 30 AND @LEENTIJD < 60)
							SET @PRIJS = 3
						IF(@LEENTIJD >= 60)
							BEGIN
								IF(@LEENTIJD <90)	
									set @PRIJS = 7
								ELSE
									SELECT @PRIJS = (@LEENTIJD - 60) / 30 * 4 + 3
							END
					END
/*==========================================================*/
/*			Prijs berekening velib Passion					*/
/*==========================================================*/
				IF(@ABONNEMENTTYPE = 'Velib Passion' OR @ABONNEMENTTYPE = 'Velib Passion Young' OR @ABONNEMENTTYPE = 'Velib Passion Student' OR @ABONNEMENTTYPE = 'Velib Socio')
					BEGIN
					SELECT @LEENTIJD = @LEENTIJD - @EXTRATIJD - 45
					SET @MESSAGE = @MESSAGE + '- klant abonnement is velib passion' + CHAR(13);
						IF(@LEENTIJD > 0 AND @LEENTIJD <= 30)
							SET @PRIJS = 1
						IF(@LEENTIJD >= 30 AND @LEENTIJD < 60)
							SET @PRIJS = 3
						IF(@LEENTIJD >= 60)
							BEGIN
								IF(@LEENTIJD <90)	
									set @PRIJS = 7
								ELSE
									SELECT @PRIJS = (@LEENTIJD - 60) / 30 * 4 + 3
							END
					END
/*==========================================================*/
/*			Prijs berekening 1 Week abonoment				*/
/*==========================================================*/
				IF(@ABONNEMENTTYPE = '1-day ticket')
					BEGIN
					SELECT @LEENTIJD = @LEENTIJD - @EXTRATIJD
					SET @MESSAGE = @MESSAGE + '- klant abonnement heeft een dagkaart' + CHAR(13);
						IF(@LEENTIJD > 0 AND @LEENTIJD <= 1440)
							SET @PRIJS = 0
						IF(@LEENTIJD >= 1440 AND @LEENTIJD < 1470)
							SET @PRIJS = 1
						IF(@LEENTIJD >= 1470 AND @LEENTIJD < 1500)
							SET @PRIJS = 3
						IF(@LEENTIJD >= 1500)
							BEGIN
								IF(@LEENTIJD <1530)	
									set @PRIJS = 7
								ELSE
									SELECT @PRIJS = (@LEENTIJD - 1440) / 30 * 4 + 3
							END
					END
/*==========================================================*/
/*			Prijs berekening dagkaart						*/
/*==========================================================*/
				IF(@ABONNEMENTTYPE = '7-day ticket')
					BEGIN
					SELECT @LEENTIJD = @LEENTIJD - @EXTRATIJD
					SET @MESSAGE = @MESSAGE + '- klant heeft een week abonnoment' + CHAR(13);
						IF(@LEENTIJD > 0 AND @LEENTIJD <= 10080)
							SET @PRIJS = 0
						IF(@LEENTIJD > 10080 AND @LEENTIJD < 10110)
							SET @PRIJS = 1
						IF(@LEENTIJD >= 10110 AND @LEENTIJD < 10140)
							SET @PRIJS = 3
						IF(@LEENTIJD >= 10140)
							BEGIN
								IF(@LEENTIJD <10140)	
									SET @PRIJS = 7
								ELSE
									SELECT @PRIJS = (@LEENTIJD - 10080) / 30 * 4 + 3
							END
					END
					print @abonnementtype
/*		Fietslening wordt afgesloten met een update			*/
					IF (@ABONNEMENTTYPE is not null) AND EXISTS (SELECT 1 FROM UITGELEENDE_FIETS WHERE KLANTID = @KLANTID AND FIETSID = @FIETSID)
						BEGIN
							print'voor de insert'
							-- Insert de uitgeleende fiets in de de voltooide lening
							INSERT INTO VOLTOOIDE_LENING (KLANTID, FIETSID, START_TIJD, START_STATION, EIND_STATION, EIND_TIJD, PRIJS,EXTRA_TIJD)
							SELECT KLANTID, FIETSID, START_TIJD_LENING, START_STATION ,@EINDSTATION, @EINDTIJD,@prijs ,EXTRA_TIJD
							FROM UITGELEENDE_FIETS
							WHERE KLANTID = @KLANTID AND FIETSID = @FIETSID 
							PRINT'na de insert'
							-- Verwijder de lopende lening
							DELETE UITGELEENDE_FIETS WHERE FIETSID = @FIETSID
							-- Zet de fiets in de fietspost
							INSERT INTO FIETSPOST
							VALUES(@EINDSTATION,@FIETSID,@FIETSPOST,0)
							IF exists (SELECT 1 from KLANTHEEFTABONNEMENT where KLANTID = @KLANTID AND PREPAIDTEGOED > 0)
							BEGIN
							UPDATE KLANTHEEFTABONNEMENT
							SET PREPAIDTEGOED = PREPAIDTEGOED - @PRIJS
							WHERE KLANTID = @KLANTID AND EIND_TIJD > GETDATE()
							END
						END
				END
				ELSE
				SET @MESSAGE = @MESSAGE + '- De klant Heeft geen lopend abonnement' + CHAR(13);


/*		Check hoevaak de fiets geleent is. En of dat een check op de fiets forceert	of een reparatie		*/
			IF EXISTS(SELECT 1 FROM VOLTOOIDE_LENING WHERE KLANTID = @KLANTID AND FIETSID = @FIETSID AND PRIJS IS NOT NULL)
			BEGIN
				DECLARE @FIETSCHECK INT
				DECLARE @LAATSTEREPARATIE datetime
/*		Checken wanneer de laatste check is gedaan		*/
				IF EXISTS(SELECT 1 FROM ONGROUNDCONTROLE WHERE FIETSID = @FIETSCHECK)
					SELECT @LAATSTEREPARATIE = MAX(DATUM) FROM ONGROUNDCONTROLE WHERE FIETSID = @FIETSID
/*		Checken wanneer de laatste reparatie is geweest		*/
				IF EXISTS(SELECT 1 FROM REPARATIE WHERE FIETSID = @FIETSCHECK)
					BEGIN
					SELECT @LAATSTEREPARATIE = MAX(REPARATIE_DATUM) FROM REPARATIE WHERE FIETSID = @FIETSID
					END
				IF NOT EXISTS(SELECT 1 FROM ONGROUNDCONTROLE WHERE FIETSID = @FIETSCHECK) OR NOT EXISTS (SELECT 1 FROM REPARATIE WHERE FIETSID = @FIETSCHECK)				
				SELECT @FIETSCHECK = COUNT(L.FIETSID) from VOLTOOIDE_LENING L WHERE L.FIETSID = @FIETSID
				ELSE
				SELECT @FIETSCHECK = COUNT(L.FIETSID) from VOLTOOIDE_LENING L WHERE L.FIETSID = @FIETSID AND L.START_TIJD >= @LAATSTEREPARATIE
/*		Fiets is 30 x geleent vanaf	de laaste check				*/
				IF(@FIETSCHECK > 30)
					BEGIN
						UPDATE FIETSPOST
						SET MOETGECHECKTWORDEN = 1
						WHERE FIETSID = @FIETSID
					END
					ELSE
					SET @MESSAGE = @MESSAGE + '- De fiets hoeft niet gecontroleerd te worden';
			END
		PRINT @MESSAGE

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
GO


CREATE PROCEDURE spAbonnementKopen
	@klantnummer INT,
	@abonnementtype VARCHAR(20), 
	@creditkaartnummer INT = null,
	@prepaidtegoed NUMERIC(10,2) = null,
	@automatischverlengd BIT = 0
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

	IF NOT EXISTS(SELECT 1 FROM KLANTHEEFTABONNEMENT WHERE KLANTID = @klantnummer AND EIND_TIJD > GETDATE())
	BEGIN
	-- zet een eindtijd voor het abonnement
		DECLARE @eindtijd DATETIME = (
			DATEADD(DAY,CAST((SELECT LOOPTIJD FROM ABONNEMENTTYPE WHERE @abonnementtype = ABONNEMENTTYPE) AS INT),GETDATE())
		)
		-- Voeg het abonnement toe aan de database.
		INSERT INTO KLANTHEEFTABONNEMENT VALUES
		(@abonnementtype,@klantnummer,GETDATE(),@eindtijd,@creditkaartnummer,@prepaidtegoed,@automatischverlengd)
	END
	ELSE
	RAISERROR('Deze klant heeft al een lopend abonnement',16,1)

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

CREATE PROCEDURE spFietsRedistributie	
	@fiets INT,
	@naar_station1_workshop0 BIT,
	@locatieID INT,
	@fietspost INT = null -- als de fiets naar een station gaat vul dit in
AS
BEGIN
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 
		SAVE TRANSACTION ProcedureSave;
	ELSE
		BEGIN TRANSACTION;
	BEGIN TRY
		-- check waar de fiets op het moment is
		-- en haal hem daar weg
		IF EXISTS(SELECT 1 FROM FIETS 
				  WHERE @fiets = FIETSID
				  AND WORKSHOPID > 0)
		BEGIN 
			UPDATE FIETS
			SET WORKSHOPID = null
			WHERE FIETSID = @fiets
		END
		ELSE IF EXISTS(SELECT 1 FROM FIETSPOST
					   WHERE @fiets = FIETSID)
		BEGIN 
			DELETE FROM FIETSPOST
			WHERE FIETSID = @fiets
		END
		ELSE IF EXISTS(SELECT 1 FROM UITGELEENDE_FIETS
					   WHERE @fiets = FIETSID)
		BEGIN 
			RAISERROR ('Deze fiets is op het moment in lening',16,1)
		END

		-- voer het in de database
		IF @naar_station1_workshop0 = 0 BEGIN
			-- lever af
			UPDATE FIETS
			SET WORKSHOPID = @locatieID
			WHERE FIETSID = @fiets
		END ELSE BEGIN
			-- lever af
			INSERT FIETSPOST VALUES
			(@locatieID,@fietspost,@fiets,0)
		END
		IF @TranCounter = 0 AND XACT_STATE() = 1
			COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		THROW
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