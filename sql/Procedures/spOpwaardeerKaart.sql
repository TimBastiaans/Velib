/* Procedure Opwaardeer Kaart										*/ 
/* Parameters:													    */ 
/* @KLANTID is de persoon dat de fiets terug zet					*/ 
/* @GELD Het geld wat de klant wilt opwaarderen						*/ 

use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spOpwaardeerKaart')
DROP PROCEDURE spOpwaardeerKaart
GO

CREATE PROCEDURE spOpwaardeerKaart
(
@KLANTID integer,
@GELD numeric(5,2)
)
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 
		SAVE TRANSACTION ProcedureSave;
	ELSE 
		BEGIN TRANSACTION;
	BEGIN TRY

	IF NOT EXISTS (SELECT 1 FROM KLANT WHERE KLANTID = @KLANTID)
	RAISERROR('Klant Bestaat niet',16,1)

	IF(@GELD < 0.50)
	RAISERROR('Je kan niet minder dan € 0,50 opwaarderen. ',16,1)

		IF exists (select 1 from KLANTHEEFTABONNEMENT where KLANTID = @klantID and PREPAIDTEGOED is not null and EIND_TIJD > GETDATE())
			begin
				UPDATE KLANTHEEFTABONNEMENT SET PREPAIDTEGOED += @geld where KLANTID = @KLANTID and EIND_TIJD > GETDATE()
			end;
		ELSE
			BEGIN
			raiserror('klant heeft geen prepaid abonnement',16,1)
			END;
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



--test cases

insert into KLANTHEEFTABONNEMENT values
('standard', '1', '2017-11-11 11:00:00', '2018-11-11 11:00:00', null, '2.34', '0'),
('standard', '2', '2017-11-11 11:00:00', '2018-11-11 11:00:00', '928227', null, '0')

--klant '1' heeft een prepaidabonnement en zet er 10 euro op (kan wel)
begin transaction
select * from KLANTHEEFTABONNEMENT
exec spOpwaardeerKaart @KLANTID = '1', @geld = '0.25'
select * from KLANTHEEFTABONNEMENT
rollback transaction

--klant '2' heeft geen prepaidabonnement en probeert 10 euro erbij te zetten (kan niet)
begin transaction
select * from KLANTHEEFTABONNEMENT
exec spOpwaardeerKaart @KLANTID = '2', @geld = '10.00'
select * from KLANTHEEFTABONNEMENT
rollback transaction
