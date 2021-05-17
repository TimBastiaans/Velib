/* Procedure fiets word in station gezet							*/ 
/* Parameters:													    */ 
/* @FIETSID is de fiets dat terug geplaats word in het fietsstation */ 
/* @KLANTID is de persoon dat de fiets terug zet					*/ 
/* @EINDSTATION is het station waar de fiets naar toe is gebracht	*/ 
use Velib
GO

IF EXISTS(select * from sys.objects where type = 'P' AND name='spFiets_word_in_FIETSPOST_gezet')
DROP PROCEDURE spFiets_word_in_FIETSPOST_gezet
GO

CREATE PROCEDURE spFiets_word_in_FIETSPOST_gezet
 @FIETSID INT,
 @KLANTID INT,
 @EINDSTATION INT,
 @FIETSPOST INT
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON 
	SET XACT_ABORT OFF
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0 -- alternatief: IF (XACT_STATE()) = 1
		SAVE TRANSACTION ProcedureSave;
	ELSE -- alternatief: IF (XACT_STATE()) = 0
		BEGIN TRANSACTION;
	BEGIN TRY
		IF EXISTS (select 1 AS Aantal_Stations from FIETSPOST F
						INNER JOIN STATION S 
						ON F.STATIONID = S.STATIONID
						WHERE F.STATIONID = @EINDSTATION
						GROUP BY F.STATIONID, S.CAPACITEIT
						HAVING COUNT(F.STATIONID) >= S.CAPACITEIT
					)
				BEGIN
				/* Gebruiker krijgt eenmalig 15 minuten extra tijd */
					IF Exists (select 1 from UITGELEENDE_FIETS where FIETSID = @FIETSID AND KLANTID = @KLANTID AND EXTRA_TIJD = 0 )
						BEGIN
						UPDATE UITGELEENDE_FIETS 
						SET EXTRA_TIJD = 1
						WHERE FIETSID = @FIETSID
						AND KLANTID = @KLANTID AND EXTRA_TIJD = 0
						COMMIT TRAN
						PRINT'Het fietsstation is vol u krijgt 15 minuten extra tijd';
						RETURN;
						END
				END
/*		 Klant moet een abonnement hebben		*/
		IF EXISTS(SELECT 1 FROM KLANTHEEFTABONNEMENT where KLANTID = @KLANTID)
			BEGIN
			DECLARE @ABONNEMENTTYPE VARCHAR(50)
			DECLARE @LEENTIJD int = 0
			DECLARE @BEGINTIJD DATETIME
			DECLARE @EINDTIJD DATETIME
			DECLARE @EXTRATIJD int = 0
			DECLARE @PRIJS numeric(5,2) = 0
			DECLARE @MESSAGE VARCHAR(MAX) = ''
			SELECT @EINDTIJD = GETDATE(), @BEGINTIJD = start_tijd_lening FROM UITGELEENDE_FIETS WHERE KLANTID = @KLANTID AND FIETSID = @FIETSID
			SELECT @ABONNEMENTTYPE = ABONNEMENTTYPE FROM KLANTHEEFTABONNEMENT K INNER JOIN UITGELEENDE_FIETS L ON K.KLANTID = L.KLANTID WHERE L.KLANTID = @KLANTID AND L.start_tijd_lening > K.START_DATUM
			SELECT @LEENTIJD = DATEDIFF(minute,@BEGINTIJD,@EINDTIJD)
			
			IF EXISTS(SELECT 1 FROM STATION WHERE STATIONID = @EINDSTATION AND V_PLUS = 1)
				BEGIN
					SET @EXTRATIJD = 15;
				IF EXISTS(SELECT 1 FROM UITGELEENDE_FIETS WHERE KLANTID = @KLANTID AND FIETSID = @FIETSID)
					SET @EXTRATIJD = @EXTRATIJD + 15
				END 
