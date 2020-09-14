
--Ejercicios 4, 7 y 8 no estan hechos

--1. Escribe una función escalar a la que se pase como parámetros el ID de un tren y un intervalo de tiempo
--(inicio y fin) y nos devuelva el número de estaciones por las que ha pasado ese tren (paradas) en dicho intervalo.

GO
CREATE OR ALTER FUNCTION FNEstacionesEntre(@Inicio smalldatetime, @Fin smalldatetime, @ID int)
RETURNS int AS
BEGIN

	DECLARE @Cantidad int
	SELECT @Cantidad = COUNT(*) FROM LM_Trenes AS T
	INNER JOIN LM_Recorridos AS R ON R.Tren = T.ID
	WHERE T.ID = @ID
	AND R.Momento BETWEEN @Inicio AND @Fin
	
	RETURN @Cantidad

END
GO

--Prueba de la función
GO
DECLARE @Inicio smalldatetime
DECLARE @Fin smalldatetime
DECLARE @ID int

SET @Inicio = SMALLDATETIMEFROMPARTS(2017, 2, 25, 13, 58)
SET @Fin = SMALLDATETIMEFROMPARTS(2017, 2, 28, 23, 00)
SET @ID = 110

DECLARE @Cantidad int
SELECT @Cantidad = COUNT(*) FROM LM_Trenes AS T
INNER JOIN LM_Recorridos AS R ON R.Tren = T.ID
WHERE T.ID = @ID
AND R.Momento BETWEEN @Inicio AND @Fin
PRINT @Cantidad

--Esto no consigo hacer que funcione
--DECLARE @Reusltado int
--SET @Resultado =  EXECUTE FNEstacionesEntre(@EE, @Fin, @ID)

GO

--2. Escribe una función escalar a la que se pase como parámetros el ID de una estación y un intervalo de tiempo
--(inicio y fin) y nos devuelva el número de pasajeros que han entrado o salido del metro por esa estación en
--dicho intervalo.

--Lo que tenemos que contar son las veces que alguien pasa la tarjeta por el torno para entrar o para salir
--independientemente de que sea la misma tarjeta, o que sea la misma persona, solo queremos contabilizar
--los piques, no?

GO
CREATE OR ALTER FUNCTION FNPasajerosEnEstacion(@ID int, @Inicio smalldatetime, @Fin smalldatetime)
RETURNS int
BEGIN

	DECLARE @Cantidad int

	SELECT @Cantidad = COUNT(*) FROM LM_Viajes AS V
	INNER JOIN LM_Estaciones AS E ON V.IDEstacionEntrada = E.ID
								  OR V.IDEstacionSalida = E.ID
	WHERE (V.MomentoEntrada BETWEEN @Inicio AND @Fin
		  OR V.MomentoSalida BETWEEN @Inicio AND @Fin)
		  AND E.ID = @ID

	RETURN @Cantidad

END
GO

DECLARE @Inicio smalldatetime
DECLARE @Fin smalldatetime
DECLARE @ID int

SET @Inicio = SMALLDATETIMEFROMPARTS(2017, 2, 24, 13, 58)
SET @Fin = SMALLDATETIMEFROMPARTS(2017, 2, 25, 23, 00)
SET @ID = 4

SELECT COUNT(*) FROM LM_Viajes AS V
	INNER JOIN LM_Estaciones AS E ON V.IDEstacionEntrada = E.ID
								  OR V.IDEstacionSalida = E.ID
	WHERE (V.MomentoEntrada BETWEEN @Inicio AND @Fin
		  OR V.MomentoSalida BETWEEN @Inicio AND @Fin)
		  AND E.ID = @ID



--3. Escribe una función escalar a la que se pase como parámetros el ID de un pasajero y un intervalo de tiempo
--(inicio y fin) y nos devuelva el total de dinero que ha gastado ese pasajero en dicho intervalo.
--Ten en cuenta que un pasajero puede usar más de una tarjeta.

