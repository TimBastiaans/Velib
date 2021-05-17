use Velib

DELETE FROM STATION_IN_SPECIAAL_EVENEMENT
DELETE FROM SPECIAAL_EVENEMENT
DELETE FROM VOLTOOIDE_LENING
DELETE FROM KLANTHEEFTABONNEMENT
DELETE FROM dbo.BESTELLING
DELETE FROM dbo.REPARATIE
DELETE FROM dbo.FIETSONDERDEELINWORKSHOP
DELETE FROM dbo.FIETSONDERDEELBIJLEVERANCIER
DELETE FROM dbo.MONTEURDIENST
DELETE FROM dbo.ONGROUNDCONTROLE
DELETE FROM dbo.ROUTINGCARD
DELETE FROM FIETSONDERDEELINWORKSHOP
DELETE FROM dbo.FIETSONDERDEEL
DELETE FROM REPARATIEQUEUE
DELETE FROM dbo.WORKSHOP
DELETE FROM ABONNEMENTTYPE
DELETE FROM FIETSPOST
DELETE FROM FIETS
DELETE FROM STATION
DELETE FROM KLANT
DELETE FROM dbo.ADMIN
DELETE FROM dbo.LEVERANCIER
DELETE FROM dbo.WERKNEMER
DELETE FROM ONGROUNDTEAM
DELETE FROM dbo.ROUTINGCARD
DELETE FROM KLANT
DELETE FROM [ADMIN]

GO

INSERT INTO FIETS
VALUES 
(431,NULL), (432,NULL), (433,NULL), (434,NULL), (435,NULL),(436,NULL), (437,NULL), (438,NULL), (439,NULL), (440,NULL), (442,NULL),
(443,NULL), (444,NULL), (445,NULL), (446,NULL), (447,NULL), (448,NULL), (449,NULL), (450,NULL), (451,NULL), (452,NULL), (453,NULL), (454,NULL),(455,NULL), (456,NULL), (457,NULL)

INSERT INTO STATION
VALUES (1,2,2,'Parkeerplaats achterbuurt',80,1), (2,1,2,'bloemstraat',80,1), (3,1,1,'mapleroad',80,1), (4,3,1,'dijkstraat',80,1), (5,2,1,'plein 1922',80,1), (6,3,3,'nec-stadion',80,1), (7,4,3,'nijmegens station',80,1), (8,5,3,'abustrausse',80,1), (9,1,4,'la calle',80,1), (10,2,4,'hondstraat',80,1)

INSERT INTO FIETSPOST
VALUES (1,1,431,1), (1,2,432,1), (1,3,433,1), (1,4,435,1), (1,6,440,0), (2,1,436,0), (1,7,437,0), (1,8,438,0), (1,9,439,0), (1,10,442,0), (3,1,443,0), (3,2,444,0), (3,3,445,0), (3,4,446,0), (3,5,447,0), (4,1,448,0), (4,2,449,0), (4,3,450,0), (4,4,451,0), (4,5,452,0)

insert into FIETSONDERDEEL
values (1, 'Fietszadel', 'Hier kun je op zitten', 50, 30),
	   (2, 'Fietsstuur', 'Hiermee kun je sturen', 60, 40),
	   (3, 'Fietswiel', 'Dit is een wiel', 70, 45)
GO

insert into WORKSHOP
values (1, 'Workshopadres 1'),
	   (2, 'Workshopadres 2')
GO

insert into FIETSONDERDEELINWORKSHOP
values (1, 1, 30),
	   (2, 1, 24),
	   (3, 1, 15),
	   (1, 2, 30),
	   (2, 2, 25),
	   (3, 2, 35)
GO

insert into LEVERANCIER
values (1, 'Luxe Onderdelen', 0600000000, 'info@luxeonderdelen.nl'),
	   (2, 'Cheap Ass Parts', 0600000001, 'info@cheapassparts.nl')
GO

insert into FIETSONDERDEELBIJLEVERANCIER
values (1, 1, 5),
       (1, 2, 6),
	   (1, 3, 7),
	   (2, 1, 4),
	   (2, 3, 8)
GO

