use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spFietsRedistributie')
DROP PROCEDURE spFietsRedistributie
GO

CREATE PROCEDURE spFietsRedistributie	
	@fiets INT,
	@naar_station1_workshop0 BIT,
	@locatieID INT,
	@fietspost INT = null -- als de fiets naar een station gaat vul dit in
AS
BEGIN
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 
		SAVE TRANSACTION ProcedureSave;
	ELSE
		BEGIN TRANSACTION;
	BEGIN TRY
		-- check waar de fiets op het moment is
		-- en haal hem daar weg
		IF EXISTS(SELECT 1 FROM FIETS 
				  WHERE @fiets = FIETSID
				  AND WORKSHOPID > 0)
		BEGIN 
			UPDATE FIETS
			SET WORKSHOPID = null
			WHERE FIETSID = @fiets
		END
		ELSE IF EXISTS(SELECT 1 FROM FIETSPOST
					   WHERE @fiets = FIETSID)
		BEGIN 
			DELETE FROM FIETSPOST
			WHERE FIETSID = @fiets
		END
		ELSE IF EXISTS(SELECT 1 FROM UITGELEENDE_FIETS
					   WHERE @fiets = FIETSID)
		BEGIN 
			RAISERROR ('Deze fiets is op het moment in lening',16,1)
		END

		-- voer het in de database
		IF @naar_station1_workshop0 = 0 BEGIN
			-- lever af
			UPDATE FIETS
			SET WORKSHOPID = @locatieID
			WHERE FIETSID = @fiets
		END ELSE BEGIN
			-- lever af
			INSERT FIETSPOST VALUES
			(@locatieID,@fietspost,@fiets,0)
		END
		IF @TranCounter = 0 AND XACT_STATE() = 1
			COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		THROW
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


/*		Testcases	   */
begin transaction
set nocount on
	delete from FIETSPOST
	delete from STATION
	delete from FIETS
	insert FIETS values(1,null)
	insert STATION values(1,1,1,'rggeagr',45,0)
	insert FIETSPOST values(1,1,1,0)
	insert WORKSHOP VALUES(1,'rthssshs')

	-- van station naar station
	print'van station naar station'
	select * from FIETSPOST
	exec spFietsRedistributie 1,1,1,2
	select * from FIETSPOST

	delete from FIETSPOST
	delete from STATION
	delete from FIETS
	delete from WORKSHOP
	insert FIETS values(1,null)
	insert STATION values(1,1,1,'rggeagr',45,0)
	insert FIETSPOST values(1,1,1,0)
	insert WORKSHOP VALUES(1,'rthssshs')

  	-- van station naar workshop
	print 'van station naar workshop'
	select * from FIETSPOST
	select * from FIETS
	exec spFietsRedistributie 1,0,1,null
	select * from FIETSPOST
	select * from FIETS

	delete from FIETSPOST
	delete from STATION
	delete from FIETS
	delete from WORKSHOP
	insert FIETS values(1,null)
	insert STATION values(1,1,1,'rggeagr',45,0)
	insert WORKSHOP VALUES(1,'rthssshs')

	-- van workshop naar station
	print 'van workshop naar station'
	select * from FIETSPOST
	select * from FIETS
	exec spFietsRedistributie 1,1,1,5
	select * from FIETSPOST
	select * from FIETS
set nocount off
rollback transaction