GO
CREATE OR ALTER FUNCTION FNDineroGastado(@ID int, @Inicio smalldatetime, @Fin smalldatetime)
RETURNS smallmoney
BEGIN

	DECLARE @DineroGastado smallmoney

	SELECT @DineroGastado = SUM(V.Importe_Viaje) FROM LM_Viajes AS V
	WHERE (V.MomentoEntrada BETWEEN @Inicio AND @Fin
		  OR V.MomentoSalida BETWEEN @Inicio AND @Fin)
		  AND V.IDTarjeta IN (SELECT T.ID FROM LM_Tarjetas AS T
							  INNER JOIN LM_Pasajeros AS P ON T.IDPasajero = P.ID
							  WHERE P.ID = @ID)

	--La subconsulta nos devolvera todas las tarjetas asociadas al pasajero


	RETURN @DineroGastado

END
GO

-----------------------------------------------------------------------------------------------------
--Test

DECLARE @Inicio smalldatetime
DECLARE @Fin smalldatetime
DECLARE @ID int

SET @Inicio = SMALLDATETIMEFROMPARTS(2017, 2, 24, 13, 58)
SET @Fin = SMALLDATETIMEFROMPARTS(2017, 2, 25, 23, 00)
SET @ID = 4

SELECT SUM(V.Importe_Viaje) FROM LM_Viajes AS V
WHERE (V.MomentoEntrada BETWEEN @Inicio AND @Fin
	  OR V.MomentoSalida BETWEEN @Inicio AND @Fin)
	  AND V.IDTarjeta IN (SELECT T.ID FROM LM_Tarjetas AS T
						  INNER JOIN LM_Pasajeros AS P ON T.IDPasajero = P.ID
						  WHERE P.ID = @ID)

--Nos devuelve 12,80€
--Comprobemos que esta bien:
--Tarjeta asociada al pasajero de ID = 4

SELECT * FROM LM_Tarjetas

--Solo tiene una tarjeta asociada, cuya ID es 4. Veamos los viajes hechos en el mismo intervalo temporal

DECLARE @Inicio smalldatetime
DECLARE @Fin smalldatetime

SET @Inicio = SMALLDATETIMEFROMPARTS(2017, 2, 24, 13, 58)
SET @Fin = SMALLDATETIMEFROMPARTS(2017, 2, 25, 23, 00)

SELECT * FROM LM_Viajes AS V
WHERE V.IDTarjeta = 4
AND (V.MomentoEntrada BETWEEN @Inicio AND @Fin
OR V.MomentoSalida BETWEEN @Inicio AND @Fin)

--La suma da 12,80 efectivamente
--------------------------------------------------------------------------------------------------------


--4. Utilizando la función creada en el ejercicio anterior, escribe una función de valores de tabla a la que se pase
--como parámetros un intervalo de tiempo (inicio y fin) y nos devuelva una lista de los pasajeros que han gastado
--más que la media durante ese intervalo. Las columnas serán ID del pasajero, Nombre, apellidos e importe gastado.
--Recuerda que una función escalar se puede utilizar en distintas partes de una consulta.

--NO ESTA HECHO

GO
CREATE OR ALTER FUNCTION FNGastosEncimaMedia(@Inicio smalldatetime, @Fin smalldatetime) RETURNS TABLE AS
RETURN

DECLARE @Media smallmoney

SET @Media = EXECUTE FNCalcularMediaGastos(@Inicio, @Fin)

SELECT  FROM LM_Viajes


GO

GO
CREATE OR ALTER FUNCTION FNCalcularMediaGastos(@Inicio smalldatetime, @Fin smalldatetime) 
RETURNS smallmoney
BEGIN

	DECLARE @Media smallmoney
	SELECT @Media = AVG(V.Importe_Viaje) FROM LM_Viajes AS V
	WHERE V.MomentoEntrada BETWEEN @Inicio AND @Fin
	OR V.MomentoSalida BETWEEN @Inicio AND @Fin

	RETURN @Media

END
GO

