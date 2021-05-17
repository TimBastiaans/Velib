-- enforce br3  Alleen klanten met een Long term abonnement kunnen een prepaid kaart hebben.

update KLANTHEEFTABONNEMENT
set PREPAIDTEGOED = null
from KLANTHEEFTABONNEMENT i INNER JOIN ABONNEMENTTYPE t 
ON i.ABONNEMENTTYPE = t.ABONNEMENTTYPE 
where i.PREPAIDTEGOED is not null and t.LONGTERM = '0'

DECLARE @klantnummer INT
DECLARE @startdatum DATETIME
DECLARE muis CURSOR FOR 
SELECT KLANTNUMMER, START_DATUM
from KLANTHEEFTABONNEMENT i INNER JOIN ABONNEMENTTYPE t 
ON i.ABONNEMENTTYPE = t.ABONNEMENTTYPE 
where t.LONGTERM = '1'

OPEN muis
FETCH NEXT FROM muis INTO @klantnummer, @startdatum
WHILE @@FETCH_STATUS = 0
BEGIN
	UPDATE KLANTHEEFTABONNEMENT
	SET PREPAIDTEGOED = 5 + (cast(rand()*10000 AS int)%80)
	WHERE KLANTNUMMER = @klantnummer
	AND START_DATUM = @startdatum
	FETCH NEXT FROM muis INTO @klantnummer, @startdatum
END
CLOSE muis
DEALLOCATE muis