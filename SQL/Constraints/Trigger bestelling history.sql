USE Velib
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE [type] = 'TR' AND [name] = 'TG_maakBestellingHistorie')
BEGIN DROP TRIGGER TG_maakBestellingHistorie END
GO

CREATE TRIGGER TG_maakBestellingHistorie
ON BESTELLING
AFTER DELETE
AS
IF @@ROWCOUNT = 0 RETURN
SET NOCOUNT ON
BEGIN
	INSERT INTO BESTELLING_HISTORY 
	SELECT ORDERID, 
		   WORKSHOPID,
		   l.NAAM,
		   fo.NAAM,
		   AANTAL,
		   GETDATE(),
		   SYSTEM_USER
	FROM deleted d
	INNER JOIN LEVERANCIER l ON d.LEVERANCIERID = l.LEVERANCIERID
	INNER JOIN FIETSONDERDEEL fo ON d.ONDERDEELID = fo.ONDERDEELID
	where ORDERID = d.ORDERID
END
GO

-- TEST
begin transaction
	alter table BESTELLING disable trigger TG_maakBestellingHistorie
	delete from BESTELLING
	delete from BESTELLING_HISTORY
	alter table BESTELLING enable trigger TG_maakBestellingHistorie
	select * from BESTELLING_HISTORY -- er zit niks in de history tabel
	insert BESTELLING values -- voeg wat records toe om verwijderd te worden
	(1,1,1,1,'2017-11-11 00:00:00',40),
	(2,1,1,1,'2017-11-10 00:00:00',40),
	(3,1,1,1,'2017-11-09 00:00:00',40)
	delete from BESTELLING -- verwijder ze weer om de trigger te triggeren
	select * from BESTELLING_HISTORY -- records toegevoegd aan de history tabel zoals je ziet
rollback transaction