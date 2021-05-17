/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     1/9/2018 1:02:04 PM                          */
/*==============================================================*/

USE master
IF EXISTS(select * from sys.databases where name='Velib')
DROP DATABASE Velib
GO
CREATE DATABASE Velib
GO
USE Velib

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ADMIN') and o.name = 'FK_ADMIN_REFERENCE_WERKNEME')
alter table ADMIN
   drop constraint FK_ADMIN_REFERENCE_WERKNEME
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('BESTELLING') and o.name = 'FK_BESTELLI_BESTELING_FIETSOND')
alter table BESTELLING
   drop constraint FK_BESTELLI_BESTELING_FIETSOND
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('BESTELLING') and o.name = 'FK_BESTELLI_WORKSHOP__WORKSHOP')
alter table BESTELLING
   drop constraint FK_BESTELLI_WORKSHOP__WORKSHOP
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FIETS') and o.name = 'FK_FIETS_FIETS_IN__WORKSHOP')
alter table FIETS
   drop constraint FK_FIETS_FIETS_IN__WORKSHOP
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FIETSONDERDEELBIJLEVERANCIER') and o.name = 'FK_FIETSOND_FIETSONDE_FIETSOND')
alter table FIETSONDERDEELBIJLEVERANCIER
   drop constraint FK_FIETSOND_FIETSONDE_FIETSOND
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FIETSONDERDEELBIJLEVERANCIER') and o.name = 'FK_FIETSOND_RELATIONS_LEVERANC')
alter table FIETSONDERDEELBIJLEVERANCIER
   drop constraint FK_FIETSOND_RELATIONS_LEVERANC
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FIETSONDERDEELINWORKSHOP') and o.name = 'FK_FIETSOND_FIETS1OND_FIETSOND')
alter table FIETSONDERDEELINWORKSHOP
   drop constraint FK_FIETSOND_FIETS1OND_FIETSOND
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FIETSONDERDEELINWORKSHOP') and o.name = 'FK_FIETSOND_WORKSHOP__WORKSHOP')
alter table FIETSONDERDEELINWORKSHOP
   drop constraint FK_FIETSOND_WORKSHOP__WORKSHOP
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FIETSPOST') and o.name = 'FK_FIETSPOS_FIETS_IN__FIETS')
alter table FIETSPOST
   drop constraint FK_FIETSPOS_FIETS_IN__FIETS
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FIETSPOST') and o.name = 'FK_FIETSPOS_STATION_I_STATION')
alter table FIETSPOST
   drop constraint FK_FIETSPOS_STATION_I_STATION
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
   where r.fkeyid = object_id('ONGROUNDCONTROLE') and o.name = 'FK_ONGROUND_FIETS_IN__FIETS')
alter table ONGROUNDCONTROLE
   drop constraint FK_ONGROUND_FIETS_IN__FIETS
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ONGROUNDCONTROLE') and o.name = 'FK_ONGROUND_ONGROUNDR_WERKNEME')
alter table ONGROUNDCONTROLE
   drop constraint FK_ONGROUND_ONGROUNDR_WERKNEME
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
   where r.fkeyid = object_id('REPARATIEQUEUE') and o.name = 'FK_REPARATI_FIETS1_IN_FIETS')
alter table REPARATIEQUEUE
   drop constraint FK_REPARATI_FIETS1_IN_FIETS
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
   where r.fkeyid = object_id('STATION_IN_SPECIAAL_EVENEMENT') and o.name = 'FK_STATION__STATION_I_STATION')
alter table STATION_IN_SPECIAAL_EVENEMENT
   drop constraint FK_STATION__STATION_I_STATION
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('STATION_IN_SPECIAAL_EVENEMENT') and o.name = 'FK_STATION__STATION_I_SPECIAAL')
alter table STATION_IN_SPECIAAL_EVENEMENT
   drop constraint FK_STATION__STATION_I_SPECIAAL
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('UITGELEENDE_FIETS') and o.name = 'FK_UITGELEE_RELATIONS_FIETS')
alter table UITGELEENDE_FIETS
   drop constraint FK_UITGELEE_RELATIONS_FIETS
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('UITGELEENDE_FIETS') and o.name = 'FK_UITGELEE_RELATIONS_KLANT')
alter table UITGELEENDE_FIETS
   drop constraint FK_UITGELEE_RELATIONS_KLANT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('UITGELEENDE_FIETS') and o.name = 'FK_UITGELEE_STARTSTAT_STATION')
