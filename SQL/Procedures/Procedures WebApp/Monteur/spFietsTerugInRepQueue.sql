
use Velib
GO
/*
Monteur kan een fiets terug in de reparatie queue zetten.
Input: FietsID, nieuwe beschrijving
*/

IF EXISTS(select * from sys.objects where type = 'P' AND name='spFietsTerugInRepQueue')
DROP PROCEDURE spFietsTerugInRepQueue
GO


--De beschrijving van de kapotte fiets wordt aangepast
CREATE PROCEDURE spFietsTerugInRepQueue
	@FIETSID INT,
	@BESCHRIJVING VARCHAR(MAX) = null
AS
	SET TRANSACTION  ISOLATION LEVEL REPEATABLE READ 
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 -- alternatief: IF (XACT_STATE()) = 1
		SAVE TRANSACTION ProcedureSave;
	ELSE -- alternatief: IF (XACT_STATE()) = 0
		BEGIN TRANSACTION;
	BEGIN TRY
		IF exists (select 1 from REPARATIEQUEUE where FIETSID = @FIETSID and WORDT_GEREPAREERD = '0')
			raiserror('Deze fiets staat al in de reparatiequeue', 16, 1)
		IF exists (select 1 from REPARATIEQUEUE where FIETSID = @FIETSID)
			Begin
				update REPARATIEQUEUE set WORDT_GEREPAREERD = '0' where FIETSID = @FIETSID
				update REPARATIEQUEUE set BESCHRIJVING = @BESCHRIJVING where FIETSID = @FIETSID
			end
		else
			begin
				raiserror('Deze fiets stond niet in de reparatieQueue', 16, 1)
			end
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
GO

/*	Testcase fiets terug in de que plaatsen */



BEGIN TRANSACTION
INSERT INTO WORKSHOP
VALUES (1, 'Dit is een adres')

INSERT INTO FIETS
VALUES (1,null)

insert into REPARATIEQUEUE values ('1', '1', '1', 'fiets is kapot', '0')
select * from REPARATIEQUEUE

EXEC spFietsTerugInRepQueue @FIETSID = 1, @beschrijving = 'fiets is nog steeds kapot'
select * FROM REPARATIEQUEUE
ROLLBACK TRANSACTION