insert into BESTELLING
values (1, 1, 1, 1, GETDATE ( ), 2),
       (2, 1, 1, 2, GETDATE ( ), 3),
	   (3, 1, 1, 3, GETDATE ( ), 4),
	   (4, 2, 2, 1, GETDATE ( ), 5),
       (5, 2, 1, 2, GETDATE ( ), 2),
	   (6, 2, 2, 3, GETDATE ( ), 1)
GO

INSERT ONGROUNDTEAM VALUES
(1),
(2),
(3)
GO

INSERT WERKNEMER VALUES
(0,	1, 'Super','Man','Detriot', '1244EE','$2y$10$pM5v76i2.tMnY8nl3GkObehY374CauI6RzPE4NvoD3..E2u6Rha1q',1),
(1, NULL, 'Piet','de Monteur','bloempotten straat 2029','1234RE','$2y$10$pM5v76i2.tMnY8nl3GkObehY374CauI6RzPE4NvoD3..E2u6Rha1q',1),
(2, 1, 'Henk','Onground medewerker','bloempotten straat 2029','1234RE','$2y$10$pM5v76i2.tMnY8nl3GkObehY374CauI6RzPE4NvoD3..E2u6Rha1q',1),
(3, NULL, 'job','Kansloos','bloempotten straat 2029','1234RE','$2y$10$pM5v76i2.tMnY8nl3GkObehY374CauI6RzPE4NvoD3..E2u6Rha1q',1),
(4, 1, 'jopie','jansen','bloempotten straat 2029','1234RE','$2y$10$pM5v76i2.tMnY8nl3GkObehY374CauI6RzPE4NvoD3..E2u6Rha1q',0),
(5, NULL, 'gert','timmerman','bloempotten straat 2029','1234RE','$2y$10$pM5v76i2.tMnY8nl3GkObehY374CauI6RzPE4NvoD3..E2u6Rha1q',1),
(6, NULL, 'johan','bank','bloempotten straat 2029','1234RE','$2y$10$pM5v76i2.tMnY8nl3GkObehY374CauI6RzPE4NvoD3..E2u6Rha1q',1),
(7, NULL, 'hans','lans','bloempotten straat 2029','1234RE','$2y$10$pM5v76i2.tMnY8nl3GkObehY374CauI6RzPE4NvoD3..E2u6Rha1q',1),
(8, NULL, 'leo','leeuw','bloempotten straat 2029','1234RE','$2y$10$pM5v76i2.tMnY8nl3GkObehY374CauI6RzPE4NvoD3..E2u6Rha1q',1),
(9, NULL, 'harry','molen','bloempotten straat 2029','1234RE','$2y$10$pM5v76i2.tMnY8nl3GkObehY374CauI6RzPE4NvoD3..E2u6Rha1q',1),
(10, NULL, 'jan','kaas','bloempotten straat 2029','1234RE','$2y$10$pM5v76i2.tMnY8nl3GkObehY374CauI6RzPE4NvoD3..E2u6Rha1q',1),
(11, NULL, 'peter','pannekoek','bloempotten straat 2029','1234RE','$2y$10$pM5v76i2.tMnY8nl3GkObehY374CauI6RzPE4NvoD3..E2u6Rha1q',1),
(12, NULL, 'anne','raam','bloempotten straat 2029','1234RE','$2y$10$pM5v76i2.tMnY8nl3GkObehY374CauI6RzPE4NvoD3..E2u6Rha1q',1),
(13, NULL, 'marie','been','bloempotten straat 2029','1234RE','$2y$10$pM5v76i2.tMnY8nl3GkObehY374CauI6RzPE4NvoD3..E2u6Rha1q',1),
(14, NULL, 'truus','de boer','bloempotten straat 2029','1234RE','$2y$10$pM5v76i2.tMnY8nl3GkObehY374CauI6RzPE4NvoD3..E2u6Rha1q',1),
(15, NULL, 'rob','de jong','bloempotten straat 2029','1234RE','$2y$10$pM5v76i2.tMnY8nl3GkObehY374CauI6RzPE4NvoD3..E2u6Rha1q',1)
GO