alter table UITGELEENDE_FIETS
   drop constraint FK_UITGELEE_STARTSTAT_STATION
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('VOLTOOIDE_LENING') and o.name = 'FK_VOLTOOID_BEGINSTAT_STATION')
alter table VOLTOOIDE_LENING
   drop constraint FK_VOLTOOID_BEGINSTAT_STATION
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('VOLTOOIDE_LENING') and o.name = 'FK_VOLTOOID_EINDSTATI_STATION')
alter table VOLTOOIDE_LENING
   drop constraint FK_VOLTOOID_EINDSTATI_STATION
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('VOLTOOIDE_LENING') and o.name = 'FK_VOLTOOID_FIETS_IN__FIETS')
alter table VOLTOOIDE_LENING
   drop constraint FK_VOLTOOID_FIETS_IN__FIETS
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('VOLTOOIDE_LENING') and o.name = 'FK_VOLTOOID_KLANT_IN__KLANT')
alter table VOLTOOIDE_LENING
   drop constraint FK_VOLTOOID_KLANT_IN__KLANT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('WERKNEMER') and o.name = 'FK_WERKNEME_WERKNEMER_ONGROUND')
alter table WERKNEMER
   drop constraint FK_WERKNEME_WERKNEMER_ONGROUND
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ABONNEMENTTYPE')
            and   type = 'U')
   drop table ABONNEMENTTYPE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ADMIN')
            and   type = 'U')
   drop table ADMIN
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('BESTELLING')
            and   name  = 'BESTELINGEN_VAN_FIETSONDERDEELBIJLEVERANCIER_FK'
            and   indid > 0
            and   indid < 255)
   drop index BESTELLING.BESTELINGEN_VAN_FIETSONDERDEELBIJLEVERANCIER_FK
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
            from  sysobjects
           where  id = object_id('BESTELLING')
            and   type = 'U')
   drop table BESTELLING
go