--5. Escribe una función escalar a la que se pase como parámetros el ID de un tren y un intervalo de tiempo
--(inicio y fin) y nos devuelva el número de kilómetros recorridos por ese tren en dicho periodo.

GO
CREATE OR ALTER FUNCTION FNKilometrosRecorridos(@ID int, @Inicio smalldatetime, @Fin smalldatetime)
RETURNS float
BEGIN

	DECLARE @KilometrosRecorridos float

	SELECT @KilometrosRecorridos = SUM(Sub2.Distancia) FROM

	(SELECT R.Linea, R.estacion FROM LM_Recorridos AS R
	WHERE R.Tren = @ID
	AND R.Momento BETWEEN @Inicio AND @Fin) AS Sub1

	INNER JOIN

	(SELECT I.estacionIni, I.estacionFin, I.Linea, I.Distancia FROM LM_Itinerarios AS I) AS Sub2

	ON Sub1.estacion = Sub2.estacionIni
	AND Sub1.Linea = Sub2.Linea

	RETURN @KilometrosRecorridos
	
END
GO

--------------------------------------------------------------------------------------------
--TEST

DECLARE @ID int
DECLARE @Inicio smalldatetime
DECLARE @Fin smalldatetime

SET @ID = 110
SET @Inicio = SMALLDATETIMEFROMPARTS(2017, 2, 24, 13, 58)
SET @Fin = SMALLDATETIMEFROMPARTS(2017, 2, 25, 23, 00)

SELECT Sub1.Linea, Sub1.estacion, Sub2.estacionFin, Sub2.Distancia FROM

	(SELECT R.Linea, R.estacion FROM LM_Recorridos AS R
	WHERE R.Tren = @ID
	AND R.Momento BETWEEN @Inicio AND @Fin) AS Sub1

	INNER JOIN

	(SELECT I.estacionIni, I.estacionFin, I.Linea, I.Distancia FROM LM_Itinerarios AS I) AS Sub2

	ON Sub1.estacion = Sub2.estacionIni
	AND Sub1.Linea = Sub2.Linea

--------------------------------------------------------------------------------------------

--6. Escribe una función de valores de tabla a la que se pase como parámetros un intervalo de tiempo (inicio y fin)
--y nos devuelva, para cada tren, su ID, la fecha de entrada en servicio, el número de kilómetros recorridos,
--su velocidad media y el número de estaciones por las que ha pasado en dicho intervalo.
--Considera la posibilidad de usar una función de múltiples instrucciones.

--DUDA: Aqui me pone error division por 0 cuando divido los tiempos como debe ser

GO
CREATE OR ALTER FUNCTION FNInfoTrenes (@Inicio smalldatetime, @Fin smalldatetime) RETURNS TABLE AS
RETURN

SELECT Sub1.ID,
       Sub1.FechaEntraServicio,
	   COUNT(*) AS NumeroEstaciones,
	   SUM(Sub2.Distancia) AS DistanciaRecorrida,
	   SUM(Sub2.Distancia)/SUM
	   (DATEPART(hour, Sub2.TiempoEstimado)+
	   DATEPART(minute, Sub2.TiempoEstimado) /60 +
	   (DATEPART(second, Sub2.TiempoEstimado)) /3600 ) AS VelocidadMedia
	   --ESTO ESTA MAL, ESTOY SUMANDO HORAS CON MINUTOS CON SEGUNDOS, EN LUGAR DE
	   -- HORAS + MINUTOS /60 + SEGUNDOS /3600 PARA HACER KILOMETROS/HORA LA VELOCIDAD
	   --PERO LO HE DEJADO ASI PARA SEGUIR AVANZANDO EL EJERCICIO

	   FROM

	(SELECT T.ID, T.FechaEntraServicio, R.Linea, R.estacion FROM LM_Recorridos AS R
	INNER JOIN LM_Trenes AS T ON R.Tren = T.ID
	AND R.Momento BETWEEN @Inicio AND @Fin) AS Sub1

	INNER JOIN

	(SELECT I.estacionIni, I.estacionFin, I.Linea, I.Distancia, I.TiempoEstimado FROM LM_Itinerarios AS I) AS Sub2

	ON Sub1.estacion = Sub2.estacionIni
	AND Sub1.Linea = Sub2.Linea

	GROUP BY Sub1.ID, Sub1.FechaEntraServicio

