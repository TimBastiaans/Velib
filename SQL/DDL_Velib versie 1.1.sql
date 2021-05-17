USE master
IF EXISTS(select * from sys.databases where name='Velib')
DROP DATABASE Velib
GO
CREATE DATABASE Velib
GO
USE Velib
 
if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('BESTELLING') and o.name = 'FK_BESTELLI_LEVERANCI_LEVERANC')
alter table BESTELLING
   drop constraint FK_BESTELLI_LEVERANCI_LEVERANC
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('BESTELLING') and o.name = 'FK_BESTELLI_ONDERDEEL_FIETSOND')
alter table BESTELLING
   drop constraint FK_BESTELLI_ONDERDEEL_FIETSOND
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('BESTELLING') and o.name = 'FK_BESTELLI_WORKSHOP__WORKSHOP')
alter table BESTELLING
   drop constraint FK_BESTELLI_WORKSHOP__WORKSHOP
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('EVENT_VOOR_STATION') and o.name = 'FK_EVENT_VO_EVENT_IN__SPECIAAL')
alter table EVENT_VOOR_STATION
   drop constraint FK_EVENT_VO_EVENT_IN__SPECIAAL
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('EVENT_VOOR_STATION') and o.name = 'FK_EVENT_VO_STATION_I_STATION')
alter table EVENT_VOOR_STATION
   drop constraint FK_EVENT_VO_STATION_I_STATION
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FIETSINSTATION') and o.name = 'FK_FIETSINS_FIETS_IN__FIETS')
alter table FIETSINSTATION
   drop constraint FK_FIETSINS_FIETS_IN__FIETS
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FIETSINSTATION') and o.name = 'FK_FIETSINS_STATION_I_STATION')
alter table FIETSINSTATION
   drop constraint FK_FIETSINS_STATION_I_STATION
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FIETSONDERDEELBIJLEVERANCIER') and o.name = 'FK_FIETSOND_FIETSONDE_FIETSONDERDEEL')
alter table FIETSONDERDEELBIJLEVERANCIER
   drop constraint FK_FIETSOND_FIETSONDE_FIETSONDERDEEL
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FIETSONDERDEELBIJLEVERANCIER') and o.name = 'FK_FIETSOND_RELATIONS_LEVERANC')
alter table FIETSONDERDEELBIJLEVERANCIER
   drop constraint FK_FIETSOND_RELATIONS_LEVERANC
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FIETSONDERDEELINWORKSHOP') and o.name = 'FK_FIETSOND_FIETSONDE_FIETSOND')
alter table FIETSONDERDEELINWORKSHOP
   drop constraint FK_FIETSOND_FIETSONDE_FIETSOND
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FIETSONDERDEELINWORKSHOP') and o.name = 'FK_FIETSOND_WORKSHOP__WORKSHOP')
alter table FIETSONDERDEELINWORKSHOP
   drop constraint FK_FIETSOND_WORKSHOP__WORKSHOP
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('KLANTHEEFTABONNEMENT') and o.name = 'FK_KLANTHEE_KLANT_VAN_KLANT')
alter table KLANTHEEFTABONNEMENT
   drop constraint FK_KLANTHEE_KLANT_VAN_KLANT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('KLANTHEEFTABONNEMENT') and o.name = 'FK_KLANTHEE_RELATIONS_ABONNEME')
alter table KLANTHEEFTABONNEMENT
   drop constraint FK_KLANTHEE_RELATIONS_ABONNEME
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('LENING') and o.name = 'FK_LENING_FIETS_IN__FIETS')
alter table LENING
   drop constraint FK_LENING_FIETS_IN__FIETS
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('LENING') and o.name = 'FK_LENING_KLANT_IN__KLANT')
alter table LENING
   drop constraint FK_LENING_KLANT_IN__KLANT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('MONTEURDIENST') and o.name = 'FK_MONTEURD_DIENST_VA_WERKNEME')