if exists (select 1
            from  sysobjects
           where  id = object_id('BESTELLING_HISTORY')
            and   type = 'U')
   drop table BESTELLING_HISTORY
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('FIETS')
            and   name  = 'FIETS_IN_WORKSHOP_FK'
            and   indid > 0
            and   indid < 255)
   drop index FIETS.FIETS_IN_WORKSHOP_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('FIETS')
            and   type = 'U')
   drop table FIETS
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
            from  sysindexes
           where  id    = object_id('FIETSPOST')
            and   name  = 'STATION_IN_FIETSINSTATION_FK'
            and   indid > 0
            and   indid < 255)
   drop index FIETSPOST.STATION_IN_FIETSINSTATION_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('FIETSPOST')
            and   name  = 'FIETS_IN_FIETSINSTATION_FK'
            and   indid > 0
            and   indid < 255)
   drop index FIETSPOST.FIETS_IN_FIETSINSTATION_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('FIETSPOST')
            and   type = 'U')
   drop table FIETSPOST
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
           where  id    = object_id('ONGROUNDCONTROLE')
            and   name  = 'FIETS_IN_ONGROUNDREPARATIES_FK'
            and   indid > 0
            and   indid < 255)
   drop index ONGROUNDCONTROLE.FIETS_IN_ONGROUNDREPARATIES_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ONGROUNDCONTROLE')
            and   name  = 'ONGROUNDREPARATIES_DOOR_WERKNEMER_FK'
            and   indid > 0
            and   indid < 255)
   drop index ONGROUNDCONTROLE.ONGROUNDREPARATIES_DOOR_WERKNEMER_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ONGROUNDCONTROLE')
            and   type = 'U')
   drop table ONGROUNDCONTROLE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ONGROUNDTEAM')
            and   type = 'U')
   drop table ONGROUNDTEAM
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
           where  id    = object_id('STATION_IN_SPECIAAL_EVENEMENT')
            and   name  = 'STATION_IN_SPECIAAL_EVENEMENT2_FK'
            and   indid > 0
            and   indid < 255)
   drop index STATION_IN_SPECIAAL_EVENEMENT.STATION_IN_SPECIAAL_EVENEMENT2_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('STATION_IN_SPECIAAL_EVENEMENT')
            and   name  = 'STATION_IN_SPECIAAL_EVENEMENT_FK'
            and   indid > 0
            and   indid < 255)
   drop index STATION_IN_SPECIAAL_EVENEMENT.STATION_IN_SPECIAAL_EVENEMENT_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('STATION_IN_SPECIAAL_EVENEMENT')
            and   type = 'U')
   drop table STATION_IN_SPECIAAL_EVENEMENT
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TAAK')
            and   type = 'U')
   drop table TAAK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('UITGELEENDE_FIETS')
            and   name  = 'STARTSTATION_FK'
            and   indid > 0
            and   indid < 255)
   drop index UITGELEENDE_FIETS.STARTSTATION_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('UITGELEENDE_FIETS')
            and   name  = 'RELATIONSHIP_30_FK'
            and   indid > 0
            and   indid < 255)
   drop index UITGELEENDE_FIETS.RELATIONSHIP_30_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('UITGELEENDE_FIETS')
            and   name  = 'RELATIONSHIP_29_FK'
            and   indid > 0
            and   indid < 255)
   drop index UITGELEENDE_FIETS.RELATIONSHIP_29_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('UITGELEENDE_FIETS')
            and   type = 'U')
   drop table UITGELEENDE_FIETS
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('VOLTOOIDE_LENING')
            and   name  = 'EINDSTATION_LENING_FK'
            and   indid > 0
            and   indid < 255)
   drop index VOLTOOIDE_LENING.EINDSTATION_LENING_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('VOLTOOIDE_LENING')
            and   name  = 'BEGINSTATION_LENING_FK'
            and   indid > 0
            and   indid < 255)
   drop index VOLTOOIDE_LENING.BEGINSTATION_LENING_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('VOLTOOIDE_LENING')
            and   name  = 'FIETS_IN_LENING_FK'
            and   indid > 0
            and   indid < 255)
   drop index VOLTOOIDE_LENING.FIETS_IN_LENING_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('VOLTOOIDE_LENING')
            and   name  = 'KLANT_IN_LENING_FK'
            and   indid > 0
            and   indid < 255)
   drop index VOLTOOIDE_LENING.KLANT_IN_LENING_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('VOLTOOIDE_LENING')
            and   type = 'U')
   drop table VOLTOOIDE_LENING
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('WERKNEMER')
            and   name  = 'WERKNEMERINONGROUNDTEAM_FK'
            and   indid > 0
            and   indid < 255)
   drop index WERKNEMER.WERKNEMERINONGROUNDTEAM_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('WERKNEMER')
            and   type = 'U')
   drop table WERKNEMER
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

if exists(select 1 from systypes where name='TEKST')
   drop type TEKST
go

if exists(select 1 from systypes where name='TELEFOON')
   drop type TELEFOON
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
   from decimal(5,2)
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
/* Domain: TEKST                                                */
/*==============================================================*/
create type TEKST
   from varchar(50)
go

/*==============================================================*/
/* Domain: TELEFOON                                             */
/*==============================================================*/
create type TELEFOON
   from varchar(15)
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
   LONGTERM	            WEL_OF_NIET          not null,
   constraint PK_ABONNEMENTTYPE primary key nonclustered (ABONNEMENTTYPE)
)
go

/*==============================================================*/
/* Table: ADMIN                                                 */
/*==============================================================*/
create table ADMIN (
   WERKNEMERID          ID_NUMMER            not null,
   constraint PK_ADMIN primary key (WERKNEMERID)
)
go

