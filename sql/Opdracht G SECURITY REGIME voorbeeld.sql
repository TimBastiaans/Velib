use gelre_airport
go

-- security regime voor baliemedewerkers. 
-- creeer de logins voor de baliemedewerkers.
CREATE LOGIN BalieMedewerker_Harry WITH PASSWORD = '1234', DEFAULT_DATABASE = [gelre_airport]
CREATE LOGIN BalieMedewerker_Willy WITH PASSWORD = '1234', DEFAULT_DATABASE = [gelre_airport]
CREATE LOGIN BalieMedewerker_Jan WITH PASSWORD = '1234', DEFAULT_DATABASE = [gelre_airport]
CREATE LOGIN BalieMedewerker_Henk WITH PASSWORD = '1234', DEFAULT_DATABASE = [gelre_airport]
CREATE LOGIN BalieMedewerker_Joop WITH PASSWORD = '1234', DEFAULT_DATABASE = [gelre_airport]

-- creeer wat users
CREATE USER Harry FOR LOGIN BalieMedewerker_Harry 
CREATE USER Willy FOR LOGIN BalieMedewerker_Willy 
CREATE USER Jan FOR LOGIN BalieMedewerker_Jan 
CREATE USER Henk FOR LOGIN BalieMedewerker_Henk
CREATE USER Joop FOR LOGIN BalieMedewerker_Joop
go

-- geef benodigde rechten
GRANT SELECT ON [Passagier] TO Harry
GRANT SELECT ON [Passagier] TO Willy
GRANT SELECT ON [Passagier] TO Jan
GRANT SELECT ON [Passagier] TO Henk
GRANT SELECT ON [Passagier] TO Joop

GRANT UPDATE ON [PassagierVoorVlucht] TO Harry
GRANT UPDATE ON [PassagierVoorVlucht] TO Willy
GRANT UPDATE ON [PassagierVoorVlucht] TO Jan
GRANT UPDATE ON [PassagierVoorVlucht] TO Henk
GRANT UPDATE ON [PassagierVoorVlucht] TO Joop

GRANT SELECT ON [PassagierVoorVlucht] TO Harry
GRANT SELECT ON [PassagierVoorVlucht] TO Willy
GRANT SELECT ON [PassagierVoorVlucht] TO Jan
GRANT SELECT ON [PassagierVoorVlucht] TO Henk
GRANT SELECT ON [PassagierVoorVlucht] TO Joop

GRANT SELECT, UPDATE, DELETE, INSERT ON [Object] TO Harry
GRANT SELECT, UPDATE, DELETE, INSERT ON [Object] TO Willy
GRANT SELECT, UPDATE, DELETE, INSERT ON [Object] TO Jan
GRANT SELECT, UPDATE, DELETE, INSERT ON [Object] TO Henk
GRANT SELECT, UPDATE, DELETE, INSERT ON [Object] TO Joop

-- test
REVERT

-- Baliemedewerkers kunnen wel SELECT statements op de tabel Passagier uitvoeren
-- maar geen DELETE, INSERT, of UPDATE statements
EXECUTE AS USER = 'Willy' -- impersonate Harry

select * from Passagier -- dit mag wel
delete from Passagier where naam = 'piet' -- dit niet
update Passagier set geslacht = 'V' where naam = 'piet' -- dit ook niet
insert Passagier values(1800,'Billy','M','1990-12-19 00:00:00.000') -- dit ook niet

-- Baliemedewerkers kunnen UPDATE en SELECT statements op de tabel PassagierVoorVlucht
-- uitvoeren maar geen INSERT of DELETE statements
EXECUTE AS USER = 'Joop' -- impersonate Joop

select * from PassagierVoorVlucht -- dit mag wel
update PassagierVoorVlucht set stoel = 5 where passagiernummer = 1002 -- dit mag ook
delete from PassagierVoorVlucht where passagiernummer = 1002 -- dit mag niet
insert PassagierVoorVlucht values (850,5315,4,null,null) -- dit mag ook niet

-- Baliemedewerkers kunnen INSERT, SELECT, UPDATE, DELETE statements uitvoeren
-- op de tabel [Object] 
EXECUTE AS USER = 'Henk' -- impersonate Henk

insert [Object] values (21,1002,5315,10) -- dit mag
select * from [Object] -- dit mag
update [Object] set gewicht = 5 where volgnummer = 21 -- dit mag
delete from [Object] where volgnummer = 21 -- dit mag



