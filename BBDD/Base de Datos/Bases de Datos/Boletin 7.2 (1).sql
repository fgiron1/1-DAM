INSERT INTO Carros (ID, Marca, Modelo, Anho, Color, IDPropietario)
VALUES ('1','Seat','Ibiza','2014','Blanco', NULL),
	   ('2','Ford','Focus','2016','Rojo', '1'),
	   ('3','Toyota','Corolla','2017','Blanco','4'),
	   ('5','Renault','Megane','2015','Azul','2'),
	   ('8','Mitsubishi','Colt','2011','Rojo','6')
GO

INSERT INTO People (ID, Nombre, Apellidos, FechaNac) /*He tenido que insertar primero estos datos antes de poder insertar los de arriba*/
VALUES ('1','Eduardo','Mingo','14/07/1990'),
	   ('2','Margarita','Padera','11/11/1992'),
	   ('4','Eloisa','Lamandra','02/03/2000'),
	   ('5','Jordi','Videndo','25/05/1989'),
	   ('6','Alfonso','Sito','10/10/1978')
GO

INSERT INTO Libros (ID, Titulo, Autors)
VALUES ('2','El corazón de las Tinieblas','Joseph Conrad'),
       ('4','Cien años de soledad','Gabriel García Márquez'),
	   ('8','Harry Potter y la cámara de los secretos','J. K. Rowling'),
	   ('16','Evangelio del Flying Spaguetti Monster','Bobby Henderson')
GO

ALTER TABLE Libros ALTER COLUMN Titulo varchar(60)
GO

ALTER TABLE Libros ALTER COLUMN Autors varchar(60)
GO

INSERT INTO Lecturas (IDLibro, IDLector, AnhoLectura)
VALUES ('4','1','2019'),
	   ('2','2','2014'),
	   ('4','4','2015'),
	   ('8','4','2017'),
	   ('16','5','2010'),
	   ('16','6','2010')
GO

/*5*/
UPDATE Carros
SET IDPropietario = '6'
WHERE IDPropietario = '2'

SELECT Nombre, Apellidos FROM People
WHERE CURRENT_TIMESTAMP - FechaNac >= 30
GO

SELECT Marca, Anho, Modelo FROM Carros
WHERE Color <> 'Blanco' AND Color <> 'Verde'
GO

UPDATE Libros
SET Titulo = 'Vidas santas'
SET Autors = 'Abate Bringas'
WHERE Titulo = 'Evangelio del Flying Spaguetti Monster';
GO


INSERT INTO Lecturas (IDLibro, IDLector, AnhoLectura)
VALUES ('2','4', NULL)
GO

UPDATE Carros
SET IDPropietario = '5'
WHERE IDPropietario = NULL
GO

SELECT IDLector FROM Lecturas
WHERE IDLibro % 2 = 0;
GO