-- stap 5 maak en vul admin tabel

/*==============================================================*/
/* Table: ADMINTABEL                                            */
/*==============================================================*/
if exists(select 1 from sys.tables where name = 'ADMINTABEL') BEGIN
	DROP TABLE ADMINTABEL
END

create table ADMINTABEL (
	WERKNEMERID			ID_NUMMER			not null,
	constraint PK_ADMINTABEL primary key (WERKNEMERID),
	constraint FK_ADMINTABEL foreign key (WERKNEMERID) references WERKNEMER(WERKNEMERID)
)
go

INSERT ADMINTABEL VALUES(1)
INSERT ADMINTABEL VALUES(10)
INSERT ADMINTABEL VALUES(14)
INSERT ADMINTABEL VALUES(40)
INSERT ADMINTABEL VALUES(41)
INSERT ADMINTABEL VALUES(77)