/*==========================================================*/
/*			Prijs berekening velib Solidarity				*/
/*==========================================================*/
			IF(@ABONNEMENTTYPE = 'Velib Solidarity')
				BEGIN
				SELECT @LEENTIJD = @LEENTIJD - @EXTRATIJD - 45
				SET @MESSAGE = @MESSAGE + '- klant abonnement is Velib Solidarity' + CHAR(13);
					IF(@LEENTIJD > 0 AND @LEENTIJD <= 30)
						SET @PRIJS = 1
					IF(@LEENTIJD >= 30 AND @LEENTIJD < 60)
						SET @PRIJS = 3
					IF(@LEENTIJD >= 60)
						BEGIN
							IF(@LEENTIJD <90)	
								set @PRIJS = 7
							ELSE
								SELECT @PRIJS = (@LEENTIJD - 60) / 30 * 4 + 3
						END
				END
/*==========================================================*/
/*			Prijs berekening velib Classic					*/
/*==========================================================*/
				IF(@ABONNEMENTTYPE = 'Velib Classic')
					BEGIN
					SELECT @LEENTIJD = @LEENTIJD - @EXTRATIJD - 30
					SET @MESSAGE = @MESSAGE + '- klant abonnement is Velib classic' + CHAR(13);
						IF(@LEENTIJD > 0 AND @LEENTIJD <= 30)
							SET @PRIJS = 1
						IF(@LEENTIJD >= 30 AND @LEENTIJD < 60)
							SET @PRIJS = 3
						IF(@LEENTIJD >= 60)
							BEGIN
								IF(@LEENTIJD <90)	
									set @PRIJS = 7
								ELSE
									SELECT @PRIJS = (@LEENTIJD - 60) / 30 * 4 + 3
							END
					END
/*==========================================================*/
/*			Prijs berekening velib Passion					*/
/*==========================================================*/
				IF(@ABONNEMENTTYPE = 'Velib Passion' OR @ABONNEMENTTYPE = 'Velib Passion Young' OR @ABONNEMENTTYPE = 'Velib Passion Student' OR @ABONNEMENTTYPE = 'Velib Socio')
					BEGIN
					SELECT @LEENTIJD = @LEENTIJD - @EXTRATIJD - 45
					SET @MESSAGE = @MESSAGE + '- klant abonnement is velib passion' + CHAR(13);
						IF(@LEENTIJD > 0 AND @LEENTIJD <= 30)
							SET @PRIJS = 1
						IF(@LEENTIJD >= 30 AND @LEENTIJD < 60)
							SET @PRIJS = 3
						IF(@LEENTIJD >= 60)
							BEGIN
								IF(@LEENTIJD <90)	
									set @PRIJS = 7
								ELSE
									SELECT @PRIJS = (@LEENTIJD - 60) / 30 * 4 + 3
							END
					END
/*==========================================================*/
/*			Prijs berekening 1 Week abonoment				*/
/*==========================================================*/
				IF(@ABONNEMENTTYPE = '1-day ticket')
					BEGIN
					SELECT @LEENTIJD = @LEENTIJD - @EXTRATIJD
					SET @MESSAGE = @MESSAGE + '- klant abonnement heeft een dagkaart' + CHAR(13);
						IF(@LEENTIJD > 0 AND @LEENTIJD <= 1440)
							SET @PRIJS = 0
						IF(@LEENTIJD >= 1440 AND @LEENTIJD < 1470)
							SET @PRIJS = 1
						IF(@LEENTIJD >= 1470 AND @LEENTIJD < 1500)
							SET @PRIJS = 3
						IF(@LEENTIJD >= 1500)
							BEGIN
								IF(@LEENTIJD <1530)	
									set @PRIJS = 7
								ELSE
									SELECT @PRIJS = (@LEENTIJD - 1440) / 30 * 4 + 3
							END
					END
/*==========================================================*/
/*			Prijs berekening dagkaart						*/
/*==========================================================*/
				IF(@ABONNEMENTTYPE = '7-day ticket')
					BEGIN
					SELECT @LEENTIJD = @LEENTIJD - @EXTRATIJD
					SET @MESSAGE = @MESSAGE + '- klant heeft een week abonnoment' + CHAR(13);
						IF(@LEENTIJD > 0 AND @LEENTIJD <= 10080)
							SET @PRIJS = 0
						IF(@LEENTIJD > 10080 AND @LEENTIJD < 10110)
							SET @PRIJS = 1
						IF(@LEENTIJD >= 10110 AND @LEENTIJD < 10140)
							SET @PRIJS = 3
						IF(@LEENTIJD >= 10140)
							BEGIN
								IF(@LEENTIJD <10140)	
									SET @PRIJS = 7
								ELSE
									SELECT @PRIJS = (@LEENTIJD - 10080) / 30 * 4 + 3
							END
					END
					print @abonnementtype
