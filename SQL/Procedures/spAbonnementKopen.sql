-- transactie Abonnement kopen
USE Velib
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE [type] = 'P' AND [name] = 'spAbonnementKopen')
BEGIN DROP PROCEDURE spAbonnementKopen END
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

/******* testscript ********/

-- Deze gaat goed
BEGIN TRANSACTION
DELETE FROM KLANTHEEFTABONNEMENT
DELETE FROM KLANT
INSERT KLANT VALUES
(1,'michiel','idema','halamalgalama laan23','1234AB','1996-11-29',1,0)
EXEC spAbonnementKopen 1,'Velib Classic',null,10,1
SELECT * FROM KLANTHEEFTABONNEMENT WHERE KLANTID = 1
ROLLBACK TRANSACTION

-- Deze gaat fout omdat creditkaart en prepaidsaldo beide ingevuld zijn.
BEGIN TRANSACTION
DELETE FROM KLANTHEEFTABONNEMENT
DELETE FROM KLANT
INSERT KLANT VALUES
(1,'michiel','idema','halamalgalama laan23','1234AB','1996-11-29',1,0)
EXEC spAbonnementKopen 1,'Velib Classic',875643,10,1
ROLLBACK TRANSACTION

-- Deze gaat fout omdat creditkaart en prepaidsaldo beide niet ingevuld zijn.
BEGIN TRANSACTION
DELETE FROM KLANTHEEFTABONNEMENT
DELETE FROM KLANT
INSERT KLANT VALUES
(1,'michiel','idema','halamalgalama laan23','1234AB','1996-11-29',1,0)
EXEC spAbonnementKopen 1,'Velib Classic',null,null,1
ROLLBACK TRANSACTION

-- Deze gaat fout omdat een short-term abonnement geen prepaidtegoed kan hebben.
BEGIN TRANSACTION
DELETE FROM KLANTHEEFTABONNEMENT
DELETE FROM KLANT
INSERT KLANT VALUES
(1,'michiel','idema','halamalgalama laan23','1234AB','1996-11-29',1,0)
EXEC spAbonnementKopen 1,'1-day ticket',null,7,0
ROLLBACK TRANSACTION

-- Deze gaat fout omdat een niet short-term abbo niet automatisch verlengd mag worden.
BEGIN TRANSACTION
DELETE FROM KLANTHEEFTABONNEMENT
DELETE FROM KLANT
INSERT KLANT VALUES
(1,'michiel','idema','halamalgalama laan23','1234AB','1996-11-29',1,0)
EXEC spAbonnementKopen 1,'1-day ticket',87465,null,1
ROLLBACK TRANSACTION

-- Deze gaat fout omdat de klant op het moment al een lopend abonnement heeft.
BEGIN TRANSACTION
DELETE FROM KLANTHEEFTABONNEMENT
DELETE FROM KLANT
INSERT KLANT VALUES
(1,'michiel','idema','halamalgalama laan23','1234AB','1996-11-29',1,0)
EXEC spAbonnementKopen 1,'Velib Classic',null,10,1
EXEC spAbonnementKopen 1,'Velib Classic',null,10,1
ROLLBACK TRANSACTION


/* Getest op 17 januari 2018 UC 1 */
BEGIN TRANSACTION
EXEC spAbonnementKopen @Klantnummer = 1 , @abonnementtype = '1-day ticket',  @creditkaartnummer = 473883, @prepaidtegoed = null, @automatischverlengd = 0
select * FROM KLANTHEEFTABONNEMENT
ROLLBACK TRANSACTION

BEGIN TRANSACTION
EXEC spAbonnementKopen @Klantnummer = 2 , @abonnementtype = '7-day ticket',  @creditkaartnummer = 473883, @prepaidtegoed = null, @automatischverlengd = 0
select * FROM KLANTHEEFTABONNEMENT
ROLLBACK TRANSACTION

/* Getest op 17 januari 2018 UC 2 */
BEGIN TRANSACTION
EXEC spAbonnementKopen @Klantnummer = 3 , @abonnementtype = 'Velib Classic',  @creditkaartnummer = null, @prepaidtegoed = 10, @automatischverlengd = 0
select * FROM KLANTHEEFTABONNEMENT
ROLLBACK TRANSACTION


-- Michiels zijn oplossing wat eigenlijk de trigger oplost vandaar is dit onnodig
-- check of creditkaart en prepaidtegoed niet beide ingevuld zijn en of abbo type wel 
-- long term is wanneer er een prepaidtegoed is ingevuld
/*IF @prepaidtegoed IS NOT NULL AND (SELECT LONGTERM 
								   FROM ABONNEMENTTYPE 
								   WHERE ABONNEMENTTYPE = @abonnementtype) != 1 
BEGIN RAISERROR('Een short-term abonnement kan geen prepaidtegoed hebben',16,1);  END

IF @creditkaartnummer IS NULL AND @prepaidtegoed IS NULL
BEGIN RAISERROR('creditkaartnummer en prepaidtegoed mogen niet beide null zijn.',16,1); END
IF @creditkaartnummer IS NOT NULL AND @prepaidtegoed IS NOT NULL
BEGIN RAISERROR('creditkaartnummer en prepaidtegoed mogen niet beide ingevuld zijn.',16,1); END

-- zorg dat alleen long term abonnementen automatisch verlengd kunne worden.
IF @abonnementtype not in (SELECT ABONNEMENTTYPE FROM ABONNEMENTTYPE WHERE LONGTERM = 1)
AND @automatischverlengd = 1
BEGIN RAISERROR('Een niet short-term abbo mag niet automatisch verlengd worden',16,1); END*/

/*-- check of de klant niet al een abbo op het moment heeft
IF EXISTS(SELECT 1 FROM KLANTHEEFTABONNEMENT WHERE KLANTID = @klantnummer AND EIND_TIJD > GETDATE())
BEGIN RAISERROR('De klant heeft al een abonnement op het moment.',16,1); END*/

