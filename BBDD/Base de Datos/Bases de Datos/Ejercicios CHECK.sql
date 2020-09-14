If Not Exists (SELECT * From Sys.databases Where name = 'Ejemplos' )
	Create Database Ejemplos
GO
USE Ejemplos
GO

/*
Añade las restricciones CHECK necesarias para que se cumplan las siguientes reglas:

NumeroPie debe estar entre 25 y 60
NumeroChico debe ser menor que 1.000
NumeroGrande debe ser mayor que NumeroChico multiplicado por 100.
NumeroMediano debe ser par y estar comprendido entre NumeroChico y NumeroGrande
FechaNacimiento tienen que ser anterior a la actual (CURRENT_TIMESTAMP)
El nivel de inglés debe tener uno de los siguientes valores: A0, A1, A2, B1, B2, C1 o C2.
Historieta no puede contener las palabras "oscuro" ni "apocalipsis"
Temperatura debe estar comprendido entre 32.5 y 44.
*/


CREATE TABLE CriaturitasRaras(
	ID tinyint NOT NULL,
	Nombre nvarchar(30) NULL,
	FechaNac Date NULL, 
	NumeroPie SmallInt NULL,
	NivelIngles NChar(2) NULL,
	Historieta VarChar(30) NULL,
	NumeroChico TinyInt NULL,
	NumeroGrande BigInt NULL,
	NumeroIntermedio SmallInt NULL,

	CONSTRAINT [PK_CriaturitasEx] PRIMARY KEY(ID),
	CONSTRAINT CK_NumeroPie CHECK (NumeroPie BETWEEN 25 AND 60),
	CONSTRAINT CK_NumeroChico CHECK (NumeroChico < 1000),
	CONSTRAINT CK_NumeroGrande CHECK (NumeroGrande > (100 * NumeroChico)),
	CONSTRAINT CK_NumeroMediano CHECK (NumeroMediano % 2 == 0 &&
) 

GO

