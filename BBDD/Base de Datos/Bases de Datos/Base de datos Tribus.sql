-- Fecha: 15/11/2019
-- Autor: Fernando Girón Domínguez


-- HAY QUE COMPROBAR TODOS LOS NOT NULL


CREATE DATABASE EjemploBueno
GO

CREATE TABLE EJEspecies (
	ID SmallInt Not NULL Identity (1,1),
	NombreCientifico VarChar (50) Not NULL,
	NombreComun VarChar (50) Not NULL,
	Tipo VarChar (30) Not NULL,
	Alimentacion VarChar (30) NULL,
	Volador bit Not NULL,

	Constraint PKEspecies Primary Key (ID)
)
GO

CREATE TABLE EJReligiones (
	ID SmallInt Not  NULL Identity (1,1),
	Nombre VarChar (30) Not NULL,
	Tipo VarChar (30) Not NULL,

	Constraint PKReligiones Primary Key (ID)
)
GO

CREATE TABLE EJTribus (
	ID SmallInt Not  NULL Identity (1,1),
	Nombre VarChar (30) Not NULL,
	Tipo VarChar (30) Not NULL,
	IDReligion SmallInt NULL,

	Constraint PKTribus Primary Key (ID),
	Constraint FKTribusReligionesPractican Foreign Key (IDReligion) REFERENCES EJReligiones (ID) ON DELETE No Action ON UPDATE Cascade
)
GO

CREATE TABLE EJTribusReligiones (

--Lo de poner NULL mirando las cardinalidades se hace para la propagación de las claves, en tablas aparte nunca se pone.

	IDReligion SmallInt Not NULL,
	IDTribu SmallInt Not NULL,

	--Me ha dado error con ON UPDATE Cascade en FKReligionXTribu

	Constraint FKReligionXTribu Foreign Key (IDReligion) REFERENCES EJReligiones (ID) ON DELETE No Action ON UPDATE No Action,
	Constraint FKTribuXReligion Foreign Key (IDTribu) REFERENCES EJTribus (ID) ON DELETE No Action ON UPDATE Cascade,
	Constraint PKTribusReligiones Primary Key (IDReligion, IDTribu)
)
GO

CREATE TABLE EJSeres (
	ID SmallInt Not Null Identity (1,1),
	IDTribu SmallInt NULL,
	IDEspecie SmallInt Not NULL,

	Constraint FKSeresExisteTribu Foreign Key (IDTribu) REFERENCES EJTribus (ID) ON DELETE No Action ON UPDATE Cascade,
	Constraint FKSeresEsdeEspecie Foreign Key (IDEspecie) REFERENCES EJEspecies (ID) ON DELETE No Action ON UPDATE Cascade,
	Constraint PKSeres Primary Key (ID)
)
GO

CREATE TABLE EJGuerras (
	ID SmallInt Not Null Identity (1,1),

	Constraint PKGuerras Primary Key (ID)
)
GO

CREATE TABLE EJSeresEsclavos (
	--Las relaciones reflexivas son tablas que contienen los ID de las dos posibilidades (La relación esclavo implica la existencia de un amo y un esclavo)
	IDAmo SmallInt Not NULL Identity (1,1),
	IDEsclavo SmallInt Not NULL,
	Fecha date Not NULL,

	Constraint FKAmo Foreign Key (IDAmo) REFERENCES EJSeres (ID) ON DELETE No Action ON UPDATE No Action,
	Constraint FKEsclavo Foreign Key (IDEsclavo) REFERENCES EJSeres (ID) ON DELETE No Action ON UPDATE No Action,
	Constraint PKSeresEsclavos Primary Key (IDAmo)

	--La clave primaria es la del lado de la N (Un esclavo solo puede ser de un amo, pero un amo puede tener múltiples esclavos)
)--ERROR
GO

CREATE TABLE EJSeresReligiones (
	IDSer SmallInt Not NULL Identity (1,1),
	IDReligion SmallInt Not NULL,

	Constraint FKSerPerteneceReligion Foreign Key (IDSer) REFERENCES EJSeres (ID),
	Constraint FKReligionPerteneceSer Foreign Key (IDReligion)  REFERENCES EJReligiones (ID),
	Constraint PKSeresReligiones Primary Key (IDSer, IDReligion)
)
GO

CREATE TABLE EJPoblados (
	ID SmallInt Not NULL Identity (1,1),
	IDTribu SmallInt Not NULL,
	Nombre VarChar (30) Not NULL,
	Num_hab SmallInt Not NULL,
	Num_forti SmallInt Not NULL,
	Longitud SmallInt Not NULL,
	Latitud SmallInt Not NULL,

	Constraint PKPoblados Primary Key (ID),
	Constraint FKTribusControlaPoblado Foreign Key (IDTribu) REFERENCES EJTribus (ID)
)
GO

CREATE TABLE EJSacerdotes (
	ID SmallInt Not NULL Identity (1,1),
	IDReligion SmallInt Not NULL,
	Nombre VarChar (30) Not NULL,

	Constraint PKPSacerdotes Primary Key (ID),
	Constraint FKSacerdotesMantieneReligion Foreign Key (IDReligion) REFERENCES EJReligiones (ID)
)
GO

CREATE TABLE EJBandos (
	ID SmallInt Not NULL Identity (1,1),
	IDGuerras SmallInt Not NULL,

	Constraint PKBandos Primary Key (ID),
	Constraint FKBandosParticipaGuerras Foreign Key (IDGuerras) REFERENCES EJGuerras (ID)
)
GO

CREATE TABLE EJBandosTribus (
	
	--Solo una de las dos puede ser Identity

	IDBandos SmallInt Not NULL Identity (1,1),
	IDTribus SmallInt Not NULL,

	Constraint FKBandosApuntaTribus Foreign Key (IDBandos) REFERENCES EJBandos (ID),
	Constraint FKTribusApuntaBandos Foreign Key (IDTribus) REFERENCES EJTribus (ID),
	Constraint PKBandosTribus Primary Key (IDBandos, IDTribus)
)
GO

CREATE TABLE EJBatallasBandos (
	IDBatallas SmallInt Not NULL Identity (1,1),
	IDBandos SmallInt Not NULL,

	Constraint PKBatallasBandos Primary Key (IDBatallas, IDBandos),
	Constraint FKBatallasLuchaBandos Foreign Key (IDBatallas) REFERENCES EJBatallas (ID),
	Constraint FKBandosLuchaBatallas Foreign Key (IDBandos) REFERENCES EJBandos (ID)
)
GO

CREATE TABLE EJBatallas (
	ID SmallInt Not NULL Identity (1,1),
	IDPoblado SmallInt Not NULL,
	FechaInicio date Not NULL,
	FechaFin date Not NULL

	Constraint PKBatallas Primary Key (ID),
	Constraint FKBatallasOcurrePoblado Foreign Key (IDPoblado) REFERENCES EJPoblados (ID)
)