USE master
GO
CREATE DATABASE Area51
GO
USE Area51

SET DATEFORMAT dmy;

GO
CREATE TABLE Niveles(

	ID int IDENTITY(1,1) NOT NULL,
	numero int NOT NULL,
	nombre nvarchar(20) NOT NULL,
	indice int NOT NULL

	CONSTRAINT PKNiveles PRIMARY KEY (ID),
	CONSTRAINT CK_Indice CHECK (indice > 0 AND indice < 6)

)
GO

GO
CREATE TABLE FuerzasSeguridad(

	ID int IDENTITY(1,1) NOT NULL,
	denominacion nvarchar(30) NOT NULL,
	numero_soldados int NOT NULL,
	armamento nvarchar(30),

	CONSTRAINT PKFuerzasSeguridad PRIMARY KEY (ID),
	CONSTRAINT CK_Armamento CHECK (armamento = N'ligero' OR armamento = N'pesado')

)
GO

GO
CREATE TABLE NivelesFuerzasSeguridad(

	IDNivel int NOT NULL,
	IDFuerzaSeguridad int NOT NULL,
	jefeSeccion bit NULL --Puede haber o no un jefe de seccion

	CONSTRAINT FKNivelesFuerzasSeguridadNiveles FOREIGN KEY (IDNivel) REFERENCES Niveles (ID),
	CONSTRAINT FKNivelesFuerzasSeguridadFuerzaSeguridad FOREIGN KEY (IDFuerzaSeguridad) REFERENCES FuerzasSeguridad (ID),
	CONSTRAINT PKNivelesFuerzasSeguridad PRIMARY KEY (IDNivel, IDFuerzaSeguridad)

)
GO

GO
CREATE TABLE Comandantes(

	ID int IDENTITY(1,1) NOT NULL,
	IDFuerzaSeguridad int UNIQUE NOT NULL,
	nombre nvarchar(40) NOT NULL,
	apellidos nvarchar(50) NOT NULL,
	canal int NOT NULL

	CONSTRAINT PKComandantes PRIMARY KEY (ID),
	CONSTRAINT FKComandantesFuerzaSeguridad FOREIGN KEY (IDFuerzaSeguridad) REFERENCES FuerzasSeguridad (ID)

)
GO

GO
CREATE TABLE Cientificos(

	ID int IDENTITY(1,1) NOT NULL,
	IDNivel int NOT NULL,
	nombre nvarchar(40) NOT NULL,
	apellidos nvarchar(50) NOT NULL,
	antiguedad int NOT NULL,
	especializacion nvarchar(50) NOT NULL

	CONSTRAINT PKCientificos PRIMARY KEY (ID)
	CONSTRAINT FKCientificosNiveles FOREIGN KEY (IDNivel) REFERENCES Niveles (ID)
)
GO

GO
CREATE TABLE Naves(

	ID int IDENTITY(1,1) NOT NULL,
	fecha_descubrimiento date NOT NULL,
	lugar_descubrimiento nvarchar(60) NOT NULL,
	estado_descubrimiento nvarchar(50) NOT NULL,
	fecha_llegada date NOT NULL,

	CONSTRAINT PKNaves PRIMARY KEY (ID)
	
)
GO

GO
CREATE TABLE Aliens(

	ID int IDENTITY(1,1) NOT NULL,
	IDNave int NOT NULL,
	IDNivel int NULL,
	apariencia nvarchar(200) NOT NULL,
	tecnologia nvarchar(60) NOT NULL

	CONSTRAINT PKAliens PRIMARY KEY (ID),
	CONSTRAINT FKAliensNaves FOREIGN KEY (IDNave) REFERENCES Naves(ID),
	CONSTRAINT FKAliensNiveles FOREIGN KEY (IDNivel) REFERENCES Niveles(ID)

)
GO


GO
CREATE TABLE AliensVivos(

	IDAlien int UNIQUE NOT NULL,
	idioma nvarchar(30) NOT NULL,
	intenciones nvarchar(200) NOT NULL

	CONSTRAINT PKAliensVivos PRIMARY KEY (IDAlien),
	CONSTRAINT FKAliens1 FOREIGN KEY (IDAlien) REFERENCES Aliens (ID)
)
GO


GO
CREATE TABLE AliensMuertos(

	IDAlien int UNIQUE NOT NULL,
	fecha_muerte date NOT NULL,
	causa_muerte nvarchar(70) NOT NULL,
	peligro int NOT NULL
	
	CONSTRAINT PKAliensMuertos PRIMARY KEY (IDAlien),
	CONSTRAINT FKAliens2 FOREIGN KEY (IDAlien) REFERENCES Aliens (ID),
	CONSTRAINT CK_Peligro CHECK (peligro >= 0 AND peligro <= 5)
)
GO