

--INTERFAZ
--
--Analisis: Esta funcion devuelve la puntuacion, el numero de podios, el numero de carreras finalizadas
--y carreras ganadas de cada piloto
--
--Interfaz: FNClasificacion (@Numero AS tinyint)
--
--Variables de entrada: El gran premio hasta el que se desea conocer la información de cada piloto

--Variables de salida: Ninguna

--Precondiciones: @Numero es una variable entera positiva

--Postcondiciones: Habrá tantas filas como pilotos hayan participado en ese GP y en los anteriores
GO
CREATE FUNCTION FNClasificacion (@Numero AS tinyint) RETURNS TABLE AS
RETURN

SELECT  PE.Dorsal,
		P.Nombre,
		NP.Cantidad AS Podios,
		PE.Puntos AS Puntuacion,
		NCF.Finalizadas AS CarrerasFinalizadas,
		NCG.Cantidad AS CarrerasGanadas
		
	
FROM FNPuntuacionEquivalente(@Numero) AS PE
INNER JOIN FNNumeroPodios(@Numero) AS NP ON PE.Dorsal = NP.Dorsal
INNER JOIN Pilotos AS P ON P.Dorsal = PE.Dorsal
INNER JOIN FNNumeroCarrerasGanadas(@Numero) AS NCG ON PE.Dorsal = NCG.Dorsal
INNER JOIN FNNumeroCarrerasFinalizadas(@Numero) AS NCF ON PE.Dorsal = NCF.Dorsal
GO

SELECT * FROM FNClasificacion(1)


--Esta es una funcion auxiliar que calcula la cantidad de veces que cada piloto ha conseguido
--llegar al podio.  Todos los calculos se realizan hasta un GP determinado pasado por parametros
GO
CREATE FUNCTION FNNumeroPodios(@Numero AS tinyint) RETURNS TABLE AS
RETURN

SELECT Sub1.Dorsal, SUM(Sub1.Cantidad) AS Cantidad  FROM
(SELECT Dorsal, NumOrden,
	CASE Posición
		WHEN 1 THEN 1
		WHEN 2 THEN 1
		WHEN 3 THEN 1
		ELSE 0
	END AS Cantidad
	FROM Disputas
	WHERE NumOrden <= @Numero) AS Sub1
GROUP BY Sub1.Dorsal
GO

--Esta es una funcion auxiliar que calcula la puntuación a la que equivale la posición en la que
--cada piloto ha acabado en cada GP y las suma para obtener la puntuacion total. Todos los calculos
--se realizan hasta un GP determinado pasado por parametros
GO
CREATE FUNCTION FNPuntuacionEquivalente(@Numero AS tinyint) RETURNS TABLE AS 
RETURN

SELECT Sub1.Dorsal, SUM(Sub1.Puntos) AS Puntos FROM
(SELECT Dorsal, NumOrden,
	CASE Finalizado
		WHEN 1 THEN
			CASE Posición
				WHEN 1 THEN 20
				WHEN 2 THEN 15
				WHEN 3 THEN 11
				WHEN 4 THEN 8
				WHEN 5 THEN 6
				WHEN 6 THEN 4
				WHEN 7 THEN 3
				ELSE 1
			END
		ELSE 0
	END AS Puntos
FROM Disputas
WHERE NumOrden <= @Numero) AS Sub1
GROUP BY Sub1.Dorsal
GO

--Esta es una funcion auxiliar que calcula la cantidad de carreras que ha ganado cada piloto (queda en primera posicion).
--Todos los calculos se realizan hasta un GP determinado pasado por parametros
GO
CREATE FUNCTION FNNumeroCarrerasGanadas(@Numero AS tinyint) RETURNS TABLE AS
RETURN
SELECT Sub1.Dorsal, SUM(Sub1.Cantidad) AS Cantidad FROM
	(SELECT Dorsal, NumOrden,
	CASE Posición
		WHEN 1 THEN 1
		ELSE 0
	END AS Cantidad
	FROM Disputas
	WHERE NumOrden <= @Numero) AS Sub1
GROUP BY Sub1.Dorsal
GO

--Esta es una funcion auxiliar que calcula la cantidad de carreras que ha acabado cada piloto.
--Todos los calculos se realizan hasta un GP determinado pasado por parametros
GO
CREATE FUNCTION FNNumeroCarrerasFinalizadas(@Numero AS tinyint) RETURNS TABLE AS
RETURN
SELECT Dorsal, SUM(CAST(Finalizado AS tinyint)) AS Finalizadas FROM Disputas
WHERE NumOrden <= @Numero
GROUP BY Dorsal
GO

