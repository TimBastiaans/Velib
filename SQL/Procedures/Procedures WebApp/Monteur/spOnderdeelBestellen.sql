USE Velib
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE [type] = 'P' AND [name] = 'spOnderdeelbestellen')
BEGIN DROP PROCEDURE spOnderdeelbestellen END
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
	IF exists (select 1 from BESTELLING)
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

delete from bestelling
select * from bestelling
insert into bestelling 
values (1, 1, 1, 1, GETDATE(), 5)

-- TEST successcenario
begin transaction
insert FIETSONDERDEEL values(1,'ergg','fkjagf',300,10)
insert WORKSHOP values (1,1)
insert LEVERANCIER values (1,'efaggg',06437843,'rhs@ihre')
insert FIETSONDERDEELBIJLEVERANCIER values(1,1,23)
insert FIETSONDERDEELINWORKSHOP values(1,1,30)
--probeer onderdeel 1 bij leverancier 1 te bestellen
begin try
exec spOnderdeelbestellen 1,1,1,10
end try
begin catch
print 'EEEHHH error'
end catch
select * from BESTELLING
rollback transaction

-- TEST failscenario
begin transaction
insert FIETSONDERDEEL values(1,'ergg','fkjagf',300,10)
insert WORKSHOP values (1,1)
insert LEVERANCIER values (1,'efaggg',06437843,'rhs@ihre')
insert FIETSONDERDEELBIJLEVERANCIER values(1,1,23)
insert FIETSONDERDEELINWORKSHOP values(1,1,30)
--probeer onderdeel 3 bij leverancier 1 te bestellen
begin try
exec spOnderdeelbestellen 1,1,3,10
end try
begin catch
print 'EEEHHH error'
end catch
--leverancier 1 verkoopt onderdeel 3 niet, dus bestelling blijft leeg
select * from BESTELLING
rollback transaction