INSERT ROUTINGCARD VALUES
(1,'2018-01-22 10:00:00', 1),
(1,'2018-01-22 20:00:00', 2),
(1,'2018-01-22 12:00:00', 3),
(2,'2018-01-22 10:00:00', 4),
(2,'2018-01-22 20:00:00', 5),
(2,'2018-01-22 12:00:00', 6),
(3,'2018-01-22 20:00:00', 7),
(3,'2018-01-22 10:00:00', 8),
(3,'2018-01-22 11:00:00', 9),
(1,'2018-01-22 13:00:00', 9),
(1,'2018-01-22 14:00:00', 7)
GO

INSERT MONTEURDIENST VALUES 
(1 , '2018-01-17 10:00:00', 1 ,'2018-01-17 19:00:00'),
(1 , '2018-01-22 10:00:00', 1 ,'2018-01-22 18:00:00'),
(1 , '2018-01-23 20:00:00', 2 ,'2018-01-23 23:00:00'),
(1 , '2018-01-24 20:00:00', 2 ,'2018-01-24 23:00:00'),

(5 , '2018-01-19 20:00:00', 2 ,'2018-01-19 23:00:00'),
(5 , '2018-01-20 10:00:00', 2 ,'2018-01-20 18:00:00')
GO

INSERT INTO REPARATIE
VALUES (442,1,'2017-11-21 11:00:00',1),
(445,3,'2017-11-20 10:00:00',5),
(432,1,'2017-11-22 13:00:00',10),
(448,2,'2017-11-23 19:00:00',11),
(440,2,'2017-11-18 16:00:00',6)
GO



insert into REPARATIEQUEUE
VALUES(1,1,453,'zadel moet vervangen worden',0),
(1,2,454,'Fiets was total los verklaard',0),
(2,1,455,'wiel moet vervangen worden',0),
(2,2,434,'buitenband vervangen',0),
(2,3,457,'Er zit geen fietsbel opp de fiets',0)
GO

INSERT INTO ABONNEMENTTYPE VALUES
('Velib Classic', 29, 365, 1),
('Velib Passion', 39, 365, 1),
('Velib Solidarity', 19, 365, 1),
('1-day ticket', 1.70, 1, 0),
('7-day ticket', 8, 7, 0),
('Velib Passion Young', 29, 365, 1),
('Velib Passion Student', 19, 365, 1),
('Velib Passion Socio', 19, 365, 1)

insert into SPECIAAL_EVENEMENT values
(1,'NEC - Vitesse','01-01-2019 18:00:00','Beleef de gelderse derby helemaal in parijs'),
(2,'Oktoberfest','11-10-2018 21:00:00','Het duitse bierfissa, helemaal naar de klote gaan dus.'),
(3,'Tour de france','03-04-2018 12:00:00','Fietsrace vanuit nederland helemaal naar ergens in frankrijk.'),
(4,'Gay parade','03-04-2018 18:00:00','regenbogen everywhere'),
(5,'Marco borsato live!','03-04-2018 19:00:00','Muziekconcert van Marco Borsato.')

INSERT INTO KLANT
VALUES (1,'piet','gans','bloemstraat 19','4628KA', '12-02-2000',1,0),
(2,'Steve','ball','opdedijkstraat 19','4628KA', '03-09-1990',1,0),
(3,'gerard','janssen','omdehoek 19','4628KA', '05-04-1989',1,0),
(4,'sjon','schapp','indewei 20','4628KA', '12-11-1989',1,0)

INSERT INTO KLANTHEEFTABONNEMENT
VALUES('Velib classic', 4, GETDATE(), '2018-11-12 12:00:00',null,10,1)


insert into STATION_IN_SPECIAAL_EVENEMENT values
(1,1),
(2,1),
(3,2),
(5,2),
(2,3),
(1,3),
(4,4),
(3,4),
(2,5),
(1,5),
(6,5)

INSERT INTO VOLTOOIDE_LENING
VALUES(1,440,'2018-01-10 01:00:00',1,3,'2017-11-23 02:00:00',2,0),
(1,440,'2018-01-01 01:00:00',10,2,'2017-10-23 02:00:00',2,0),
(1,440,'2018-01-08 01:00:00',2,5,'2017-09-23 02:00:00',2,0)

INSERT INTO [ADMIN]
VALUES(0)

