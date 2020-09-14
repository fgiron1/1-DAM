USE master
GO
CREATE DATABASE Monstruos
GO
USE Monstruos

SET DATEFORMAT dmy;

GO
CREATE TABLE Pueblos(

	ID int IDENTITY(1,1) NOT NULL,
	nombre nvarchar(20) NOT NULL,
	tamano int NOT NULL, --Ver como hago para ponerlo en cm
	distancia_castillo int NOT NULL --Ver como hago para ponerlo en m

	CONSTRAINT PKPueblos PRIMARY KEY (ID),
	CONSTRAINT CK_Tamano CHECK (tamano = N'Grande' OR
								tamano = N'Mediano' OR
								tamano = N'Pequeño')
)
GO

GO
CREATE TABLE Monstruos(

	nombre nvarchar(25) NOT NULL,
	IDPueblo int NULL, --NULL por la cardinalidad (0,1)
	altura int NOT NULL, --Ver como hago para ponerlo en cm
	fecha_creacion date NOT NULL

	CONSTRAINT PKMonstruos PRIMARY KEY (nombre),
	CONSTRAINT FKMonstruosPueblos FOREIGN KEY (IDPueblo) REFERENCES Pueblos (ID)

)
GO

GO
CREATE TABLE Ordenes(

	ID int IDENTITY(1,1) NOT NULL,
	IDOrdenes int NULL,
	nombre nvarchar(30) NOT NULL,
	descripcion nvarchar(70) NOT NULL

	CONSTRAINT PKOrdenes PRIMARY KEY(ID),
	CONSTRAINT FKOrdenesOrdenes FOREIGN KEY(IDOrdenes) REFERENCES Ordenes(ID)

)
GO

GO
CREATE TABLE MonstruosOrdenes(

	IDOrden int NOT NULL, --Es NOT NULL aunque la cardinalidad sea (0, N) porque si un monstruo no se relaciona con ninguna orden, sencillamente no habría una fila en esta tabla
	IDMonstruo nvarchar(25) NOT NULL

	CONSTRAINT FKOrdenes FOREIGN KEY(IDOrden) REFERENCES Ordenes(ID),
	CONSTRAINT FKMonstruos FOREIGN KEY(IDMonstruo) REFERENCES Monstruos(nombre),
	CONSTRAINT PKMonstruosOrdenes PRIMARY KEY (IDOrden, IDMonstruo)

)
GO

GO
CREATE TABLE Partes(

	ID int IDENTITY(1,1) NOT NULL,
	IDMonstruo nvarchar(25) NULL, --NULL por la cardinalidad (0, 1)
	tipo nvarchar(25) NOT NULL,
	tamano int NOT NULL,
	animal nvarchar(25) NOT NULL

	CONSTRAINT PKPartes PRIMARY KEY (ID),
	CONSTRAINT FKPartesMonstruos FOREIGN KEY (IDMonstruo) REFERENCES Monstruos (nombre)
)
GO

GO
CREATE TABLE Turbas(

	ID int IDENTITY(1,1) NOT NULL,
	IDPueblo int NOT NULL,
	nombre nvarchar(25) NOT NULL,
	categoria nvarchar(100) NOT NULL

	CONSTRAINT PKTurbas PRIMARY KEY (ID)
	CONSTRAINT FKTurbasPueblos FOREIGN KEY (IDPueblo) REFERENCES Pueblos(ID) ON DELETE CASCADE,
	CONSTRAINT CKCategoria CHECK (categoria = 'Huyen cuando te acercas' OR
								  categoria = 'Se reúnen sólo para beber en el bar' OR
								  categoria = '¡Corre! ¡Corre!')

)
GO


GO
CREATE TABLE Vecinos(

	ID int IDENTITY(1,1) NOT NULL,
	IDPueblo int NOT NULL,
	IDTurba int NOT NULL,
	nombre nvarchar(25) NOT NULL,
	direccion nvarchar(100) NOT NULL

	CONSTRAINT PKVecinos PRIMARY KEY (ID),
	CONSTRAINT FKVecinosPueblos FOREIGN KEY (IDPueblo) REFERENCES Pueblos(ID) ON DELETE CASCADE,
	CONSTRAINT FKVecinosTurbas FOREIGN KEY (IDTurba) REFERENCES Turbas(ID)
)

GO