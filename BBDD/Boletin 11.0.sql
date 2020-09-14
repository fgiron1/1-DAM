--Crea una función inline que nos devuelva el número de estaciones que ha recorrido cada tren en un determinado
--periodo de tiempo. El principio y el fin de ese periodo se pasarán como parámetros
GO
CREATE FUNCTION FNEstacionesRecorridasEntre(@Entrada AS smalldatetime, @Salida AS smalldatetime) RETURNS TABLE AS
RETURN
SELECT T.ID, T.Matricula, COUNT(E.ID) AS Estaciones FROM LM_Trenes AS T
INNER JOIN LM_Recorridos AS R ON T.ID = R.Tren
INNER JOIN LM_Estaciones AS E ON E.ID = R.estacion
WHERE R.Momento BETWEEN @Entrada AND @Salida
GROUP BY T.ID, T.Matricula

--Comprobacion
DECLARE @tiempo1 smalldatetime
SET @tiempo1 = SMALLDATETIMEFROMPARTS(2017,02,26,02,25)
DECLARE @tiempo2 smalldatetime
SET @tiempo2 = SMALLDATETIMEFROMPARTS(2017,02,26,03,08)
SELECT * FROM FNEstacionesRecorridasEntre(@tiempo1, @tiempo2)
GO

--Crea una función inline que nos devuelva el número de veces que cada usuario ha entrado en el metro en un
--periodo de tiempo. El principio y el fin de ese periodo se pasarán como parámetros
GO
CREATE FUNCTION FNEntradasEnMetroEntre(@Principio AS smalldatetime, @Fin AS smalldatetime) RETURNS TABLE AS
RETURN
SELECT P.ID, P.Nombre, P.Apellidos, COUNT(V.MomentoEntrada) AS Entradas FROM LM_Pasajeros AS P
INNER JOIN LM_Tarjetas AS T ON P.ID = T.IDPasajero
INNER JOIN LM_Viajes AS V ON V.IDTarjeta = T.ID
WHERE V.MomentoEntrada BETWEEN @Principio AND @Fin
GROUP BY P.ID, P.Nombre, P.Apellidos
GO

--Comprobacion
DECLARE @tiempo1 smalldatetime
SET @tiempo1 = SMALLDATETIMEFROMPARTS(2017,02,26,02,25)
DECLARE @tiempo2 smalldatetime
SET @tiempo2 = SMALLDATETIMEFROMPARTS(2017,02,26,03,08)

SELECT * FROM FNEntradasEnMetroEntre(@tiempo1, @tiempo2)
ORDER BY ID

SELECT P.ID, P.Nombre, P.Apellidos, V.MomentoEntrada FROM LM_Pasajeros AS P
INNER JOIN LM_Tarjetas AS T ON P.ID = T.IDPasajero
INNER JOIN LM_Viajes AS V ON V.IDTarjeta = T.ID
ORDER BY V.MomentoEntrada


--Crea una función inline a la que pasemos la matrícula de un tren y una fecha de inicio y fin y nos devuelva una
--tabla con el número de veces que ese tren ha estado en cada estación, además del ID, nombre y dirección de la estación

--Como LM_Recorridos solo registra cuando se ha cambiado de estacion no cabe la posibilidad de que estemos contando
--las estaciones por duplicado (una vez al entrar y otra vez al salir)
GO
CREATE FUNCTION FNTrenEstacion(@Matricula AS char(7), @Inicio AS smalldatetime, @Fin AS smalldatetime) RETURNS TABLE AS
RETURN

SELECT Sub1.ID, Sub1.Matricula, Sub2.IDEstacion, Sub2.Denominacion, Sub2.Direccion, Sub1.Entradas FROM 
(SELECT T.ID, T.Matricula, E.ID AS IDEstacion, COUNT(E.ID) AS Entradas FROM LM_Trenes AS T
INNER JOIN LM_Recorridos AS R ON R.Tren = T.ID
INNER JOIN LM_Estaciones AS E ON E.ID = R.estacion
WHERE T.Matricula = @Matricula AND
      Momento BETWEEN @Inicio AND @Fin
GROUP BY T.ID, T.Matricula, E.ID) AS Sub1

INNER JOIN

(SELECT E.ID AS IDEstacion, E.Denominacion, E.Direccion FROM LM_Trenes AS T
INNER JOIN LM_Recorridos AS R ON R.Tren = T.ID
INNER JOIN LM_Estaciones AS E ON E.ID = R.estacion
WHERE T.Matricula = @Matricula AND
      Momento BETWEEN @Inicio AND @Fin) AS Sub2

ON Sub1.IDEstacion = Sub2.IDEstacion
GO
--Comprobacion
DECLARE @tiempo1 smalldatetime
SET @tiempo1 = SMALLDATETIMEFROMPARTS(2017,02,26,02,25)
DECLARE @tiempo2 smalldatetime
SET @tiempo2 = SMALLDATETIMEFROMPARTS(2017,02,26,03,08)
DECLARE @matricula char(7)
SET @matricula = '0100FRY'
SELECT * FROM FNTrenEstacion(@matricula, @tiempo1, @tiempo2)
SELECT * FROM LM_Trenes