alter table MONTEURDIENST
   drop constraint FK_MONTEURD_DIENST_VA_WERKNEME
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('MONTEURDIENST') and o.name = 'FK_MONTEURD_WORKSHOP__WORKSHOP')
alter table MONTEURDIENST
   drop constraint FK_MONTEURD_WORKSHOP__WORKSHOP
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ONGROUNDREPARATIES') and o.name = 'FK_ONGROUND_RELATIONS_WERKNEME')
alter table ONGROUNDREPARATIES
   drop constraint FK_ONGROUND_RELATIONS_WERKNEME
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ONGROUNDREPARATIES') and o.name = 'FK_ONGROUND_RELATIONS_FIETS')
alter table ONGROUNDREPARATIES
   drop constraint FK_ONGROUND_RELATIONS_FIETS
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('OUTQUEUE') and o.name = 'FK_OUTQUEUE_REPARATIE_FIETS')
alter table OUTQUEUE
   drop constraint FK_OUTQUEUE_REPARATIE_FIETS
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('OUTQUEUE') and o.name = 'FK_OUTQUEUE_WORKSHOP__WORKSHOP')
alter table OUTQUEUE
   drop constraint FK_OUTQUEUE_WORKSHOP__WORKSHOP
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('REPARATIE') and o.name = 'FK_REPARATI_FIETSONDE_FIETSOND')
alter table REPARATIE
   drop constraint FK_REPARATI_FIETSONDE_FIETSOND
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('REPARATIE') and o.name = 'FK_REPARATI_FIETS_IN__FIETS')
alter table REPARATIE
   drop constraint FK_REPARATI_FIETS_IN__FIETS
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('REPARATIE') and o.name = 'FK_REPARATI_WERKNEMER_WERKNEME')
alter table REPARATIE
   drop constraint FK_REPARATI_WERKNEMER_WERKNEME
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('REPARATIEQUEUE') and o.name = 'FK_REPARATI_FIETS_IN_FIETS')
alter table REPARATIEQUEUE
   drop constraint FK_REPARATI_FIETS_IN_FIETS
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('REPARATIEQUEUE') and o.name = 'FK_REPARATI_WORKSHOP__WORKSHOP')
alter table REPARATIEQUEUE
   drop constraint FK_REPARATI_WORKSHOP__WORKSHOP
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ROUTINGCARD') and o.name = 'FK_ROUTINGC_ONGROUNDT_ONGROUND')
alter table ROUTINGCARD
   drop constraint FK_ROUTINGC_ONGROUNDT_ONGROUND
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ROUTINGCARD') and o.name = 'FK_ROUTINGC_STATION_I_STATION')
alter table ROUTINGCARD
   drop constraint FK_ROUTINGC_STATION_I_STATION
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('WERKNEMERINONGROUNDTEAM') and o.name = 'FK_WERKNEME_ONGROUNDT_ONGROUND')
alter table WERKNEMERINONGROUNDTEAM
   drop constraint FK_WERKNEME_ONGROUNDT_ONGROUND
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('WERKNEMERINONGROUNDTEAM') and o.name = 'FK_WERKNEME_WERKNEMER_WERKNEME')
alter table WERKNEMERINONGROUNDTEAM
   drop constraint FK_WERKNEME_WERKNEMER_WERKNEME
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ABONNEMENTTYPE')
            and   type = 'U')
   drop table ABONNEMENTTYPE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('BESTELLING')
            and   name  = 'ONDERDEEL_VAN_BESTELLING_FK'
            and   indid > 0
            and   indid < 255)
   drop index BESTELLING.ONDERDEEL_VAN_BESTELLING_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('BESTELLING')
            and   name  = 'WORKSHOP_VAN_BESTELLING_FK'
            and   indid > 0
            and   indid < 255)
   drop index BESTELLING.WORKSHOP_VAN_BESTELLING_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('BESTELLING')
            and   name  = 'LEVERANCIER_VAN_BESTELLING_FK'
            and   indid > 0
            and   indid < 255)
   drop index BESTELLING.LEVERANCIER_VAN_BESTELLING_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('BESTELLING')
            and   type = 'U')
   drop table BESTELLING
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('EVENT_VOOR_STATION')
            and   name  = 'EVENT_IN_STATION_FK'
            and   indid > 0
            and   indid < 255)
   drop index EVENT_VOOR_STATION.EVENT_IN_STATION_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('EVENT_VOOR_STATION')
            and   name  = 'STATION_IN_EVENT_FK'
            and   indid > 0
            and   indid < 255)
   drop index EVENT_VOOR_STATION.STATION_IN_EVENT_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('EVENT_VOOR_STATION')
            and   type = 'U')
   drop table EVENT_VOOR_STATION
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('FIETS')
            and   name  = 'REPARATIEQUEUE_NAAR_OUTQUEUE_FK'
            and   indid > 0
            and   indid < 255)
   drop index FIETS.REPARATIEQUEUE_NAAR_OUTQUEUE_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('FIETS')
            and   type = 'U')
   drop table FIETS
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('FIETSINSTATION')
            and   name  = 'STATION_IN_FIETSINSTATION_FK'
            and   indid > 0
            and   indid < 255)
   drop index FIETSINSTATION.STATION_IN_FIETSINSTATION_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('FIETSINSTATION')
            and   name  = 'FIETS_IN_FIETSINSTATION_FK'
            and   indid > 0
            and   indid < 255)
   drop index FIETSINSTATION.FIETS_IN_FIETSINSTATION_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('FIETSINSTATION')
            and   type = 'U')
   drop table FIETSINSTATION
go

if exists (select 1
            from  sysobjects
           where  id = object_id('FIETSONDERDEEL')
            and   type = 'U')
   drop table FIETSONDERDEEL
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('FIETSONDERDEELBIJLEVERANCIER')
            and   name  = 'FIETSONDERDEEL_IN_FIETSONDERDEELBIJLEVERANCIER_FK'
            and   indid > 0
            and   indid < 255)
   drop index FIETSONDERDEELBIJLEVERANCIER.FIETSONDERDEEL_IN_FIETSONDERDEELBIJLEVERANCIER_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('FIETSONDERDEELBIJLEVERANCIER')
            and   name  = 'RELATIONSHIP_11_FK'
            and   indid > 0
            and   indid < 255)
   drop index FIETSONDERDEELBIJLEVERANCIER.RELATIONSHIP_11_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('FIETSONDERDEELBIJLEVERANCIER')
            and   type = 'U')
   drop table FIETSONDERDEELBIJLEVERANCIER
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('FIETSONDERDEELINWORKSHOP')
            and   name  = 'WORKSHOP_IN_FIETSONDERDEELINWORKSHOP_FK'
            and   indid > 0
            and   indid < 255)
   drop index FIETSONDERDEELINWORKSHOP.WORKSHOP_IN_FIETSONDERDEELINWORKSHOP_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('FIETSONDERDEELINWORKSHOP')
            and   name  = 'FIETSONDERDEEL_IN_FIETSONDERDEELINWORKSHOP_FK'
            and   indid > 0
            and   indid < 255)
   drop index FIETSONDERDEELINWORKSHOP.FIETSONDERDEEL_IN_FIETSONDERDEELINWORKSHOP_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('FIETSONDERDEELINWORKSHOP')
            and   type = 'U')
   drop table FIETSONDERDEELINWORKSHOP
go