/*==============================================================*/
/* Table: BESTELLING                                            */
/*==============================================================*/
create table BESTELLING (
   ORDERID              ID_NUMMER            not null,
   WORKSHOPID           ID_NUMMER            not null,
   LEVERANCIERID        ID_NUMMER            null,
   ONDERDEELID          ID_NUMMER            null,
   DATUM			    DATUM                not null,
   AANTAL               CIJFER               not null,
   constraint PK_BESTELLING primary key nonclustered (ORDERID)
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
/* Index: BESTELINGEN_VAN_FIETSONDERDEELBIJLEVERANCIER_FK       */
/*==============================================================*/
create index BESTELINGEN_VAN_FIETSONDERDEELBIJLEVERANCIER_FK on BESTELLING (
LEVERANCIERID ASC,
ONDERDEELID ASC
)
go

/*==============================================================*/
/* Table: BESTELLING_HISTORY                                    */
/*==============================================================*/
create table BESTELLING_HISTORY (
   ORDERID              int                  null,
   WORKSHOPID           int                  null,
   LEVERANCIERNAAM      varchar(50)          null,
   ONDERDEELNAAM        varchar(50)          null,
   DATUM                varchar(50)          null,
   AANTAL               date                 null,
   TIMESTAMP            datetime             null,
   "USER"               varchar(50)          null
)
go

/*==============================================================*/
/* Table: FIETS                                                 */
/*==============================================================*/
create table FIETS (
   FIETSID              ID_NUMMER            not null,
   WORKSHOPID           ID_NUMMER            null,
   constraint PK_FIETS primary key nonclustered (FIETSID)
)
go

/*==============================================================*/
/* Index: FIETS_IN_WORKSHOP_FK                                  */
/*==============================================================*/
create index FIETS_IN_WORKSHOP_FK on FIETS (
WORKSHOPID ASC
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
/* Table: FIETSPOST                                             */
/*==============================================================*/
create table FIETSPOST (
   STATIONID            ID_NUMMER            not null,
   FIETSPOSTID          CIJFER               not null,
   FIETSID              ID_NUMMER            not null,
   MOETGECHECKTWORDEN   WEL_OF_NIET          not null,
   constraint PK_FIETSPOST primary key nonclustered (STATIONID, FIETSPOSTID)
)
go

/*==============================================================*/
/* Index: FIETS_IN_FIETSINSTATION_FK                            */
/*==============================================================*/
create index FIETS_IN_FIETSINSTATION_FK on FIETSPOST (
FIETSID ASC
)
go

/*==============================================================*/
/* Index: STATION_IN_FIETSINSTATION_FK                          */
/*==============================================================*/
create index STATION_IN_FIETSINSTATION_FK on FIETSPOST (
STATIONID ASC
)
go

/*==============================================================*/
/* Table: KLANT                                                 */
/*==============================================================*/
create table KLANT (
   KLANTID              ID_NUMMER            not null,
   NAAM                 NAAM                 not null,
   ACHTERNAAM           NAAM                 not null,
   ADRES                TEKST                not null,
   POSTCODE             POSTCODE             not null,
   GEBOORTEDATUM        DATUM                not null,
   IS_STUDENT           WEL_OF_NIET          not null,
   IS_SOCIO             WEL_OF_NIET          not null,
   constraint PK_KLANT primary key nonclustered (KLANTID)
)
go

/*==============================================================*/
/* Table: KLANTHEEFTABONNEMENT                                  */
/*==============================================================*/
create table KLANTHEEFTABONNEMENT (
   ABONNEMENTTYPE       TEKST                not null,
   KLANTID              ID_NUMMER            not null,
   START_DATUM          DATUM                not null,
   EIND_TIJD            DATUM                not null,
   CREDITKAARTNUMMER    CIJFER               null,
   PREPAIDTEGOED        GELD                 null,
   AUTOMATISCH_VERLENGT WEL_OF_NIET          not null,
   constraint PK_KLANTHEEFTABONNEMENT primary key nonclustered (ABONNEMENTTYPE, KLANTID, START_DATUM)
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
KLANTID ASC
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
   START_DATUM	        DATUM                not null,
   WORKSHOPID           ID_NUMMER            not null,
   EIND_TIJD            DATUM                not null,
   constraint PK_MONTEURDIENST primary key nonclustered (WERKNEMERID, START_DATUM)
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
/* Table: ONGROUNDCONTROLE                                      */
/*==============================================================*/
create table ONGROUNDCONTROLE (
   FIETSID              ID_NUMMER            not null,
   DATUM                DATUM                not null,
   WERKNEMERID          ID_NUMMER            not null,
   BESCHRIJVING         BESCHRIJVING         null,
   constraint PK_ONGROUNDCONTROLE primary key nonclustered (FIETSID, DATUM)
)
go

/*==============================================================*/
/* Index: ONGROUNDREPARATIES_DOOR_WERKNEMER_FK                  */
/*==============================================================*/
create index ONGROUNDREPARATIES_DOOR_WERKNEMER_FK on ONGROUNDCONTROLE (
WERKNEMERID ASC
)
go

/*==============================================================*/
/* Index: FIETS_IN_ONGROUNDREPARATIES_FK                        */
/*==============================================================*/
create index FIETS_IN_ONGROUNDREPARATIES_FK on ONGROUNDCONTROLE (
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
/* Table: REPARATIE                                             */
/*==============================================================*/
create table REPARATIE (
   FIETSID              ID_NUMMER            not null,
   ONDERDEELID          ID_NUMMER            not null,
   REPARATIE_DATUM      DATUM_EN_TIJD        not null,
   WERKNEMERID          ID_NUMMER            not null,
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
   WORKSHOPID           ID_NUMMER            not null,
   VOLGNUMMER           CIJFER               not null,
   FIETSID              ID_NUMMER            not null,
   BESCHRIJVING         BESCHRIJVING         null,
   WORDT_GEREPAREERD    bit                  null,
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
   RITDATUM             DATUM                not null,
   STATIONID            ID_NUMMER            not null,
   constraint PK_ROUTINGCARD primary key nonclustered (TEAMID, RITDATUM)
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
   DATUM		        DATUM                not null,
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
   ADRES                TEKST                not null,
   CAPACITEIT           CIJFER               not null,
   V_PLUS               WEL_OF_NIET          not null,
   constraint PK_STATION primary key nonclustered (STATIONID)
)
go

/*==============================================================*/
/* Table: STATION_IN_SPECIAAL_EVENEMENT                         */
/*==============================================================*/
create table STATION_IN_SPECIAAL_EVENEMENT (
   STATIONID            ID_NUMMER            not null,
   EVENTID              ID_NUMMER            not null,
   constraint PK_STATION_IN_SPECIAAL_EVENEME primary key (STATIONID, EVENTID)
)
go

/*==============================================================*/
/* Index: STATION_IN_SPECIAAL_EVENEMENT_FK                      */
/*==============================================================*/
create index STATION_IN_SPECIAAL_EVENEMENT_FK on STATION_IN_SPECIAAL_EVENEMENT (
STATIONID ASC
)
go

/*==============================================================*/
/* Index: STATION_IN_SPECIAAL_EVENEMENT2_FK                     */
/*==============================================================*/
create index STATION_IN_SPECIAAL_EVENEMENT2_FK on STATION_IN_SPECIAAL_EVENEMENT (
EVENTID ASC
)
go

/*==============================================================*/
/* Table: TAAK                                                  */
/*==============================================================*/
create table TAAK (
   TAAKID               int                  not null,
   TAAKNAAM             varchar(Max)         not null,
   constraint PK_TAAK primary key (TAAKID)
)
go

/*==============================================================*/
/* Table: UITGELEENDE_FIETS                                     */
/*==============================================================*/
create table UITGELEENDE_FIETS (
   FIETSID              ID_NUMMER            not null,
   KLANTID              ID_NUMMER            not null,
   START_TIJD_LENING    DATUM_EN_TIJD        not null,
   START_STATION        ID_NUMMER            null,
   EXTRA_TIJD           WEL_OF_NIET          not null,
   constraint PK_UITGELEENDE_FIETS primary key nonclustered (FIETSID, KLANTID, START_TIJD_LENING)
)
go

/*==============================================================*/
/* Index: RELATIONSHIP_29_FK                                    */
/*==============================================================*/
create index RELATIONSHIP_29_FK on UITGELEENDE_FIETS (
FIETSID ASC
)
go

/*==============================================================*/
/* Index: RELATIONSHIP_30_FK                                    */
/*==============================================================*/
create index RELATIONSHIP_30_FK on UITGELEENDE_FIETS (
KLANTID ASC
)
go

/*==============================================================*/
/* Index: STARTSTATION_FK                                       */
/*==============================================================*/
create index STARTSTATION_FK on UITGELEENDE_FIETS (
START_STATION ASC
)
go

/*==============================================================*/
/* Table: VOLTOOIDE_LENING                                      */
/*==============================================================*/
create table VOLTOOIDE_LENING (
   KLANTID              ID_NUMMER            not null,
   FIETSID              ID_NUMMER            not null,
   START_TIJD           DATUM_EN_TIJD        not null,
   START_STATION        ID_NUMMER            not null,
   EIND_STATION         ID_NUMMER            not null,
   EIND_TIJD            DATUM                not null,
   PRIJS                GELD                 not null,
   EXTRA_TIJD           WEL_OF_NIET          not null,
   constraint PK_VOLTOOIDE_LENING primary key nonclustered (KLANTID, FIETSID, START_TIJD)
)
go

/*==============================================================*/
/* Index: KLANT_IN_LENING_FK                                    */
/*==============================================================*/
create index KLANT_IN_LENING_FK on VOLTOOIDE_LENING (
KLANTID ASC
)
go

/*==============================================================*/
/* Index: FIETS_IN_LENING_FK                                    */
/*==============================================================*/
create index FIETS_IN_LENING_FK on VOLTOOIDE_LENING (
FIETSID ASC
)
go

/*==============================================================*/
/* Index: BEGINSTATION_LENING_FK                                */
/*==============================================================*/
create index BEGINSTATION_LENING_FK on VOLTOOIDE_LENING (
START_STATION ASC
)
go

/*==============================================================*/
/* Index: EINDSTATION_LENING_FK                                 */
/*==============================================================*/
create index EINDSTATION_LENING_FK on VOLTOOIDE_LENING (
EIND_STATION ASC
)
go

/*==============================================================*/
/* Table: WERKNEMER                                             */
/*==============================================================*/
create table WERKNEMER (
   WERKNEMERID          ID_NUMMER            not null,
   TEAMID               CIJFER               null,
   VOORNAAM             NAAM                 not null,
   ACHTERNAAM           NAAM                 not null,
   ADRES                TEKST                not null,
   POSTCODE             POSTCODE             not null,
   WACHTWOORD           varchar(1024)        not null,
   ACTIEF				WEL_OF_NIET			not null,
   constraint PK_WERKNEMER primary key nonclustered (WERKNEMERID)
)
go

/*==============================================================*/
/* Index: WERKNEMERINONGROUNDTEAM_FK                            */
/*==============================================================*/
create index WERKNEMERINONGROUNDTEAM_FK on WERKNEMER (
TEAMID ASC
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

alter table ADMIN
   add constraint FK_ADMIN_REFERENCE_WERKNEME foreign key (WERKNEMERID)
      references WERKNEMER (WERKNEMERID)
go

alter table BESTELLING
   add constraint FK_BESTELLI_BESTELING_FIETSOND foreign key (LEVERANCIERID, ONDERDEELID)
      references FIETSONDERDEELBIJLEVERANCIER (LEVERANCIERID, ONDERDEELID)
go

alter table BESTELLING
   add constraint FK_BESTELLI_WORKSHOP__WORKSHOP foreign key (WORKSHOPID)
      references WORKSHOP (WORKSHOPID)
go

alter table FIETS
   add constraint FK_FIETS_FIETS_IN__WORKSHOP foreign key (WORKSHOPID)
      references WORKSHOP (WORKSHOPID)
go

alter table FIETSONDERDEELBIJLEVERANCIER
   add constraint FK_FIETSOND_FIETSONDE_FIETSOND foreign key (ONDERDEELID)
      references FIETSONDERDEEL (ONDERDEELID)
go

alter table FIETSONDERDEELBIJLEVERANCIER
   add constraint FK_FIETSOND_RELATIONS_LEVERANC foreign key (LEVERANCIERID)
      references LEVERANCIER (LEVERANCIERID)
go

alter table FIETSONDERDEELINWORKSHOP
   add constraint FK_FIETSOND_FIETS1OND_FIETSOND foreign key (ONDERDEELID)
      references FIETSONDERDEEL (ONDERDEELID)
go

alter table FIETSONDERDEELINWORKSHOP
   add constraint FK_FIETSOND_WORKSHOP__WORKSHOP foreign key (WORKSHOPID)
      references WORKSHOP (WORKSHOPID)
go

alter table FIETSPOST
   add constraint FK_FIETSPOS_FIETS_IN__FIETS foreign key (FIETSID)
      references FIETS (FIETSID)
go

alter table FIETSPOST
   add constraint FK_FIETSPOS_STATION_I_STATION foreign key (STATIONID)
      references STATION (STATIONID)
go

alter table KLANTHEEFTABONNEMENT
   add constraint FK_KLANTHEE_KLANT_VAN_KLANT foreign key (KLANTID)
      references KLANT (KLANTID)
go

alter table KLANTHEEFTABONNEMENT
   add constraint FK_KLANTHEE_RELATIONS_ABONNEME foreign key (ABONNEMENTTYPE)
      references ABONNEMENTTYPE (ABONNEMENTTYPE)
go

alter table MONTEURDIENST
   add constraint FK_MONTEURD_DIENST_VA_WERKNEME foreign key (WERKNEMERID)
      references WERKNEMER (WERKNEMERID)
go

alter table MONTEURDIENST
   add constraint FK_MONTEURD_WORKSHOP__WORKSHOP foreign key (WORKSHOPID)
      references WORKSHOP (WORKSHOPID)
go

alter table ONGROUNDCONTROLE
   add constraint FK_ONGROUND_FIETS_IN__FIETS foreign key (FIETSID)
      references FIETS (FIETSID)
go

alter table ONGROUNDCONTROLE
   add constraint FK_ONGROUND_ONGROUNDR_WERKNEME foreign key (WERKNEMERID)
      references WERKNEMER (WERKNEMERID)
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
   add constraint FK_REPARATI_FIETS1_IN_FIETS foreign key (FIETSID)
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

alter table STATION_IN_SPECIAAL_EVENEMENT
   add constraint FK_STATION__STATION_I_STATION foreign key (STATIONID)
      references STATION (STATIONID)
go

alter table STATION_IN_SPECIAAL_EVENEMENT
   add constraint FK_STATION__STATION_I_SPECIAAL foreign key (EVENTID)
      references SPECIAAL_EVENEMENT (EVENTID)
go

alter table UITGELEENDE_FIETS
   add constraint FK_UITGELEE_RELATIONS_FIETS foreign key (FIETSID)
      references FIETS (FIETSID)
go

alter table UITGELEENDE_FIETS
   add constraint FK_UITGELEE_RELATIONS_KLANT foreign key (KLANTID)
      references KLANT (KLANTID)
go

alter table UITGELEENDE_FIETS
   add constraint FK_UITGELEE_STARTSTAT_STATION foreign key (START_STATION)
      references STATION (STATIONID)
go

alter table VOLTOOIDE_LENING
   add constraint FK_VOLTOOID_BEGINSTAT_STATION foreign key (START_STATION)
      references STATION (STATIONID)
go

alter table VOLTOOIDE_LENING
   add constraint FK_VOLTOOID_EINDSTATI_STATION foreign key (EIND_STATION)
      references STATION (STATIONID)
go

alter table VOLTOOIDE_LENING
   add constraint FK_VOLTOOID_FIETS_IN__FIETS foreign key (FIETSID)
      references FIETS (FIETSID)
go

alter table VOLTOOIDE_LENING
   add constraint FK_VOLTOOID_KLANT_IN__KLANT foreign key (KLANTID)
      references KLANT (KLANTID)
go

alter table WERKNEMER
   add constraint FK_WERKNEME_WERKNEMER_ONGROUND foreign key (TEAMID)
      references ONGROUNDTEAM (TEAMID)
go