--Crea una función inline que nos diga el número de personas que han pasado por una estacion en un periodo de tiempo.
--Se considera que alguien ha pasado por una estación si ha entrado o salido del metro por ella. El principio y el fin
--de ese periodo se pasarán como parámetros

GO
CREATE FUNCTION FNPersonasPorEstacion(@Inicio AS smalldatetime, @Fin AS smalldatetime) RETURNS TABLE AS
RETURN

SELECT Sub1.IDEntrada AS ID,  (ISNULL(Sub1.PersonasEntrada, 0) + ISNULL(Sub2.PersonasSalida, 0)) AS Personas FROM 

(SELECT E.ID AS IDEntrada, COUNT(V.ID) AS PersonasEntrada FROM LM_Viajes AS V
INNER JOIN LM_Estaciones AS E ON E.ID = V.IDEstacionEntrada
WHERE V.MomentoEntrada BETWEEN @Inicio AND @Fin
GROUP BY E.ID) AS Sub1

FULL JOIN 


(SELECT E.ID AS IDSalida, COUNT(V.MomentoSalida) AS PersonasSalida FROM LM_Viajes AS V
INNER JOIN LM_Estaciones AS E ON E.ID = V.IDEstacionSalida
WHERE V.MomentoSalida BETWEEN @Inicio AND @Fin
GROUP BY E.ID) AS Sub2

ON Sub1.IDEntrada = Sub2.IDSalida

GO

DROP Function FNPersonasPorEstacion

--Creo que esta mal porque el cambio se hizo para quitar a la gente que entra y sale dentro del periodo especificado
--, que se contaba dos veces, una en cada subconsulta. Pero resulta que me ha dejado de contar 4 persona en la estacion 11
--Es imposible que pase a contar ahora 0 personas en la estacion 11,
--Comprobacion
DECLARE @tiempo1 smalldatetime
SET @tiempo1 = SMALLDATETIMEFROMPARTS(2017,02,26,02,00)
DECLARE @tiempo2 smalldatetime
SET @tiempo2 = SMALLDATETIMEFROMPARTS(2017,02,26,03,00)

SELECT * FROM FNPersonasPorEstacion(@tiempo1, @tiempo2)

--Crea una función inline que nos devuelva los kilómetros que ha recorrido cada tren en un periodo de tiempo.
--El principio y el fin de ese periodo se pasarán como parámetros


--Me gustaria tener una tabla que tenga una columna que sea estacionSiguiente, siendo esa la siguiente estacion
--a la que ha acudido el tren. Es decir, la estacion que le corresponda momento siguiente al de la primera estacion.
--Seria SELECT TOP 1 WHERE Momento > momento de estacion inicial

SELECT * FROM LM_Trenes AS T
INNER JOIN LM_Recorridos AS R ON T.ID = R.Tren
INNER JOIN LM_Lineas AS L ON L.ID = R.Linea
INNER JOIN LM_Itinerarios AS I ON I.Linea = R.Linea

SELECT * FROM LM_Recorridos AS R

GO
CREATE FUNCTION FNSiguienteTiemposo(@Momento AS smalldatetime) RETURNS TABLE AS
RETURN
SELECT TOP 1 Momento FROM LM_Recorridos
WHERE Momento > @Momento
GO

SELECT R1.estacion, R2.estacion, R1.Momento FROM LM_Recorridos AS R1
INNER JOIN LM_Recorridos AS R2 ON R2.Momento = dbo.FNSiguienteTiempo(R1.Momento)


--La columna que necesito no es mas que coger la estacion de un join entre las
--Hacer un join entre la tabla de los momentos posteriores y recorridos y coger la estacion de la primera pero en el ON
--que sea que coincida EL NEXTMOMENTO DE LA PRIMERA CON EL MOMENTO DE LA SEGUNDA
--DECLARE @tiempoActual smalldatetime
--DECLARE @i tinyint
--SET @i = 0

--WHILE i < 10
--BEGIN
--	SET @i = @i + 1

--END


GO
CREATE FUNCTION FNKilometrosRecorridos(@Inicio AS smalldatetime, @Fin AS smalldatetime) RETURNS TABLE AS
RETURN
SELECT * FROM LM_Trenes AS T
INNER JOIN LM_Recorridos AS R ON T.ID = R.Tren
INNER JOIN LM_Lineas AS L ON L.ID = R.Linea
INNER JOIN LM_Itinerarios AS I ON I.Linea = R.Linea

SELECT * FROM LM_Recorridos
ORDER BY Tren, Momento
SELECT * FROM LM_Itinerarios
ORDER BY Linea
GO
--Crea una función inline que nos devuelva el número de trenes que ha circulado por cada línea en un periodo de tiempo.
--El principio y el fin de ese periodo se pasarán como parámetros. Se devolverá el ID, denominación y color de la línea



--Crea una función inline que nos devuelva el tiempo total que cada usuario ha pasado en el metro en un periodo de tiempo.
--El principio y el fin de ese periodo se pasarán como parámetros. Se devolverá ID, nombre y apellidos del pasajero.
--El tiempo se expresará en horas y minutos.

