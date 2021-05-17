
--Velib Solidarity ||  Velib Classic || Velib Passion || 1-day ticket || 7-day ticket
USE Velib

select * from VOLTOOIDE_LENING
select * from KLANT
select * from KLANTHEEFTABONNEMENT
select * from ABONNEMENTTYPE
select * from FIETSPOST
select * from STATION
select * from FIETS

BEGIN TRANSACTION
insert into KLANTHEEFTABONNEMENT values
('7-day ticket', '1', '2017-11-28 11:00:00', '2018-11-28 11:00:00', null, '8.12', '0'),
('Velib Passion Young', '2', '2017-11-28 11:00:00', '2018-11-28 11:00:00', '7282782', null, '0'),
('Velib Solidarity', '3', '2017-11-28 11:00:00', '2017-12-05 11:00:00', '323313', null, '0')

INSERT INTO STATION
VALUES	(11,1,1,'straat',80,0),
		(12,2,1,'straat2',80,1)

INSERT INTO FIETS
VALUES (1,null)

INSERT INTO FIETSPOST
VALUES (11,1,1,0)

INSERT INTO KLANT
values (1, 'piet','heijn','straat','6551 ZN', '1997-10-02',1, 0),
(2, 'pietjuh','heijn','straat','6551 ZN', '1997-10-02',0,1),
(3, 'pietje','heijn','straat','6551 ZN', '1997-10-02',0,1),
(4, 'karel','heijn','straat','6551 ZN', '1997-10-02',1,0),
(5, 'mopp','heijn','straat','6551 ZN', '1997-10-02',1,0)
COMMIT TRANSACTION


/*		Testcase spFiets_word_in_FIETSPOST_gezet		*/
/*		Abonnement solidarity							*/
BEGIN TRAN
INSERT UITGELEENDE_FIETS 
VALUES (1,1,'2017-12-15 08:35:54',10,0);

EXEC spFiets_word_in_FIETSPOST_gezet @FIETSID = 1 ,@KLANTID = 3, @EINDSTATION = 11, @FIETSPOST = 1
SELECT * FROM VOLTOOIDE_LENING where KLANTID = 3 and fietsid = 1
ROLLBACK TRAN

delete FIETSPOST where FIETSID = 1

/*		Abonnement 	7 dagen	+ extratijd				*/
BEGIN TRAN
INSERT UITGELEENDE_FIETS 
VALUES (1,1,'2017-12-15 08:35:54',12,1);

EXEC spFiets_word_in_FIETSPOST_gezet @FIETSID = 1 ,@KLANTID = 1, @EINDSTATION = 11, @FIETSPOST = 1
SELECT * FROM VOLTOOIDE_LENING where KLANTID = 1 and fietsid = 1
ROLLBACK TRAN


--Getest 17-januari 2018 testcase 1
BEGIN TRAN
DELETE FIETSPOST WHERE FIETSID = 1
DELETE VOLTOOIDE_LENING
DELETE UITGELEENDE_FIETS
INSERT UITGELEENDE_FIETS 
VALUES (1,4,'2018-01-17 08:35:54',10,0);
UPDATE KLANTHEEFTABONNEMENT 
SET START_DATUM = '2018-01-10 08:35:54'
WHERE KLANTID = 4

begin try
EXEC spFiets_word_in_FIETSPOST_gezet @FIETSID = 1 ,@KLANTID = 4, @EINDSTATION = 9, @FIETSPOST = 1
end try
begin catch
throw
end catch
SELECT * FROM VOLTOOIDE_LENING where KLANTID = 4 and fietsid = 1
select * from KLANTHEEFTABONNEMENT
ROLLBACK TRAN


	
