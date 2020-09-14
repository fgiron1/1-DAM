--1. Indica el número de estaciones por las que pasa cada línea

SELECT L.ID, COUNT(I.NumOrden) AS [Cantidad estaciones] FROM LM_Lineas AS L
INNER JOIN LM_Itinerarios AS I ON  L.ID = I.Linea --TODAS LAS LINEAS ACABAN EN LA ESTACIÓN EN LA QUE EMPIEZAN, NO HAY NINGUNA QUE TENGA RELACIONADA SU ULTIMA ESTACION CON NULL. Si en primera instancia va de la 1 a la 3, al final irá de (última) a la 1
INNER JOIN LM_Estaciones AS E ON E.ID = I.estacionIni
GROUP BY L.ID

--2. Indica el número de trenes diferentes que han circulado en cada línea

SELECT L.ID, COUNT(DISTINCT T.ID) AS Trenes FROM LM_Recorridos AS R
INNER JOIN LM_Lineas AS L ON R.Linea = L.ID
INNER JOIN LM_Trenes AS T ON T.ID = R.Tren
GROUP BY L.ID
--¿Por qué me sale lo mismo da igual si pongo T.ID o R.Tren en el COUNT?

--3. Indica el número medio de trenes de cada clase que pasan al día por cada estación.
-------------------------------

GO
CREATE VIEW Hey1 AS

SELECT Hey.ID, Hey.Tipo, AVG(Hey.[Cantidad trenes]) AS Media FROM
(SELECT E.ID, T.Tipo, CONVERT(date, R.Momento) AS Dia, COUNT(R.Tren) AS [Cantidad trenes] FROM LM_Trenes AS T
INNER JOIN LM_Recorridos AS R ON T.ID = R.Tren
INNER JOIN LM_Estaciones AS E ON E.ID = R.estacion
GROUP BY T.Tipo, E.ID, CONVERT(date, R.Momento)) AS Hey
GROUP BY Hey.ID, Hey.Tipo

GO

CREATE VIEW Hey2 AS 

SELECT E.ID, T.Tipo, CONVERT(date, R.Momento) AS Dia, COUNT(R.Tren) AS [Cantidad trenes] FROM LM_Trenes AS T
INNER JOIN LM_Recorridos AS R ON T.ID = R.Tren
INNER JOIN LM_Estaciones AS E ON E.ID = R.estacion
GROUP BY T.Tipo, E.ID, CONVERT(date, R.Momento)
GO

SELECT Hey1.ID, Hey1.Tipo, Hey2.Dia, Hey1.Media FROM Hey1
INNER JOIN Hey2 ON Hey1.ID = Hey2.ID 
					--Cada ID aparece 2 veces en Hey1, y aparece más veces en Hey2.
					--Yo estoy diciendo que se unan cuando coincidan las dos, y claro
					--Si en un sitio hay 3 y en otro hay 8, van a coincidir en 3, porque
					-- en la primera tabla es que no hay más pa coincidir. Pues yo quiero ponerle
					-- a esas 3 coincidencias las columnas especificadas en Hey2

--4. Calcula el tiempo necesario para recorrer una línea completa, contando con el tiempo estimado de cada
--itinerario y considerando que cada parada en una estación dura 30 s.

SELECT L.ID, 
CONVERT
(time,
	DATEADD(s, SUM(DATEDIFF(s, 0, I.TiempoEstimado)) + (COUNT(E.ID) * 30), 0)
) AS Tiempo
--PASA EL RATON POR ENCIMA DE LAS FUNCIONES
FROM LM_Lineas AS L
INNER JOIN LM_Itinerarios AS I ON L.ID = I.Linea
INNER JOIN LM_Estaciones AS E ON E.ID = I.estacionIni
GROUP BY L.ID

--5. Indica el número total de pasajeros que entran (a pie) cada día por cada estación
--y los que salen del metro en la misma.


GO

CREATE VIEW GenteEntrandoCadaDia AS

