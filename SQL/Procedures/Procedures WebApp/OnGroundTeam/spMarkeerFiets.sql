use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spMarkeerFiets')
DROP PROCEDURE spMarkeerFiets
GO

--fiets wordt gemarkeerd als MoetGechecktWorden
CREATE PROCEDURE spMarkeerFiets
(
@FIETSID INT
)
AS
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
	if exists (select 1 from FIETSPOST where FIETSID = @FIETSID and MOETGECHECKTWORDEN = '0')
	begin
		UPDATE FIETSPOST SET MOETGECHECKTWORDEN = '1' where FIETSID = @FIETSID
		end
		else
		begin
		raiserror('deze fiets bestaat niet, of is al gemarkeerd om gecheckt te worden', 16,1)
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



--test successcenario
begin tran
--beginsituatie: 2 fietsen in station 1, fiets 2 moet gecheckt worden, fiets 1 niet.
insert into STATION values
('1', '1', '1', 'hier', '50', '0')
insert into FIETS values
('1', null), ('2', null), ('3', null)
insert into FIETSPOST values
('1', '1', '1', '0'), ('1', '2', '2', '1')
select * from FIETSPOST
begin try
--markeer fiets 1 om gecheckt te worden.
exec spMarkeerFiets 1
end try
begin catch
print 'shit is niet goed gegaan'
end catch
--verwachte eindsituatie: 2 fietsen in station 1, beide moeten gecheckt worden
select * from FIETSPOST
rollback tran


--test failscenario
begin tran
--beginsituatie: 2 fietsen in station 1, fiets 2 moet gecheckt worden, fiets 1 niet.
insert into STATION values
('1', '1', '1', 'hier', '50', '0')
insert into FIETS values
('1', null), ('2', null), ('3', null)
insert into FIETSPOST values
('1', '1', '1', '0'), ('1', '2', '2', '1')
select * from FIETSPOST
begin try
--markeer fiets 2 om gecheckt te worden.
exec spMarkeerFiets 2
end try
begin catch
print 'shit is niet goed gegaan'
end catch
--verwachte eindsituatie: er is niks veranderd
select * from FIETSPOST
rollback tran