if exists (select 1
            from  sysobjects
           where  id = object_id('KLANT')
            and   type = 'U')
   drop table KLANT
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('KLANTHEEFTABONNEMENT')
            and   name  = 'KLANT_VAN_ABONNEMENT_FK'
            and   indid > 0
            and   indid < 255)
   drop index KLANTHEEFTABONNEMENT.KLANT_VAN_ABONNEMENT_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('KLANTHEEFTABONNEMENT')
            and   name  = 'RELATIONSHIP_8_FK'
            and   indid > 0
            and   indid < 255)
   drop index KLANTHEEFTABONNEMENT.RELATIONSHIP_8_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('KLANTHEEFTABONNEMENT')
            and   type = 'U')
   drop table KLANTHEEFTABONNEMENT
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('LENING')
            and   name  = 'FIETS_IN_LENING_FK'
            and   indid > 0
            and   indid < 255)
   drop index LENING.FIETS_IN_LENING_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('LENING')
            and   name  = 'KLANT_IN_LENING_FK'
            and   indid > 0
            and   indid < 255)
   drop index LENING.KLANT_IN_LENING_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('LENING')
            and   type = 'U')
   drop table LENING
go

if exists (select 1
            from  sysobjects
           where  id = object_id('LEVERANCIER')
            and   type = 'U')
   drop table LEVERANCIER
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('MONTEURDIENST')
            and   name  = 'WORKSHOP_IN_DIENST_FK'
            and   indid > 0
            and   indid < 255)
   drop index MONTEURDIENST.WORKSHOP_IN_DIENST_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('MONTEURDIENST')
            and   name  = 'DIENST_VAN_WERKNEMER_FK'
            and   indid > 0
            and   indid < 255)
   drop index MONTEURDIENST.DIENST_VAN_WERKNEMER_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('MONTEURDIENST')
            and   type = 'U')
   drop table MONTEURDIENST
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ONGROUNDREPARATIES')
            and   name  = 'RELATIONSHIP_30_FK'
            and   indid > 0
            and   indid < 255)
   drop index ONGROUNDREPARATIES.RELATIONSHIP_30_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ONGROUNDREPARATIES')
            and   name  = 'RELATIONSHIP_29_FK'
            and   indid > 0
            and   indid < 255)
   drop index ONGROUNDREPARATIES.RELATIONSHIP_29_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ONGROUNDREPARATIES')
            and   type = 'U')
   drop table ONGROUNDREPARATIES
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ONGROUNDTEAM')
            and   type = 'U')
   drop table ONGROUNDTEAM
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('OUTQUEUE')
            and   name  = 'WORKSHOP_IN_OUTQUEUE_FK'
            and   indid > 0
            and   indid < 255)
   drop index OUTQUEUE.WORKSHOP_IN_OUTQUEUE_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('OUTQUEUE')
            and   name  = 'REPARATIEQUEUE_NAAR_OUTQUEUE2_FK'
            and   indid > 0
            and   indid < 255)
   drop index OUTQUEUE.REPARATIEQUEUE_NAAR_OUTQUEUE2_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('OUTQUEUE')
            and   type = 'U')
   drop table OUTQUEUE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('REPARATIE')
            and   name  = 'WERKNEMER_IN_REPARATIES_FK'
            and   indid > 0
            and   indid < 255)
   drop index REPARATIE.WERKNEMER_IN_REPARATIES_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('REPARATIE')
            and   name  = 'FIETSONDERDEEL_IN_REPARATIE_FK'
            and   indid > 0
            and   indid < 255)
   drop index REPARATIE.FIETSONDERDEEL_IN_REPARATIE_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('REPARATIE')
            and   name  = 'FIETS_IN_REPARATIE_FK'
            and   indid > 0
            and   indid < 255)
   drop index REPARATIE.FIETS_IN_REPARATIE_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('REPARATIE')
            and   type = 'U')
   drop table REPARATIE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('REPARATIEQUEUE')
            and   name  = 'WORKSHOP_IN_REPARATIEQUEUE_FK'
            and   indid > 0
            and   indid < 255)
   drop index REPARATIEQUEUE.WORKSHOP_IN_REPARATIEQUEUE_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('REPARATIEQUEUE')
            and   name  = 'FIETS_IN_REPARATIEQUEUE_FK'
            and   indid > 0
            and   indid < 255)
   drop index REPARATIEQUEUE.FIETS_IN_REPARATIEQUEUE_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('REPARATIEQUEUE')
            and   type = 'U')
   drop table REPARATIEQUEUE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ROUTINGCARD')
            and   name  = 'STATION_IN_ROUTINGCARD_FK'
            and   indid > 0
            and   indid < 255)
   drop index ROUTINGCARD.STATION_IN_ROUTINGCARD_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ROUTINGCARD')
            and   name  = 'ONGROUNDTEAM_IN_ROUTINGCARD_FK'
            and   indid > 0
            and   indid < 255)
   drop index ROUTINGCARD.ONGROUNDTEAM_IN_ROUTINGCARD_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ROUTINGCARD')
            and   type = 'U')
   drop table ROUTINGCARD
go

if exists (select 1
            from  sysobjects
           where  id = object_id('SPECIAAL_EVENEMENT')
            and   type = 'U')
   drop table SPECIAAL_EVENEMENT
go

if exists (select 1
            from  sysobjects
           where  id = object_id('STATION')
            and   type = 'U')
   drop table STATION
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('WERKNEMER')
            and   name  = 'DIENST_VAN_WERKNEMER2_FK'
            and   indid > 0
            and   indid < 255)
   drop index WERKNEMER.DIENST_VAN_WERKNEMER2_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('WERKNEMER')
            and   type = 'U')
   drop table WERKNEMER
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('WERKNEMERINONGROUNDTEAM')
            and   name  = 'WERKNEMER_IN_WERKNEMERINONGROUNDTEAM_FK'
            and   indid > 0
            and   indid < 255)
   drop index WERKNEMERINONGROUNDTEAM.WERKNEMER_IN_WERKNEMERINONGROUNDTEAM_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('WERKNEMERINONGROUNDTEAM')
            and   name  = 'ONGROUNDTEAM_IN_WERKNEMERINONGROUNDTEAM_FK'
            and   indid > 0
            and   indid < 255)
   drop index WERKNEMERINONGROUNDTEAM.ONGROUNDTEAM_IN_WERKNEMERINONGROUNDTEAM_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('WERKNEMERINONGROUNDTEAM')
            and   type = 'U')
   drop table WERKNEMERINONGROUNDTEAM