SELECT COUNT(P.ID) AS Entrando, V.IDEstacionEntrada, CONVERT(date, V.MomentoEntrada) AS Dia FROM LM_Pasajeros AS P
INNER JOIN LM_Tarjetas AS T ON T.IDPasajero = P.ID
INNER JOIN LM_Viajes AS V ON V.IDTarjeta = T.ID
INNER JOIN LM_Estaciones AS E ON E.ID = V.IDEstacionEntrada
GROUP BY V.IDEstacionEntrada, CONVERT(date, V.MomentoEntrada)

GO

GO

CREATE VIEW GenteSaliendoCadaDia AS

SELECT COUNT(P.ID) AS Saliendo, V.IDEstacionSalida, CONVERT(date, V.MomentoEntrada) AS Dia FROM LM_Pasajeros AS P
INNER JOIN LM_Tarjetas AS T ON T.IDPasajero = P.ID
INNER JOIN LM_Viajes AS V ON V.IDTarjeta = T.ID
INNER JOIN LM_Estaciones AS E ON E.ID = V.IDEstacionEntrada
GROUP BY V.IDEstacionSalida, CONVERT(date, V.MomentoEntrada)

GO

SELECT  GenteEntrandoCadaDia.IDEstacionEntrada AS [ID Estacion], --Da igual si es IDEstacionEntrada o IDEstacionSalida
		GenteEntrandoCadaDia.Entrando, GenteSaliendoCadaDia.Saliendo,
		GenteEntrandoCadaDia.Dia FROM 

GenteEntrandoCadaDia
INNER JOIN
GenteSaliendoCadaDia

ON GenteEntrandoCadaDia.IDEstacionEntrada = GenteSaliendoCadaDia.IDEstacionSalida
AND GenteEntrandoCadaDia.Dia = GenteSaliendoCadaDia.Dia


--6. Calcula la media de kilómetros al día que hace cada tren. Considera únicamente los días que ha estado en servicio
--Arreglar
SELECT R.Tren, CONVERT(date, R.Momento) AS Dia, AVG(I.Distancia) AS [Distancia media] FROM LM_Recorridos AS R
INNER JOIN LM_Lineas AS L ON L.ID = R.Linea
INNER JOIN LM_Itinerarios AS I ON I.Linea = L.ID
GROUP BY R.Tren, CONVERT(date, R.Momento)
ORDER BY R.Tren

--GROUP BY DE CONVERT(date, R.Momento), R.Tren

-- AVG de 

--7. Calcula cuál ha sido el intervalo de tiempo en que más personas registradas han estado en el metro al mismo tiempo.
--Considera intervalos de una hora (de 12:00 a 12:59, de 13:00 a 13:59, etc). Si hay varios momentos
--con el número máximo de personas, muestra el más reciente.

--Me gustaría hacer 25 llamadas a la función y después hacerle el MAX a gente y ponerle el intervalo correspondiente

SELECT A.Intervalo FROM 

FNGentePorHora(17) AS A
INNER JOIN
FNGentePorHora(18) AS B
ON A.Intervalo + 1 = B.Intervalo





--Quiero que esta función me devuelva dos columnas, la cantidad de gente que ha habido en el momento y la hora en la que han estado

GO

CREATE FUNCTION FNGentePorHora (@Hora AS int) RETURNS TABLE AS
RETURN
(SELECT COUNT(P.ID) AS Gente, DATEPART(hour, V.MomentoEntrada) AS Intervalo FROM LM_Viajes AS V
INNER JOIN LM_Tarjetas AS T ON T.ID = V.IDTarjeta
INNER JOIN LM_Pasajeros AS P ON P.ID = T.IDPasajero
WHERE DATEPART(hour, V.MomentoEntrada) = @Hora AND DATEPART(hour, V.MomentoSalida) = @Hora
GROUP BY DATEPART(hour, V.MomentoEntrada), DATEPART(hour, V.MomentoSalida))

GO

SELECT * FROM FNGentePorHora(17)
SELECT * FROM FNGentePorHora(16)
SELECT * FROM FNGentePorHora(18)

--Tendria que contar la gente de cada viaje y despues sumarlas y agruparlas por horas

SELECT SUM(Sub1.Gente) FROM
(SELECT V.ID, COUNT(P.ID) AS Gente, DATEPART(hour, V.MomentoEntrada) AS [Hora entrada] FROM LM_Viajes AS V
INNER JOIN LM_Tarjetas AS T ON T.ID = V.IDTarjeta
INNER JOIN LM_Pasajeros AS P ON P.ID = T.IDPasajero
GROUP BY V.ID, DATEPART(hour, V.MomentoEntrada)) AS Sub1
GROUP BY Sub1.ID