GO

-------------------------------------------------------------------------------------------
--TEST

DECLARE @Inicio smalldatetime
DECLARE @Fin smalldatetime

SET @Inicio = SMALLDATETIMEFROMPARTS(2017, 2, 24, 13, 58)
SET @Fin = SMALLDATETIMEFROMPARTS(2017, 2, 25, 23, 00)

SELECT Sub1.ID,
       Sub1.FechaEntraServicio,
	   COUNT(*) AS NumeroEstaciones,
	   SUM(Sub2.Distancia) AS DistanciaRecorrida,
	   SUM(Sub2.Distancia)/SUM
	   (DATEPART(hour, Sub2.TiempoEstimado) * 3600 +
	   DATEPART(minute, Sub2.TiempoEstimado) * 60 +
	   DATEPART(second, Sub2.TiempoEstimado)) / 3600 AS VelocidadMedia
	   --ESTO ESTA MAL, ESTOY SUMANDO HORAS CON MINUTOS CON SEGUNDOS, EN LUGAR DE
	   -- HORAS + MINUTOS /60 + SEGUNDOS /3600 PARA HACER KILOMETROS/HORA LA VELOCIDAD
	   --PERO LO HE DEJADO ASI PARA SEGUIR AVANZANDO EL EJERCICIO

	   FROM

	(SELECT T.ID, T.FechaEntraServicio, R.Linea, R.estacion FROM LM_Recorridos AS R
	INNER JOIN LM_Trenes AS T ON R.Tren = T.ID
	AND R.Momento BETWEEN @Inicio AND @Fin) AS Sub1

	INNER JOIN

	(SELECT I.estacionIni,
			I.estacionFin,
			I.Linea,
			I.Distancia,
			I.TiempoEstimado
			FROM LM_Itinerarios AS I) AS Sub2

	ON Sub1.estacion = Sub2.estacionIni
	AND Sub1.Linea = Sub2.Linea

	GROUP BY Sub1.ID, Sub1.FechaEntraServicio

------------------------------------------------------------------

--7. Escribe una función de valores de tabla a la que se pase como parámetros el ID de una estación y una fecha
--y nos devuelva una tabla con el número de pasajeros que han entrado o salido del metro por esa estación en cada
--una de las horas, es decir, entre las 00:00 y las 00:59, entre las 01:00 y las 01:59, etc.

GO
CREATE FUNCTION FNPasajerosPorEstacionYHora(@IDEstacion int, @Fecha date) RETURNS TABLE AS
RETURN

	SELECT * FROM LM_Viajes AS V
	WHERE V.IDEstacionEntrada = @IDEstacion 
	      AND @Fecha = V.MomentoEntrada

	INNER JOIN 

GO

---------------------------------------------------------------
--TEST

DECLARE @Fecha date
SET @Fecha = DATEFROMPARTS(2017, 2, 24)

--SELECT Sub1.IDEstacionEntrada, Sub1.IDTarjeta, Sub1.MomentoEntrada, Sub2.IDEstacionSalida, Sub2.IDTarjeta, Sub2.MomentoSalida FROM 

--A
SELECT * FROM LM_Viajes AS V
WHERE (V.IDEstacionEntrada = 5
	  AND @Fecha = CAST(V.MomentoEntrada AS date)) OR
	  (V.IDEstacionSalida = 5
	  AND @Fecha = CAST(V.MomentoSalida AS date))