go

if exists (select 1
            from  sysobjects
           where  id = object_id('WORKSHOP')
            and   type = 'U')
   drop table WORKSHOP
go

if exists(select 1 from systypes where name='BESCHRIJVING')
   drop type BESCHRIJVING
go

if exists(select 1 from systypes where name='CIJFER')
   drop type CIJFER
go

if exists(select 1 from systypes where name='DATUM')
   drop type DATUM
go

if exists(select 1 from systypes where name='DATUM_EN_TIJD')
   drop type DATUM_EN_TIJD
go

if exists(select 1 from systypes where name='EMAIL')
   drop type EMAIL
go

if exists(select 1 from systypes where name='GELD')
   drop type GELD
go

if exists(select 1 from systypes where name='ID_NUMMER')
   drop type ID_NUMMER
go

if exists(select 1 from systypes where name='NAAM')
   drop type NAAM
go

if exists(select 1 from systypes where name='POSTCODE')
   drop type POSTCODE
go

if exists(select 1 from systypes where name='TELEFOON')
   drop type TELEFOON
go

if exists(select 1 from systypes where name='TEKST')
   drop type TEKST
go

if exists(select 1 from systypes where name='WEL_OF_NIET')
   drop type WEL_OF_NIET
go

/*==============================================================*/
/* Domain: BESCHRIJVING                                         */
/*==============================================================*/
create type BESCHRIJVING
   from varchar(1024)
go

/*==============================================================*/
/* Domain: CIJFER                                               */
/*==============================================================*/
create type CIJFER
   from int
go

/*==============================================================*/
/* Domain: DATUM                                                */
/*==============================================================*/
create type DATUM
   from datetime
go

/*==============================================================*/
/* Domain: DATUM_EN_TIJD                                        */
/*==============================================================*/
create type DATUM_EN_TIJD
   from datetime
go

/*==============================================================*/
/* Domain: EMAIL                                                */
/*==============================================================*/
create type EMAIL
   from varchar(50)
go

/*==============================================================*/
/* Domain: GELD                                                 */
/*==============================================================*/
create type GELD
   from money
go

/*==============================================================*/
/* Domain: ID_NUMMER                                            */
/*==============================================================*/
create type ID_NUMMER
   from int
go

/*==============================================================*/
/* Domain: NAAM                                                 */
/*==============================================================*/
create type NAAM
   from varchar(30)
go

/*==============================================================*/
/* Domain: POSTCODE                                             */
/*==============================================================*/
create type POSTCODE
   from varchar(10)
go

/*==============================================================*/
/* Domain: TELEFOON                                             */
/*==============================================================*/
create type TELEFOON
   from varchar(15)
go

/*==============================================================*/
/* Domain: TEXT                                                 */
/*==============================================================*/
create type TEKST
   from varchar(50)
go

/*==============================================================*/
/* Domain: WEL_OF_NIET                                          */
/*==============================================================*/
create type WEL_OF_NIET
   from bit
go

/*==============================================================*/
/* Table: ABONNEMENTTYPE                                        */
/*==============================================================*/
create table ABONNEMENTTYPE (
   ABONNEMENTTYPE       TEKST                not null,
   PRIJS                GELD                 not null,
   LOOPTIJD             TEKST                not null,
   LONGTERM             WEL_OF_NIET          not null,
   constraint PK_ABONNEMENTTYPE primary key nonclustered (ABONNEMENTTYPE)
)
go

/*==============================================================*/
/* Table: BESTELLING                                            */
/*==============================================================*/
create table BESTELLING (
   ORDERID              ID_NUMMER            not null,
   WORKSHOPID           ID_NUMMER            not null,
   ONDERDEELID          ID_NUMMER            not null,
   LEVERANCIERID	    ID_NUMMER            not null,
   DATUM                DATUM                not null,
   AANTAL               CIJFER               null,
   DATUM_AANGEKOMEN     WEL_OF_NIET          null,
   constraint PK_BESTELLING primary key nonclustered (ORDERID)
)
go

/*==============================================================*/
/* Table: TAAK                                              */
/*==============================================================*/
create table TAAK(
	TAAKID int not null,
	TAAKNAAM varchar(255),
	constraint PK_TAAK primary key (TAAKNAAM)
)
go

/*==============================================================*/
/* Index: LEVERANCIER_VAN_BESTELLING_FK                         */
/*==============================================================*/
create index LEVERANCIER_VAN_BESTELLING_FK on BESTELLING (
LEVERANCIERID ASC
)
go

/*==============================================================*/
/* Index: WORKSHOP_VAN_BESTELLING_FK                            */
/*==============================================================*/
create index WORKSHOP_VAN_BESTELLING_FK on BESTELLING (
WORKSHOPID ASC
)
go

/*==============================================================*/
/* Index: ONDERDEEL_VAN_BESTELLING_FK                           */
/*==============================================================*/
create index ONDERDEEL_VAN_BESTELLING_FK on BESTELLING (
ONDERDEELID ASC
)
go

/*==============================================================*/
/* Table: EVENT_VOOR_STATION                                    */
/*==============================================================*/
create table EVENT_VOOR_STATION (
   STATIONID            ID_NUMMER            not null,
   EVENTID              ID_NUMMER            not null,
   constraint PK_EVENT_VOOR_STATION primary key (STATIONID, EVENTID)
)
go

