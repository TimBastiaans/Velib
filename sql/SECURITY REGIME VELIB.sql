use Velib
begin transaction

-- Maak logins voor onze security groepen
CREATE LOGIN [Admin] WITH PASSWORD = '1234', DEFAULT_DATABASE = [Velib]
CREATE LOGIN Monteur WITH PASSWORD = '1234', DEFAULT_DATABASE = [Velib]
CREATE LOGIN OnGroundTeam WITH PASSWORD = '1234', DEFAULT_DATABASE = [Velib]

-- maak users bij de logins
CREATE USER AdminUser FOR LOGIN [Admin]
CREATE USER MonteurUser FOR LOGIN Monteur
CREATE USER OnGroundTeamUser FOR LOGIN OnGroundTeam

-- geef de admin rechten op alles, monteurs en ongroundteam alleen select op alles
DECLARE tblCursor CURSOR FOR
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
DECLARE @table VARCHAR(100)
DECLARE @stmt NVARCHAR(MAX)
OPEN tblCursor
FETCH NEXT FROM tblCursor INTO @table
WHILE @@FETCH_STATUS = 0 BEGIN
	SET @stmt = (
		'GRANT SELECT,UPDATE,DELETE,INSERT ON '
		+ @table + ' TO AdminUser'
	)
	EXECUTE sp_executesql @stmt
	SET @stmt = ('GRANT SELECT ON ' + @table + ' TO MonteurUser')
	EXECUTE sp_executesql @stmt
	SET @stmt = ('GRANT SELECT ON ' + @table + ' TO OnGroundTeamUser')
	EXECUTE sp_executesql @stmt
	FETCH NEXT FROM tblCursor INTO @table
END
CLOSE tblCursor
DEALLOCATE tblCursor

-- geef admin rechten op alle stored procedures
DECLARE spCursor CURSOR FOR
SELECT [name] FROM sys.objects 
WHERE [type] = 'P'
DECLARE @sp VARCHAR(100)
OPEN spCursor
FETCH NEXT FROM spCursor INTO @sp
WHILE @@FETCH_STATUS = 0 BEGIN
	SET @stmt = ('GRANT EXECUTE ON OBJECT::' + @sp + ' TO AdminUser')
	EXECUTE sp_executesql @stmt
	FETCH NEXT FROM spCursor INTO @sp
END
CLOSE spCursor
DEALLOCATE spCursor

-- geef de monteurs rechten op de stored procedures die ze nodig hebben.
GRANT EXECUTE ON OBJECT::spFietsNaarOutqueue TO MonteurUser
GRANT EXECUTE ON OBJECT::spFietsNaarStation TO MonteurUser
GRANT EXECUTE ON OBJECT::spFietsTerugInRepQueue TO MonteurUser
GRANT EXECUTE ON OBJECT::spInventarisBijwerken TO MonteurUser
GRANT EXECUTE ON OBJECT::spOnderdeelBestellen TO MonteurUser
GRANT EXECUTE ON OBJECT::spPakFietsOmTeRepareren TO MonteurUser

-- geef het ongroundteam rechten op de stored procedures die ze nodig hebben.
GRANT EXECUTE ON OBJECT::spFietsNaarWorkshop TO OnGroundTeamUser
GRANT EXECUTE ON OBJECT::spMarkeerFiets TO OnGroundTeamUser
GRANT EXECUTE ON OBJECT::spOnGroundControle TO OnGroundTeamUser
GRANT EXECUTE ON OBJECT::spVoegReparatieToe TO OnGroundTeamUser

rollback transaction
go