--8. Calcula el dinero gastado por cada usuario en el mes de febrero de 2017.
--El precio de un viaje es el de la zona más cara que incluya.Incluye a los que no han viajado.

GO
CREATE FUNCTION FNDineroGastadoMensual (@Mes AS int) RETURNS TABLE AS
RETURN
(SELECT P.ID, 
FORMAT(SUM(ISNULL(V.Importe_Viaje, 0)), 'C', 'es-ES') AS Dinero,
MONTH(V.MomentoEntrada) AS Mes FROM LM_Viajes AS V

LEFT JOIN LM_Tarjetas AS T ON T.ID = V.IDTarjeta
RIGHT JOIN LM_Pasajeros AS P ON P.ID = T.IDPasajero	

WHERE MONTH(V.MomentoEntrada) = @Mes
GROUP BY P.ID, MONTH(V.MomentoEntrada)
)
GO


SELECT * FROM FNDineroGastadoMensual(2) --Resulta que todo el mundo solo ha viajado en febrero

SELECT P.ID, SUM(V.Importe_Viaje) AS Dinero, MONTH(V.MomentoEntrada) AS Mes FROM LM_Viajes AS V
LEFT JOIN LM_Tarjetas AS T ON T.ID = V.IDTarjeta --Parece que todos los que están almacenados son los que han viajado
RIGHT JOIN LM_Pasajeros AS P ON P.ID = T.IDPasajero	--Ni poniendo FULL JOIN en los dos me devuelve ningun NULL
WHERE MONTH(V.MomentoEntrada) = 2
GROUP BY P.ID, MONTH(V.MomentoEntrada)

SELECT V.MomentoEntrada FROM LM_Viajes AS V
FULL JOIN LM_Tarjetas AS T ON T.ID = V.IDTarjeta
FULL JOIN LM_Pasajeros AS P ON P.ID = T.IDPasajero	
ORDER BY P.ID

--9. Calcula el tiempo medio diario que cada pasajero pasa en el sistema de metro y el número de veces que accede al mismo.

--3 COLUMNAS: La ID del pasajero, tiempo medio que pasa dentro, número de veces que accede al metro
--Tiempo medio que pasa cada pasajero en el metro es la suma de los tiempos que está en el mismo día en el metro (tiempo total diario en el metro) y a eso se le hace la media


GO
CREATE VIEW TiempoMedio AS

SELECT Sub1.ID, 
CONVERT(time,
	DATEADD(s, AVG(Sub1.[Tiempo diario]), 0)
		)
AS [Tiempo Medio] FROM

(SELECT SUM(DATEDIFF(s, V.MomentoEntrada, V.MomentoSalida)) AS [Tiempo diario], P.ID,
CONVERT(date, V.MomentoEntrada) AS Dia
FROM LM_Pasajeros AS P
INNER JOIN LM_Tarjetas AS T ON T.IDPasajero = P.ID
INNER JOIN LM_Viajes AS V ON V.IDTarjeta = T.ID
GROUP BY P.ID, CONVERT(date, V.MomentoEntrada)) AS Sub1
GROUP BY Sub1.ID

GO

GO
CREATE VIEW AccesosMedio AS

SELECT Sub2.ID, AVG(Sub2.Accesos) AS Accesos FROM
(SELECT P.ID, COUNT(V.IDEstacionEntrada) AS Accesos, CONVERT(date, V.MomentoEntrada) AS Dia FROM LM_Pasajeros AS P
INNER JOIN LM_Tarjetas AS T ON T.IDPasajero = P.ID
INNER JOIN LM_Viajes AS V ON V.IDTarjeta = T.ID
GROUP BY P.ID, CONVERT(date, V.MomentoEntrada)) AS Sub2
GROUP BY Sub2.ID

GO

SELECT TiempoMedio.ID, TiempoMedio.[Tiempo medio], AccesosMedio.Accesos FROM 

TiempoMedio INNER JOIN AccesosMedio

ON TiempoMedio.ID = AccesosMedio.ID

GO