/*==============================================================*/
/* Index: STATION_IN_EVENT_FK                                   */
/*==============================================================*/
create index STATION_IN_EVENT_FK on EVENT_VOOR_STATION (
STATIONID ASC
)
go

/*==============================================================*/
/* Index: EVENT_IN_STATION_FK                                   */
/*==============================================================*/
create index EVENT_IN_STATION_FK on EVENT_VOOR_STATION (
EVENTID ASC
)
go

/*==============================================================*/
/* Table: FIETS                                                 */
/*==============================================================*/
create table FIETS (
   FIETSID              ID_NUMMER            not null,
   constraint PK_FIETS primary key nonclustered (FIETSID)
)
go


/*==============================================================*/
/* Table: FIETSINSTATION                                        */
/*==============================================================*/
create table FIETSINSTATION (
   FIETSID              ID_NUMMER            not null,
   STATIONID            ID_NUMMER            not null,
   FIETSPOST            CIJFER               not null,
   MOETGECHECKTWORDEN   WEL_OF_NIET          not null,
   constraint PK_FIETSINSTATION primary key (STATIONID, FIETSPOST)
)
go

/*==============================================================*/
/* Index: FIETS_IN_FIETSINSTATION_FK                            */
/*==============================================================*/
create index FIETS_IN_FIETSINSTATION_FK on FIETSINSTATION (
FIETSID ASC
)
go

/*==============================================================*/
/* Index: STATION_IN_FIETSINSTATION_FK                          */
/*==============================================================*/
create index STATION_IN_FIETSINSTATION_FK on FIETSINSTATION (
STATIONID ASC
)
go

/*==============================================================*/
/* Table: FIETSONDERDEEL                                        */
/*==============================================================*/
create table FIETSONDERDEEL (
   ONDERDEELID          ID_NUMMER            not null,
   NAAM                 NAAM                 not null,
   BESCHRIJVING         BESCHRIJVING         null,
   MAXIMUM_AANTAL       CIJFER               not null,
   MINIMAAL_AANTAL      CIJFER               not null,
   constraint PK_FIETSONDERDEEL primary key nonclustered (ONDERDEELID)
)
go

/*==============================================================*/
/* Table: FIETSONDERDEELBIJLEVERANCIER                          */
/*==============================================================*/
create table FIETSONDERDEELBIJLEVERANCIER (
   LEVERANCIERID        ID_NUMMER            not null,
   ONDERDEELID          ID_NUMMER            not null,
   PRIJS                GELD                 not null,
   constraint PK_FIETSONDERDEELBIJLEVERANCIE primary key (LEVERANCIERID, ONDERDEELID)
)
go

/*==============================================================*/
/* Index: RELATIONSHIP_11_FK                                    */
/*==============================================================*/
create index RELATIONSHIP_11_FK on FIETSONDERDEELBIJLEVERANCIER (
LEVERANCIERID ASC
)
go

/*==============================================================*/
/* Index: FIETSONDERDEEL_IN_FIETSONDERDEELBIJLEVERANCIER_FK     */
/*==============================================================*/
create index FIETSONDERDEEL_IN_FIETSONDERDEELBIJLEVERANCIER_FK on FIETSONDERDEELBIJLEVERANCIER (
ONDERDEELID ASC
)
go

/*==============================================================*/
/* Table: FIETSONDERDEELINWORKSHOP                              */
/*==============================================================*/
create table FIETSONDERDEELINWORKSHOP (
   ONDERDEELID          ID_NUMMER            not null,
   WORKSHOPID           ID_NUMMER            not null,
   AANTAL               CIJFER               not null,
   constraint PK_FIETSONDERDEELINWORKSHOP primary key (ONDERDEELID, WORKSHOPID)
)
go



/*==============================================================*/
/* Index: FIETSONDERDEEL_IN_FIETSONDERDEELINWORKSHOP_FK         */
/*==============================================================*/
create index FIETSONDERDEEL_IN_FIETSONDERDEELINWORKSHOP_FK on FIETSONDERDEELINWORKSHOP (
ONDERDEELID ASC
)
go

/*==============================================================*/
/* Index: WORKSHOP_IN_FIETSONDERDEELINWORKSHOP_FK               */
/*==============================================================*/
create index WORKSHOP_IN_FIETSONDERDEELINWORKSHOP_FK on FIETSONDERDEELINWORKSHOP (
WORKSHOPID ASC
)
go

/*==============================================================*/
/* Table: KLANT                                                 */
/*==============================================================*/
create table KLANT (
   KLANTNUMMER          ID_NUMMER            not null,
   NAAM                 NAAM                 not null,
   ACHTERNAAM           NAAM                 not null,
   ADRES                TEKST                not null,
   POSTCODE             POSTCODE             not null,
   IS_STUDENT			WEL_OF_NIET			 not null,
   GEBOORTEDATUM		DATE				not null,
   constraint PK_KLANT primary key nonclustered (KLANTNUMMER)
)
go

/*==============================================================*/
/* Table: ADMIN                                                 */
/*==============================================================*/
create table ADMINTABEL (
	WERKNEMERID		ID_NUMMER		not null,
	constraint PK_ADMIN	primary key (WERKNEMERID)
)
go

/*==============================================================*/
/* Table: KLANTHEEFTABONNEMENT                                  */
/*==============================================================*/
create table KLANTHEEFTABONNEMENT (
   ABONNEMENTTYPE       TEKST                 not null,
   KLANTNUMMER          ID_NUMMER            not null,
   START_DATUM          DATUM                not null,
   EIND_TIJD            DATUM                not null,
   CREDITKAARTNUMMER    CIJFER               null,
   PREPAIDTEGOED        GELD                 null,
   AUTOMATISCH_VERLENGT WEL_OF_NIET          not null,
   constraint PK_KLANTHEEFTABONNEMENT primary key nonclustered (ABONNEMENTTYPE, KLANTNUMMER, START_DATUM)
)
go

