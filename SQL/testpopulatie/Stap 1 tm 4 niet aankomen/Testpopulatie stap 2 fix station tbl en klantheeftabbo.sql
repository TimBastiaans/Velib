use Velib

-- enforce br 2
DELETE FROM KLANTHEEFTABONNEMENT
WHERE PREPAIDTEGOED IS NULL AND CREDITKAARTNUMMER IS NULL
DELETE FROM KLANTHEEFTABONNEMENT
WHERE PREPAIDTEGOED IS NULL 
DELETE FROM KLANTHEEFTABONNEMENT
WHERE CREDITKAARTNUMMER IS NULL

UPDATE KLANTHEEFTABONNEMENT
SET PREPAIDTEGOED = NULL
WHERE (KLANTNUMMER % 2) = 1 

UPDATE KLANTHEEFTABONNEMENT
SET CREDITKAARTNUMMER = NULL
WHERE (KLANTNUMMER % 2) = 0

-- zorg dat automatisch verlengd alleen true is als het abbo type long-term is.
UPDATE KLANTHEEFTABONNEMENT
SET AUTOMATISCH_VERLENGT = 0
WHERE ABONNEMENTTYPE = '7-day ticket' OR ABONNEMENTTYPE = '1-day ticket'

-- ZOrg dat alle stations arrondissementen enzo kloppen
DECLARE @count INT = 1
DECLARE @aantalStations INT = (SELECT COUNT(*) FROM STATION)
WHILE @count <= @aantalStations
BEGIN
	UPDATE STATION
	SET ARRONDISSEMENT = 1 + (CAST(RAND() * 2000 AS INT)) % 20
	WHERE STATIONID = @count
	SET @count = @count + 1
END

UPDATE STATION
SET STATIONNUMMER = 0

DECLARE stationCursor CURSOR FOR
SELECT STATIONID, STATIONNUMMER, ARRONDISSEMENT
FROM STATION
DECLARE @stationid INT
DECLARE @stationnummer INT
DECLARE @arrondissement INT
DECLARE @max INT

OPEN stationCursor
FETCH NEXT FROM stationCursor INTO @stationid, @stationnummer, @arrondissement
WHILE(@@FETCH_STATUS = 0)
BEGIN

	SET @max = (
		SELECT MAX(STATIONNUMMER) 
		FROM STATION
		WHERE ARRONDISSEMENT = @arrondissement
	)	

	UPDATE STATION
	SET STATIONNUMMER = @max + 1
	WHERE STATIONID = @stationid

FETCH NEXT FROM stationCursor INTO @stationid, @stationnummer, @arrondissement
END
CLOSE stationCursor
DEALLOCATE stationCursor