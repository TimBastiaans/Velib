-- stap 7 vul abbonement type goed in dit keer

-- verwijder foreign keys 
ALTER TABLE KLANTHEEFTABONNEMENT
DROP CONSTRAINT FK_KLANTHEE_RELATIONS_ABONNEME

-- voeg hem weer toe met cascading rules
alter table KLANTHEEFTABONNEMENT
   add constraint FK_KLANTHEE_RELATIONS_ABONNEME foreign key (ABONNEMENTTYPE)
      references ABONNEMENTTYPE (ABONNEMENTTYPE) ON UPDATE CASCADE ON DELETE NO ACTION
go

-- vul abonnementtype aan met goeie data
update ABONNEMENTTYPE
set 
	PRIJS = 1.70,
	LOOPTIJD = 1,
	LONGTERM = 0
where ABONNEMENTTYPE = '1-day ticket'

update ABONNEMENTTYPE
set 
	PRIJS = 8,
	LOOPTIJD = 7,
	LONGTERM = 0
where ABONNEMENTTYPE = '7-day ticket'

update ABONNEMENTTYPE
set ABONNEMENTTYPE = 'Velib Classic',
	PRIJS = 29,
	LOOPTIJD = 365,
	LONGTERM = 1
where ABONNEMENTTYPE = 'Velib Classic'

update ABONNEMENTTYPE
set PRIJS = 39,
	LOOPTIJD = 365,
	LONGTERM = 1
where ABONNEMENTTYPE = 'Velib Passion'

update ABONNEMENTTYPE
set 
	PRIJS = 19,
	LOOPTIJD = 365,
	LONGTERM = 1
where ABONNEMENTTYPE = 'Velib Solidarity'

INSERT ABONNEMENTTYPE VALUES
('Velib Passion Young',29,365,1),
('Velib Passion Student',19,365,1),
('Velib Passion Socio',19,365,1)