/*==============================================================*/
/* Index: RELATIONSHIP_8_FK                                     */
/*==============================================================*/
create index RELATIONSHIP_8_FK on KLANTHEEFTABONNEMENT (
ABONNEMENTTYPE ASC
)
go

/*==============================================================*/
/* Index: KLANT_VAN_ABONNEMENT_FK                               */
/*==============================================================*/
create index KLANT_VAN_ABONNEMENT_FK on KLANTHEEFTABONNEMENT (
KLANTNUMMER ASC
)
go

/*==============================================================*/
/* Table: LENING                                                */
/*==============================================================*/
create table LENING (
   FIETSID              ID_NUMMER            not null,
   "FROM"               DATUM_EN_TIJD        not null,
   KLANTNUMMER          ID_NUMMER            not null,
   "TO"                 DATUM_EN_TIJD        null,
   START_STATION        CIJFER               not null,
   EIND_STATION         CIJFER               null,
   PRIJS                GELD                 null,
   EXTRA_TIJD           bit                  not null,
   constraint PK_LENING primary key nonclustered (FIETSID, "FROM")
)
go

/*==============================================================*/
/* Index: KLANT_IN_LENING_FK                                    */
/*==============================================================*/
create index KLANT_IN_LENING_FK on LENING (
KLANTNUMMER ASC
)
go

/*==============================================================*/
/* Index: FIETS_IN_LENING_FK                                    */
/*==============================================================*/
create index FIETS_IN_LENING_FK on LENING (
FIETSID ASC
)
go

/*==============================================================*/
/* Table: LEVERANCIER                                           */
/*==============================================================*/
create table LEVERANCIER (
   LEVERANCIERID        ID_NUMMER            not null,
   NAAM                 NAAM                 not null,
   TELEFOONNUMMER       TELEFOON             null,
   E_MAILADRES          EMAIL                null,
   constraint PK_LEVERANCIER primary key nonclustered (LEVERANCIERID)
)
go

/*==============================================================*/
/* Table: MONTEURDIENST                                         */
/*==============================================================*/
create table MONTEURDIENST (
   WERKNEMERID          ID_NUMMER            not null,
   WORKSHOPID           ID_NUMMER            not null,
   START_DATUM	         DATUM                not null,
   EIND_TIJD            DATUM                not null,
   constraint PK_MONTEURDIENST primary key nonclustered (WERKNEMERID, WORKSHOPID, START_DATUM)
)
go

/*==============================================================*/
/* Index: DIENST_VAN_WERKNEMER_FK                               */
/*==============================================================*/
create index DIENST_VAN_WERKNEMER_FK on MONTEURDIENST (
WERKNEMERID ASC
)
go

/*==============================================================*/
/* Index: WORKSHOP_IN_DIENST_FK                                 */
/*==============================================================*/
create index WORKSHOP_IN_DIENST_FK on MONTEURDIENST (
WORKSHOPID ASC
)
go

/*==============================================================*/
/* Table: ONGROUNDREPARATIES                                    */
/*==============================================================*/
create table ONGROUNDREPARATIES (
   WERKNEMERID          ID_NUMMER            not null,
   FIETSID              ID_NUMMER            not null,
   DATUM				date				 not null,
   BESCHRIJVING         varchar(max)         null,
   constraint PK_ONGROUNDREPARATIES primary key (WERKNEMERID, FIETSID, DATUM)
)
go

/*==============================================================*/
/* Index: RELATIONSHIP_29_FK                                    */
/*==============================================================*/
create index RELATIONSHIP_29_FK on ONGROUNDREPARATIES (
WERKNEMERID ASC
)
go

/*==============================================================*/
/* Index: RELATIONSHIP_30_FK                                    */
/*==============================================================*/
create index RELATIONSHIP_30_FK on ONGROUNDREPARATIES (
FIETSID ASC
)
go

/*==============================================================*/
/* Table: ONGROUNDTEAM                                          */
/*==============================================================*/
create table ONGROUNDTEAM (
   TEAMID               CIJFER               not null,
   constraint PK_ONGROUNDTEAM primary key nonclustered (TEAMID)
)
go

/*==============================================================*/
/* Table: OUTQUEUE                                              */
/*==============================================================*/
create table OUTQUEUE (
   FIETSID              ID_NUMMER            not null,
   WORKSHOPID           ID_NUMMER            not null,
   constraint PK_OUTQUEUE primary key (FIETSID, WORKSHOPID)
)
go

/*==============================================================*/
/* Index: REPARATIEQUEUE_NAAR_OUTQUEUE2_FK                      */
/*==============================================================*/
create index REPARATIEQUEUE_NAAR_OUTQUEUE2_FK on OUTQUEUE (
FIETSID ASC
)
go

/*==============================================================*/
/* Index: WORKSHOP_IN_OUTQUEUE_FK                               */
/*==============================================================*/
create index WORKSHOP_IN_OUTQUEUE_FK on OUTQUEUE (
WORKSHOPID ASC
)
go

/*==============================================================*/
/* Table: REPARATIE                                             */
/*==============================================================*/
create table REPARATIE (
   FIETSID              ID_NUMMER            not null,
   ONDERDEELID          ID_NUMMER            not null,
   REPARATIE_DATUM      DATUM_EN_TIJD        not null,
   WERKNEMERID          ID_NUMMER            not null,
   VERVANGEN            WEL_OF_NIET          not null,
   constraint PK_REPARATIE primary key nonclustered (FIETSID, ONDERDEELID, REPARATIE_DATUM)
)
go

/*==============================================================*/
/* Index: FIETS_IN_REPARATIE_FK                                 */
/*==============================================================*/
create index FIETS_IN_REPARATIE_FK on REPARATIE (
FIETSID ASC
)
go