/*		Fietslening wordt afgesloten met een update			*/
					IF (@ABONNEMENTTYPE is not null) AND EXISTS (SELECT 1 FROM UITGELEENDE_FIETS WHERE KLANTID = @KLANTID AND FIETSID = @FIETSID)
						BEGIN
							print'voor de insert'
							-- Insert de uitgeleende fiets in de de voltooide lening
							INSERT INTO VOLTOOIDE_LENING (KLANTID, FIETSID, START_TIJD, START_STATION, EIND_STATION, EIND_TIJD, PRIJS,EXTRA_TIJD)
							SELECT KLANTID, FIETSID, START_TIJD_LENING, START_STATION ,@EINDSTATION, @EINDTIJD,@prijs ,EXTRA_TIJD
							FROM UITGELEENDE_FIETS
							WHERE KLANTID = @KLANTID AND FIETSID = @FIETSID 
							PRINT'na de insert'
							-- Verwijder de lopende lening
							DELETE UITGELEENDE_FIETS WHERE FIETSID = @FIETSID
							-- Zet de fiets in de fietspost
							INSERT INTO FIETSPOST
							VALUES(@EINDSTATION,@FIETSID,@FIETSPOST,0)
							IF exists (SELECT 1 from KLANTHEEFTABONNEMENT where KLANTID = @KLANTID AND PREPAIDTEGOED > 0)
							BEGIN
							UPDATE KLANTHEEFTABONNEMENT
							SET PREPAIDTEGOED = PREPAIDTEGOED - @PRIJS
							WHERE KLANTID = @KLANTID AND EIND_TIJD > GETDATE()
							END
						END
				END
				ELSE
				SET @MESSAGE = @MESSAGE + '- De klant Heeft geen lopend abonnement' + CHAR(13);


/*		Check hoevaak de fiets geleent is. En of dat een check op de fiets forceert	of een reparatie		*/
			IF EXISTS(SELECT 1 FROM VOLTOOIDE_LENING WHERE KLANTID = @KLANTID AND FIETSID = @FIETSID AND PRIJS IS NOT NULL)
			BEGIN
				DECLARE @FIETSCHECK INT
				DECLARE @LAATSTEREPARATIE datetime
/*		Checken wanneer de laatste check is gedaan		*/
				IF EXISTS(SELECT 1 FROM ONGROUNDCONTROLE WHERE FIETSID = @FIETSCHECK)
					SELECT @LAATSTEREPARATIE = MAX(DATUM) FROM ONGROUNDCONTROLE WHERE FIETSID = @FIETSID
/*		Checken wanneer de laatste reparatie is geweest		*/
				IF EXISTS(SELECT 1 FROM REPARATIE WHERE FIETSID = @FIETSCHECK)
					BEGIN
					SELECT @LAATSTEREPARATIE = MAX(REPARATIE_DATUM) FROM REPARATIE WHERE FIETSID = @FIETSID
					END
				IF NOT EXISTS(SELECT 1 FROM ONGROUNDCONTROLE WHERE FIETSID = @FIETSCHECK) OR NOT EXISTS (SELECT 1 FROM REPARATIE WHERE FIETSID = @FIETSCHECK)				
				SELECT @FIETSCHECK = COUNT(L.FIETSID) from VOLTOOIDE_LENING L WHERE L.FIETSID = @FIETSID
				ELSE
				SELECT @FIETSCHECK = COUNT(L.FIETSID) from VOLTOOIDE_LENING L WHERE L.FIETSID = @FIETSID AND L.START_TIJD >= @LAATSTEREPARATIE
/*		Fiets is 30 x geleent vanaf	de laaste check				*/
				IF(@FIETSCHECK > 30)
					BEGIN
						UPDATE FIETSPOST
						SET MOETGECHECKTWORDEN = 1
						WHERE FIETSID = @FIETSID
					END
					ELSE
					SET @MESSAGE = @MESSAGE + '- De fiets hoeft niet gecontroleerd te worden';
			END
		PRINT @MESSAGE

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

