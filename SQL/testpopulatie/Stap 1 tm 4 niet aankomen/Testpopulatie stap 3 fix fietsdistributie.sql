-- stap 3 fix fietsen fietsdistributie

/* fietsinstation */ 
/* fiets in de reparatiequeue */
/* fiets in de outqueue */
/* leningen die actief zijn */

-- delete alle data
DELETE 
FROM LENING WHERE EIND_STATION IS NULL
DELETE FROM FIETSINSTATION
DELETE FROM REPARATIEQUEUE
DELETE FROM OUTQUEUE

-- insert fietsinstation
DECLARE @aantal_fietsinstation INT = 16000
DECLARE @Count INT = 1
DECLARE @fietspost INT
DECLARE @fitStationid INT
DECLARE @check BIT
DECLARE @MAXfietspost BIT = 0
WHILE @Count <= @aantal_fietsinstation
BEGIN 
	SET @fitStationid = 1 + CAST(RAND() * 10000 AS INT) % 1799
	SET @MAXfietspost = (select CAPACITEIT from STATION where STATIONID = @fitStationid)
	IF NOT EXISTS (select 1 from FIETSINSTATION where STATIONID = @fitStationid)
	BEGIN
		SET @fietspost = 1
	END
	ELSE
	BEGIN
		SET @fietspost = (select max(FIETSPOST) from FIETSINSTATION where STATIONID = @fitStationid) + 1
	END
	IF ((CAST(RAND() * 10000 AS INT) % 8) = 1) BEGIN
		SET @check = 1
	END
	ELSE BEGIN
		SET @check = 0
	END
	INSERT FIETSINSTATION VALUES
	(@Count,@fitStationid,@fietspost,@check)
	SET @Count = @Count + 1
END

-- insert actieve leningen
DECLARE @from datetime
DECLARE @to datetime
DECLARE @diff INT
DECLARE @klantnummer INT
DECLARE @eindstation INT
DECLARE @startstation INT
DECLARE @prijs NUMERIC(2,2)
DECLARE @xtratijd BIT
DECLARE @count2 INT = 16001
WHILE @count2 <= 19900
BEGIN
	SET @from = DATEADD(MINUTE,-(CAST(RAND() * 10000 AS INT) % 45),GETDATE())
	SET @diff = 5 + (CAST(RAND() * 10000 AS INT) % 85)
	SET @to = DATEADD(MINUTE,@diff,@from)
	SET @klantnummer = 1 + (CAST(RAND()*10000 AS INT)%((SELECT MAX(KLANTNUMMER) FROM KLANT)-1)) 
	SET @startstation = 1 + (CAST(RAND()*10000 AS INT)%((SELECT MAX(STATIONID) FROM STATION)-1))
	IF CAST(RAND()*1000 AS INT) % 8 = 1
	BEGIN
		SET @xtratijd = 1
	END
	ELSE
	BEGIN
		SET @xtratijd = 0
	END
	INSERT LENING VALUES
	(@count2,@from,@klantnummer,@to,@startstation,null,null,@xtratijd)
	SET @count2 = @count2 + 1
END

-- insert reparatiequeue
DECLARE @count3 INT = 19901
DECLARE @workshop INT
DECLARE @volgnummer INT
DECLARE @beschrijving VARCHAR(1024)
DECLARE @MAXvolgnummer INT
WHILE @count3 <= 19950
BEGIN
	SET @workshop = 1 + (CAST(RAND()*7000086 AS INT)%(select max(WORKSHOPID)-1 from WORKSHOP))
	IF EXISTS(select 1 from REPARATIEQUEUE where WORKSHOPID = @workshop)
	BEGIN
		SET @MAXvolgnummer = (select max(VOLGNUMMER) from REPARATIEQUEUE where WORKSHOPID = @workshop)
		SET @volgnummer = @MAXvolgnummer + 1
	END
	ELSE BEGIN
		SET @volgnummer = 1
	END
	SET @beschrijving = 'lorem ipsum dolrora halamagalama'	
	INSERT REPARATIEQUEUE VALUES
	(@count3,@workshop,@volgnummer,@beschrijving)
	SET @count3 = @count3 + 1
END

-- insert outqueue
DECLARE @count4 INT = 19951
DECLARE @workshop2 INT
WHILE @count4 <= 20000
BEGIN
	SET @workshop2 = 1 + (CAST(RAND()*7000086 AS INT)%(select max(WORKSHOPID) from WORKSHOP))
	INSERT OUTQUEUE VALUES
	(@count4,@workshop2)
	SET @count4 = @count4 + 1
END