/*==============================================================*/
/* Index: FIETSONDERDEEL_IN_REPARATIE_FK                        */
/*==============================================================*/
create index FIETSONDERDEEL_IN_REPARATIE_FK on REPARATIE (
ONDERDEELID ASC
)
go

/*==============================================================*/
/* Index: WERKNEMER_IN_REPARATIES_FK                            */
/*==============================================================*/
create index WERKNEMER_IN_REPARATIES_FK on REPARATIE (
WERKNEMERID ASC
)
go

/*==============================================================*/
/* Table: REPARATIEQUEUE                                        */
/*==============================================================*/
create table REPARATIEQUEUE (
   FIETSID              ID_NUMMER            not null,
   WORKSHOPID           ID_NUMMER            not null,
   VOLGNUMMER           CIJFER               not null,
   BESCHRIJVING         BESCHRIJVING         null,
   constraint PK_REPARATIEQUEUE primary key nonclustered (WORKSHOPID, VOLGNUMMER)
)
go

/*==============================================================*/
/* Index: FIETS_IN_REPARATIEQUEUE_FK                            */
/*==============================================================*/
create index FIETS_IN_REPARATIEQUEUE_FK on REPARATIEQUEUE (
FIETSID ASC
)
go

/*==============================================================*/
/* Index: WORKSHOP_IN_REPARATIEQUEUE_FK                         */
/*==============================================================*/
create index WORKSHOP_IN_REPARATIEQUEUE_FK on REPARATIEQUEUE (
WORKSHOPID ASC
)
go

/*==============================================================*/
/* Table: ROUTINGCARD                                           */
/*==============================================================*/
create table ROUTINGCARD (
   TEAMID               CIJFER               not null,
   STATIONID            ID_NUMMER            not null,
   RITDATUM             DATUM_EN_TIJD        not null,
   constraint PK_ROUTINGCARD primary key nonclustered (TEAMID, STATIONID, RITDATUM)
)
go

/*==============================================================*/
/* Index: ONGROUNDTEAM_IN_ROUTINGCARD_FK                        */
/*==============================================================*/
create index ONGROUNDTEAM_IN_ROUTINGCARD_FK on ROUTINGCARD (
TEAMID ASC
)
go

/*==============================================================*/
/* Index: STATION_IN_ROUTINGCARD_FK                             */
/*==============================================================*/
create index STATION_IN_ROUTINGCARD_FK on ROUTINGCARD (
STATIONID ASC
)
go

/*==============================================================*/
/* Table: SPECIAAL_EVENEMENT                                    */
/*==============================================================*/
create table SPECIAAL_EVENEMENT (
   EVENTID              ID_NUMMER            not null,
   NAAM                 NAAM                 not null,
   DATUM                DATUM                not null,
   BESCHRIJVING         BESCHRIJVING         null,
   constraint PK_SPECIAAL_EVENEMENT primary key nonclustered (EVENTID)
)
go

/*==============================================================*/
/* Table: STATION                                               */
/*==============================================================*/
create table STATION (
   STATIONID            ID_NUMMER            not null,
   STATIONNUMMER        ID_NUMMER            not null,
   ARRONDISSEMENT       CIJFER               not null,
   ADRES                TEKST                 not null,
   CAPACITEIT           CIJFER               not null,
   V_PLUS                WEL_OF_NIET          not null,
   constraint PK_STATION primary key nonclustered (STATIONID)
)
go

/*==============================================================*/
/* Table: WERKNEMER                                             */
/*==============================================================*/
create table WERKNEMER (
   WERKNEMERID          ID_NUMMER            not null,
   VOORNAAM             NAAM                 not null,
   ACHTERNAAM           NAAM                 not null,
   ADRES                TEKST                 not null,
   POSTCODE             POSTCODE             not null,
   WACHTWOORD           varchar(255)         not null,
   constraint PK_WERKNEMER primary key nonclustered (WERKNEMERID)
)
go




/*==============================================================*/
/* Table: WERKNEMERINONGROUNDTEAM                               */
/*==============================================================*/
create table WERKNEMERINONGROUNDTEAM (
   TEAMID               CIJFER               not null,
   WERKNEMERID          ID_NUMMER            not null,
   DATUM				datetime			 not null,
   constraint PK_WERKNEMERINONGROUNDTEAM primary key nonclustered (TEAMID, WERKNEMERID, DATUM)
)
go

/*==============================================================*/
/* Index: ONGROUNDTEAM_IN_WERKNEMERINONGROUNDTEAM_FK            */
/*==============================================================*/
create index ONGROUNDTEAM_IN_WERKNEMERINONGROUNDTEAM_FK on WERKNEMERINONGROUNDTEAM (
TEAMID ASC
)
go

/*==============================================================*/
/* Index: WERKNEMER_IN_WERKNEMERINONGROUNDTEAM_FK               */
/*==============================================================*/
create index WERKNEMER_IN_WERKNEMERINONGROUNDTEAM_FK on WERKNEMERINONGROUNDTEAM (
WERKNEMERID ASC
)
go

/*==============================================================*/
/* Table: WORKSHOP                                              */
/*==============================================================*/
create table WORKSHOP (
   WORKSHOPID           ID_NUMMER            not null,
   ADRES                TEKST                not null,
   constraint PK_WORKSHOP primary key nonclustered (WORKSHOPID)
)
go

alter table BESTELLING
   add constraint FK_FIETSONDERDEELBIJLEVERANCIER_IN_BESTELLING foreign key (LEVERANCIERID,ONDERDEELID)	
   references FIETSONDERDEELBIJLEVERANCIER(LEVERANCIERID,ONDERDEELID)
go

alter table ADMINTABEL
	add constraint FK_ADMINTABEL foreign key (WERKNEMERID) 
	references WERKNEMER(WERKNEMERID)

