USE master
GO
CREATE DATABASE CovidRota
GO
USE CovidRota

CREATE TABLE Espacios(

	ID smallint NOT NULL,
	nombre nvarchar(25) NOT NULL,
	descripcion nvarchar(150) NOT NULL,
	superficie float NOT NULL,

	CONSTRAINT PKEspacios PRIMARY KEY (ID)

)

CREATE TABLE Zonas(

	IDEspacio smallint NOT NULL,
	numero smallint NOT NULL,
	nombre nvarchar(25) NULL,
	aforo_max int NOT NULL,

	CONSTRAINT PKZonas PRIMARY KEY (IDEspacio, numero),
	CONSTRAINT FKZonasEspacios FOREIGN KEY (IDEspacio) REFERENCES Espacios (ID),
	--Restriccion ejercicio 4
	CONSTRAINT CK_Aforo_max CHECK (aforo_max >= 10 AND aforo_max <= 1200)
)

CREATE TABLE Restricciones(

	ID int NOT NULL,
	IDZonaEspacio smallint NOT NULL,
	IDZonaNumero smallint NOT NULL,
	momento_inicio smalldatetime NOT NULL,
	momento_fin smalldatetime NOT NULL

	CONSTRAINT PKRestricciones PRIMARY KEY (ID),
	CONSTRAINT FKRestriccionesZonas FOREIGN KEY (IDZonaEspacio, IDZonaNumero) REFERENCES Zonas (IDEspacio, numero), --Propagación de la clave primaria compuesta de la tabla Zonas
	--Restricción ejercicio 4:
	CONSTRAINT CK_MomentoInicio CHECK (momento_inicio < momento_fin)

)

CREATE TABLE Puntos(

	ID smallint NOT NULL,
	IDZonaEspacio smallint NOT NULL,
	IDZonaNumero smallint NOT NULL,
	IDContiguo smallint NULL --Este campo expresa si el punto de acceso es contiguo a otro

	CONSTRAINT PKPuntos PRIMARY KEY (ID),
	CONSTRAINT FKPuntosPuntosContiguos FOREIGN KEY (IDContiguo) REFERENCES Puntos(ID),
	CONSTRAINT FKPuntosZonas FOREIGN KEY (IDZonaEspacio, IDZonaNumero) REFERENCES Zonas(IDEspacio, numero)

)




CREATE TABLE Personas(

	ID int NOT NULL,
	nombre nvarchar(30) NOT NULL,
	apellidos nvarchar(45) NOT NULL,
	domicilio nvarchar(100) NOT NULL

	CONSTRAINT PKPersonas PRIMARY KEY (ID)

)

CREATE TABLE Movimientos(

	ID int NOT NULL,
	IDPunto smallint NOT NULL,
	IDPersona int NULL, --NULL muy importante, porque nos permite contabilizar a las personas cuya informacion no esta registrada
	momento smalldatetime NOT NULL,
	es_entrada bit NOT NULL --Funciona como booleano, y nos indicara si el movimiento es de entrada (1) o salida (0)

	CONSTRAINT PKMovimientos PRIMARY KEY (ID),
	CONSTRAINT FKMovimientosPuntos FOREIGN KEY (IDPunto) REFERENCES Puntos (ID),
	CONSTRAINT FKMovimientosPersonas FOREIGN KEY (IDPersona) REFERENCES Personas (ID)

)


CREATE TABLE Enfermos(

	IDPersona int UNIQUE NOT NULL, --Debe ser UNIQUE porque si hay una entidad enfermo, inevitablemente va a haber una entidad persona, por lo que este campo nunca seria NULL. (Ademas, una entidad persona, si se relaciona con alguna entidad enfermo, deberá ser necesariamente 1:1, puesto que una persona no puede representar a dos enfermos ni un enfermo representar a varias personas)
	numero_ss char(9) UNIQUE NOT NULL, --Restricción ejercicio 4
	fecha_deteccion date NOT NULL,
	estado char(3) NOT NULL

	CONSTRAINT PKEnfermos PRIMARY KEY (IDPersona),
	CONSTRAINT FKEnfermosPersonas FOREIGN KEY (IDPersona) REFERENCES Personas(ID),
	CONSTRAINT CK_Numero_SS CHECK (numero_ss LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	--Restricción ejercicio 4
	CONSTRAINT CK_Estado CHECK (estado IN ('AS1', 'AS2', 'SL1', 'SL2', 'SM1', 'SM2', 'GR1', 'GR2'))

)

CREATE TABLE Delincuentes(

	IDPersona int UNIQUE NOT NULL, --Debe ser UNIQUE por los mismos motivos que en el caso de la tabla Enfermos
	reclama nvarchar(50) NOT NULL,
	motivo nvarchar(100) NOT NULL

	CONSTRAINT PKDelincuentes PRIMARY KEY (IDPersona),
	CONSTRAINT FKDelincuentesPersonas FOREIGN KEY (IDPersona) REFERENCES Personas (ID)

)

CREATE TABLE Rastreadores(

	ID int NOT NULL,
	IDEnfermo int NOT NULL,
	nombre nvarchar(30) NOT NULL,
	telefono char(9) NOT NULL,
	email nvarchar(40) NOT NULL

	CONSTRAINT PKRastreadores PRIMARY KEY (ID),
	CONSTRAINT FKRastreadoresEnfermos FOREIGN KEY (IDEnfermo) REFERENCES Enfermos (IDPersona),
	CONSTRAINT CK_Telefono CHECK (telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT CK_Email CHECK (email LIKE '%@%.%')

)

--Ejercicio 5

CREATE TABLE Equipos(

	ID smallint NOT NULL,
	IDEspacio smallint NOT NULL,
	nombre nvarchar(25) NOT NULL,
	descripcion nvarchar(100) NOT NULL,
	cantidad smallint NOT NULL

	CONSTRAINT PKEquipos PRIMARY KEY (ID),
	CONSTRAINT FKEquiposEspacios FOREIGN KEY (IDEspacio) REFERENCES Espacios (ID)

)

