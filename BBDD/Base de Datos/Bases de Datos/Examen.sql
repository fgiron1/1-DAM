CREATE DATABASE Cumbre
GO
USE Cumbre
GO

CREATE TABLE Comite (
	ID smallInt Not NULL Identity (1,1),
	tema
	presupuesto
	email
)
GO

CREATE TABLE Organizacion (
	Num smallInt Not NULL Identity (1,1),
	nombre
	pais
	email
	sector
	indiceEcologico
)
GO

CREATE TABLE Propuesta (
	ID smallInt Not NULL Identity (1,1),
	fecha
	descripcion_corta
	texto_largo
)
GO

CREATE TABLE Invitado (
	ID smallInt Not NULL Identity (1,1),
	nombre
	apellidos
	nacionalidad
	tipo
	relevancia
)
GO


CREATE TABLE Miembro (
	ID smallInt Not NULL Identity (1,1),
	nombre
	apellidos
	nacionalidad
	telefono
	email
	twitter
)
GO

CREATE TABLE ONG (
	mision,
	numero_miembros,
	internacional bit,
)
GO



CREATE TABLE Movilizacion (
	ID smallInt Not NULL Identity (1,1),
	fechaHora
	lugarInicio
	tipo
	lema
	recorrido
)
GO



CREATE TABLE Oficial (
	CIF smallInt Not NULL Identity (1,1),
	pais
	numeroTrabajadores
	web
	toneladasCO2
)
GO

CREATE TABLE EmpresaOrganismo (
	ID smallInt Not NULL Identity (1,1),
	facturacion
	presupuesto
)
GO



CREATE TABLE Financia (
	ID smallInt Not NULL Identity (1,1),
	importe
)
GO



CREATE TABLE Habla (
	ID smallInt Not NULL Identity (1,1),
	idiomaPonencia
	fechaHora
	tema
	duracion
)
GO

CREATE TABLE Zona_protegida (
	ID smallInt Not NULL Identity (1,1),
	nombre
	extension
	latitud
	longitud
)
GO



CREATE TABLE Zona_incluida (


)
GO



CREATE TABLE OngConvocaMovilizacion (


)
GO

CREATE TABLE OrganizacionComitePropuesta (


)
GO