alter table BESTELLING
   add constraint FK_BESTELLI_WORKSHOP__WORKSHOP foreign key (WORKSHOPID)
      references WORKSHOP (WORKSHOPID)
go

alter table EVENT_VOOR_STATION
   add constraint FK_EVENT_VO_EVENT_IN__SPECIAAL foreign key (EVENTID)
      references SPECIAAL_EVENEMENT (EVENTID)
go

alter table EVENT_VOOR_STATION
   add constraint FK_EVENT_VO_STATION_I_STATION foreign key (STATIONID)
      references STATION (STATIONID)
go

alter table FIETSINSTATION
   add constraint FK_FIETSINS_FIETS_IN__FIETS foreign key (FIETSID)
      references FIETS (FIETSID)
go

alter table FIETSINSTATION
   add constraint FK_FIETSINS_STATION_I_STATION foreign key (STATIONID)
      references STATION (STATIONID)
go

alter table FIETSONDERDEELBIJLEVERANCIER
   add constraint FK_FIETSOND_FIETSONDE_FIETSONDERDEEL foreign key (ONDERDEELID)
      references FIETSONDERDEEL (ONDERDEELID)
go

alter table FIETSONDERDEELBIJLEVERANCIER
   add constraint FK_FIETSOND_RELATIONS_LEVERANC foreign key (LEVERANCIERID)
      references LEVERANCIER (LEVERANCIERID)
go

alter table FIETSONDERDEELINWORKSHOP
   add constraint FK_FIETSOND_FIETSONDE_FIETSOND foreign key (ONDERDEELID)
      references FIETSONDERDEEL (ONDERDEELID)
go

alter table FIETSONDERDEELINWORKSHOP
   add constraint FK_FIETSOND_WORKSHOP__WORKSHOP foreign key (WORKSHOPID)
      references WORKSHOP (WORKSHOPID)
go

alter table KLANTHEEFTABONNEMENT
   add constraint FK_KLANTHEE_KLANT_VAN_KLANT foreign key (KLANTNUMMER)
      references KLANT (KLANTNUMMER)
go

alter table KLANTHEEFTABONNEMENT
   add constraint FK_KLANTHEE_RELATIONS_ABONNEME foreign key (ABONNEMENTTYPE)
      references ABONNEMENTTYPE (ABONNEMENTTYPE)
go

alter table LENING
   add constraint FK_LENING_FIETS_IN__FIETS foreign key (FIETSID)
      references FIETS (FIETSID)
go

alter table LENING
   add constraint FK_LENING_KLANT_IN__KLANT foreign key (KLANTNUMMER)
      references KLANT (KLANTNUMMER)
go

alter table MONTEURDIENST
   add constraint FK_MONTEURD_DIENST_VA_WERKNEME foreign key (WERKNEMERID)
      references WERKNEMER (WERKNEMERID)
go

alter table MONTEURDIENST
   add constraint FK_MONTEURD_WORKSHOP__WORKSHOP foreign key (WORKSHOPID)
      references WORKSHOP (WORKSHOPID)
go

alter table ONGROUNDREPARATIES
   add constraint FK_ONGROUND_RELATIONS_WERKNEME foreign key (WERKNEMERID)
      references WERKNEMER (WERKNEMERID)
go

alter table ONGROUNDREPARATIES
   add constraint FK_ONGROUND_RELATIONS_FIETS foreign key (FIETSID)
      references FIETS (FIETSID)
go

alter table OUTQUEUE
   add constraint FK_OUTQUEUE_REPARATIE_FIETS foreign key (FIETSID)
      references FIETS (FIETSID)
go

alter table OUTQUEUE
   add constraint FK_OUTQUEUE_WORKSHOP__WORKSHOP foreign key (WORKSHOPID)
      references WORKSHOP (WORKSHOPID)
go

alter table REPARATIE
   add constraint FK_REPARATI_FIETSONDE_FIETSOND foreign key (ONDERDEELID)
      references FIETSONDERDEEL (ONDERDEELID)
go

alter table REPARATIE
   add constraint FK_REPARATI_FIETS_IN__FIETS foreign key (FIETSID)
      references FIETS (FIETSID)
go

alter table REPARATIE
   add constraint FK_REPARATI_WERKNEMER_WERKNEME foreign key (WERKNEMERID)
      references WERKNEMER (WERKNEMERID)
go

alter table REPARATIEQUEUE
   add constraint FK_REPARATI_FIETS_IN_FIETS foreign key (FIETSID)
      references FIETS (FIETSID)
go

alter table REPARATIEQUEUE
   add constraint FK_REPARATI_WORKSHOP__WORKSHOP foreign key (WORKSHOPID)
      references WORKSHOP (WORKSHOPID)
go

alter table ROUTINGCARD
   add constraint FK_ROUTINGC_ONGROUNDT_ONGROUND foreign key (TEAMID)
      references ONGROUNDTEAM (TEAMID)
go

alter table ROUTINGCARD
   add constraint FK_ROUTINGC_STATION_I_STATION foreign key (STATIONID)
      references STATION (STATIONID)
go

alter table WERKNEMERINONGROUNDTEAM
   add constraint FK_WERKNEME_ONGROUNDT_ONGROUND foreign key (TEAMID)
      references ONGROUNDTEAM (TEAMID)
go

alter table WERKNEMERINONGROUNDTEAM
   add constraint FK_WERKNEME_WERKNEMER_WERKNEME foreign key (WERKNEMERID)
      references WERKNEMER (WERKNEMERID)
go

alter table LENING
   add constraint FK_LENING_START_STATION foreign key (START_STATION)
      references STATION (STATIONID)
go

alter table LENING
   add constraint FK_LENING_EIND_STATION foreign key (EIND_STATION)
      references STATION (STATIONID)
go