--Se me ocurre meterlo dentro de un while y que vaya aumentando las horas e insertando records (Seria una funcion
--de multiples tablas

--8. La empresa del metro está haciendo un estudio sobre los precios de los viajes. En concreto, quiere igualar
--la cantidad de dinero que ingresa el metro en cada una de las zonas. Tomando como base el precio de la zona 1,
--queremos una función a la que se pase como parámetro una zona y nos devuelva el precio que deberían tener los
--billetes de esa zona para recaudar lo mismo que se recauda en la zona 1, teniendo en cuenta el número der
--pasajeros que terminan sus viajes en esa zona y en la zona 1.
 


--Ejemplo: Supongamos que en la zona 1 terminan sus viajes 5.000 pasajeros y el precio del billete es 1€, con lo
--que se recaudan 5.000€. Si en la zona 2 son sólo 4.000 pasajeros, ¿cuánto tendría que valer el billete de esa
--zona para igualar la recaudación de 5.000 €?



--9.- Escribe una función escalar a la que se pase como parámetros el ID de un pasajero y nos devuelva cuál es
--su estación favorita, por la que más pasa.


GO
CREATE FUNCTION FNEstacionFavorita(@IDPasajero int)
RETURNS int
BEGIN

	--Problemas: 
	--Si hay dos con el mismo numero de vistias coge el primero. Por lo visto no es problema, no es el objetivo del ejercicio entrar en ese detalle

	DECLARE @Estacion int
	--Tiene que haber una mejor manera de coger la estacion con las mayores visitas
		SELECT TOP 1 @Estacion = Estacion FROM
		(SELECT ISNULL(Sub1.IDEstacionEntrada, Sub2.IDEstacionSalida) AS Estacion, ISNULL(Sub1.Veces, 0) + ISNULL(Sub2.Veces, 0) AS Veces
		FROM
			(SELECT IDEstacionEntrada, COUNT(V.IDTarjeta) AS Veces FROM LM_Viajes AS V
			INNER JOIN LM_Tarjetas AS T ON V.IDTarjeta = T.ID
			WHERE T.IDPasajero = @IDPasajero
			GROUP BY IDEstacionEntrada) AS Sub1

		FULL JOIN

			(SELECT IDEstacionSalida, COUNT(V.IDTarjeta) AS Veces FROM LM_Viajes AS V
			INNER JOIN LM_Tarjetas AS T ON V.IDTarjeta = T.ID
			WHERE T.IDPasajero = @IDPasajero
			GROUP BY IDEstacionSalida) AS Sub2

		ON Sub1.IDEstacionEntrada = Sub2.IDEstacionSalida) AS Sub3
		ORDER BY Veces DESC

	RETURN @Estacion

END


GO
----------------------------------------------------------
--TEST (Se comprueba para el pasajero de ID = 5)

--La consulta del FULL JOIN me devuelve las estaciones de entrada por las que ha pasado alguna vez
--Y las estaciones de salida por las que ha pasado alguna vez
--Si no ha pasado por alguna en ninguno de los dos casos, NO me la devuelve

DECLARE @Estacion int

	--Tiene que haber una mejor manera de coger la estacion con las mayores visitas
		SELECT TOP 1 Estacion FROM
		(SELECT ISNULL(Sub1.IDEstacionEntrada, Sub2.IDEstacionSalida) AS Estacion, ISNULL(Sub1.Veces, 0) + ISNULL(Sub2.Veces, 0) AS Veces
		FROM
			(SELECT IDEstacionEntrada, COUNT(V.IDTarjeta) AS Veces FROM LM_Viajes AS V
			INNER JOIN LM_Tarjetas AS T ON V.IDTarjeta = T.ID
			WHERE T.IDPasajero = 5
			GROUP BY IDEstacionEntrada) AS Sub1

		FULL JOIN

			(SELECT IDEstacionSalida, COUNT(V.IDTarjeta) AS Veces FROM LM_Viajes AS V
			INNER JOIN LM_Tarjetas AS T ON V.IDTarjeta = T.ID
			WHERE T.IDPasajero = 5
			GROUP BY IDEstacionSalida) AS Sub2

		ON Sub1.IDEstacionEntrada = Sub2.IDEstacionSalida) AS Sub3
		ORDER BY Veces DESC