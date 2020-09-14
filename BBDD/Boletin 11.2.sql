USE LeoMetro

--0. La dimisión de Esperanza Aguirre ha causado tal conmoción entre los directivos de LeoMetro que han decidido
--conceder una amnistía a todos los pasajeros que tengan un saldo negativo en sus tarjetas.
--Crea un procedimiento que racargue la cantidad necesaria para dejar a 0 el saldo de las tarjetas que tengan
--un saldo negativo y hayan sido recargadas al menos una vez en los últimos dos meses.
--Ejercicio elaborado en colaboración con Sefran.

BEGIN TRANSACTION
GO
CREATE OR ALTER PROCEDURE SaldoNegativoA0 
AS
--Es buena practica y se deberia poner en todos los procedimientos BEGIN TRANSACTION al principio de cada procedimiento
--Como los procedimientos admiten instrucciones DDL (Instrucciones que permiten modificar el estado de la bbdd, es
--decir, DROP, INSERT, CREATE...) , pues no vaya a ser que hubieramos puesto un parametro mal o lo que sea al 
--ejecutarlo y la liemos, asi que esta bien siempre dar la opcion de poder hacer rollback o commit dps
--de ejecutar un procedimiento
BEGIN TRANSACTION

INSERT INTO LM_Recargas(ID, ID_Tarjeta, Cantidad_Recarga, Momento_Recarga, SaldoResultante)

--El inner join hace que solo tenga en cuenta las tarjetas que han tenido recargas,
--y me ahorra algunas operaciones al no comparar, en la segunda condicion del WHERE,
--NULL con CURRENT_TIMESTAMP, porque una de las posibilidades de tarjetas que han tenido
--una recarga hace mas de 2 meses es, en particular, tarjetas que no han tenido recarga nunca

SELECT NEWID(), T.ID, T.Saldo * (-1), CURRENT_TIMESTAMP, 0
FROM LM_Tarjetas AS T
INNER JOIN LM_Recargas AS R ON R.ID_Tarjeta = T.ID
	 WHERE T.Saldo < 0
	 AND DATEDIFF(day, R.Momento_Recarga, CURRENT_TIMESTAMP) <= 62
	 --Se suponen meses de 31 días

--Creo que para actualizar la informacion de las tarjetas en LM_Tarjetas voy a tener que usar una funcion
--Porque me huelo que esto de aqui abajo no funciona
UPDATE LM_Tarjetas
SET Saldo = R.SaldoResultante
FROM LM_Recargas AS R
WHERE R.ID_Tarjeta = LM_Tarjetas.ID


SELECT * FROM LM_Recargas
SELECT * FROM LM_Tarjetas

GO


--1. Crea un procedimiento RecargarTarjeta que reciba como parámetros el ID de una tarjeta y un importe y
--actualice el saldo de la tarjeta sumándole dicho importe, además de grabar la correspondiente recarga

--CREO QUE ESTA BIEN


GO
CREATE OR ALTER PROCEDURE RecargarTarjeta2 @IDTarjeta int, @Importe smallmoney
AS
BEGIN TRANSACTION

INSERT INTO LM_Recargas(ID, ID_Tarjeta, Cantidad_Recarga, Momento_Recarga, SaldoResultante)
SELECT NEWID(), @IDTarjeta, @Importe, CURRENT_TIMESTAMP, T.Saldo + @Importe
FROM LM_Tarjetas AS T
WHERE T.ID = @IDTarjeta

UPDATE LM_Tarjetas
SET Saldo = (SELECT R.SaldoResultante
			FROM LM_Recargas AS R
			WHERE R.ID_Tarjeta = @IDTarjeta)
WHERE ID = @IDTarjeta

GO

--2. Crea un procedimiento almacenado llamado PasajeroSale que reciba como parámetros el ID de una tarjeta,
--el ID de una estación y una fecha/hora (opcional). El procedimiento se llamará cuando un pasajero pasa su tarjeta
--por uno de los tornos de salida del metro. Su misión es grabar la salida en la tabla LM_Viajes. Para ello deberá
--localizar la entrada que corresponda, que será la última entrada correspondiente al mismo pasajero y hará un
--update de las columnas que corresponda. Si no existe la entrada, grabaremos una nueva fila en LM_Viajes dejando
--a NULL la estación y el momento de entrada.
--Si se omite el parámetro de la fecha/hora, se tomará la actual.
GO
DECLARE @Fecha1 date
SET @Fecha1 = DATEFROMPARTS(2017,5,3)

EXECUTE PasajeroSale 2, 8, @Fecha1

--Este esta corregido

GO
CREATE OR ALTER PROCEDURE PasajeroSale @IDTarjeta int, @IDEstacion smallint, @FechaHora smalldatetime = NULL
AS
BEGIN TRANSACTION

--Si la salida es NULL, significa que todo marcha bien; ha entrado y aun no ha salido
--Si no es NULL, significa que la fila se refiere a un viaje anterior de ese pasajero
--que ya ha finalizado, y que la entrada del viaje más reciente no se ha registrado correctamente
--Por lo que creamos una nueva fila con la entrada a NULL

SELECT @FechaHora = ISNULL(@FechaHora, CURRENT_TIMESTAMP)

--Guardar MomentoSalida y MomentoEntrada en variables y evito subconsultas

IF(SELECT TOP 1 MomentoSalida FROM
   LM_Viajes AS V
   WHERE IDTarjeta = @IDTarjeta
   ORDER BY MomentoEntrada DESC) IS NULL

   BEGIN
		UPDATE LM_Viajes
		SET IDEstacionSalida = @IDEstacion,
			MomentoSalida = @FechaHora
		WHERE IDTarjeta = @IDTarjeta
		AND MomentoEntrada = (SELECT TOP 1 MomentoEntrada
							  FROM LM_Viajes
							  WHERE IDTarjeta = @IDTarjeta
							  ORDER BY MomentoEntrada DESC)

		--Poner el importe
	END

ELSE

	BEGIN
		INSERT INTO LM_Viajes(IDTarjeta, IDEstacionEntrada, IDEstacionSalida, MomentoEntrada, MomentoSalida)
		SELECT @IDTarjeta, NULL, @IDEstacion, NULL, @FechaHora
	END
	

GO




--3. A veces, un pasajero reclama que le hemos cobrado un viaje de forma indebida. Escribe un procedimiento que
--reciba como parámetro el ID de un pasajero y la fecha y hora de la entrada en el metro y anule ese viaje,
--actualizando además el saldo de la tarjeta que utilizó.

--CREO QUE ESTA BIEN

GO
CREATE PROCEDURE AnularViaje @IDPasajero int, @Momento smalldatetime
AS

DECLARE @IDTarjeta int, @ImporteViaje smallmoney

--Se almacena la ID de tarjeta que le corresponde al pasajero cuya ID es @IDPasajero
SELECT @IDTarjeta = T.ID FROM LM_Pasajeros AS P
INNER JOIN LM_Tarjetas AS T ON T.IDPasajero = P.ID

--Se almacena el importe del viaje que se le debe recargar en la tarjeta
SELECT @ImporteViaje = Importe_Viaje FROM LM_Viajes
WHERE IDTarjeta = @IDTarjeta AND
MomentoEntrada = @Momento

--Se elimina el viaje reclamado
DELETE FROM LM_Viajes
WHERE IDTarjeta = @IDTarjeta AND
MomentoEntrada = @Momento

--Suponiendo que la actualización del saldo tenga que verse reflejada en las recargas también:
INSERT INTO LM_Recargas(ID, ID_Tarjeta, Cantidad_Recarga, Momento_Recarga, SaldoResultante)
SELECT NEWID(), @IDTarjeta, @ImporteViaje, CURRENT_TIMESTAMP, T.Saldo + @ImporteViaje  FROM LM_Recargas AS R
INNER JOIN LM_Tarjetas AS T ON T.ID = R.ID_Tarjeta


--Se actualiza el saldo de la tarjeta utilizando el valor del saldo resultante obtenido en la tabla recargas
UPDATE LM_Tarjetas
SET Saldo = (SELECT SaldoResultante
			 FROM LM_Recargas
			 WHERE ID_Tarjeta = @IDTarjeta)
WHERE ID = @IDTarjeta


GO


--4. La empresa de Metro realiza una campaña de promoción para pasajeros fieles.

--Crea un procedimiento almacenado que recargue saldo a los pasajeros que cumplan determinados requisitos.
--Se recargarán N1 euros a los pasajeros que hayan consumido más de 30 euros en el mes anterior
--(considerar mes completo, del día 1 al fin) y N2 euros a los que hayan utilizado más de 10 veces alguna estación
--de las zonas 3 o 4.
--Los valores de N1 y N2 se pasarán como parámetros. Si se omiten, se tomará el valor 5.
--Ambos premios son excluyentes. Si algún pasajero cumple ambas condiciones se le aplicará la que suponga mayor
--bonificación de las dos.

--DUDA: Si se entra y se sale por una estación de la zona 3 o zona 4 son dos usos o uno?
--He supuesto que son dos usos. En cualquier caso, se cambia facilmente

GO
CREATE PROCEDURE RecargasRecompensa @N1 smallmoney = NULL, @N2 smallmoney = NULL
AS
BEGIN TRANSACTION

DECLARE @Condicion1 TABLE (
	IDTarjeta int
)

DECLARE @Condicion2 TABLE (
	IDTarjeta int
)

INSERT INTO @Condicion1
--Esta consulta me devuelve las tarjetas que han gastado mas de 30 euros en el mes anterior
	SELECT Sub1.IDTarjeta FROM
	(SELECT V.IDTarjeta, SUM(V.Importe_Viaje) AS GastoMensual FROM LM_Viajes AS V
	WHERE DATEDIFF(day, V.MomentoEntrada, CURRENT_TIMESTAMP) <= 31
	GROUP BY V.IDTarjeta) AS Sub1
	WHERE Sub1.GastoMensual > 30

INSERT INTO @Condicion2
    --Esta consulta me devuelve las tarjetas que han sido utilizadas mas de 10 veces en alguna estacion de las
	--zonas 3 o 4
	
	SELECT Sub1.IDTarjeta FROM 
	((SELECT V.IDTarjeta, COUNT(E.Zona_Estacion) AS UsosTarjetaEntrada
	FROM LM_Viajes AS V
	INNER JOIN LM_Estaciones AS E ON V.IDEstacionEntrada = E.ID
	WHERE E.Zona_Estacion = 3 OR E.Zona_Estacion = 4
	GROUP BY V.IDTarjeta) AS Sub1

	INNER JOIN

	(SELECT V.IDTarjeta, COUNT(E.Zona_Estacion) AS UsosTarjetaSalida
	FROM LM_Viajes AS V
	INNER JOIN LM_Estaciones AS E ON V.IDEstacionSalida = E.ID
	WHERE E.Zona_Estacion = 3 OR E.Zona_Estacion = 4
	GROUP BY V.IDTarjeta) AS Sub2

	ON Sub1.IDTarjeta = Sub2.IDTarjeta)

	WHERE Sub1.UsosTarjetaEntrada + Sub2.UsosTarjetaSalida > 10

IF @N1 IS NULL AND @N2 IS NULL

	BEGIN
		--Se les recarga 5 a 
		--SELECT IDTarjeta FROM @Condicion1
		--UNION
		--@Condicion2
	END

ELSE IF @N1 > @N2

	BEGIN
		--Se les recarga N1 a:
		--SELECT IDTarjeta FROM @Condicion1
		--Se les recarga N2 a:
		--SELECT C2.IDTarjeta FROM @Condicion2 AS C2
		--WHERE C2.IDTarjeta NOT IN (SELECT C1.IDTarjeta FROM @Condicion1 AS C1)
	END

ELSE IF @N2 > @N1

	BEGIN
		--Se les recarga N2 a:
		--SELECT IDTarjeta FROM @Condicion2
		--Se les recarga N1 a:
		--SELECT C1.IDTarjeta FROM @Condicion1 AS C1
		--WHERE C1.IDTarjeta NOT IN (SELECT C2.IDTarjeta FROM @Condicion2 AS C2)
	END

ELSE IF @N2 = @N1

	BEGIN
		--Se les recarga N1 a 
		--SELECT IDTarjeta FROM @Condicion1
		--UNION
		--@Condicion2
	END




	--Esta consulta nos confirma que no hay ningun pasajero sin tarjeta
	--y no hay ninguna tarjeta que no sea de algun pasajero
	SELECT T.ID AS Tarjeta, P.ID  FROM LM_Pasajeros AS P
	FULL JOIN LM_Tarjetas AS T ON T.IDPasajero = P.ID
GO



--5. Crea una función que nos devuelva verdadero si es posible que un pasajero haya subido a un tren en un
--determinado viaje. Se pasará como parámetro el código del viaje y la matrícula del tren.

--Este ejercicio tengo errores conceptuales y esta mal

--Supongamos que nos pasan la matricula '3292GPT' y nos pasan el viaje de ID 77.
--Averiguamos que el ID del tren que le corresponde es 112

SELECT * FROM LM_Trenes
SELECT * FROM LM_Recorridos
WHERE Tren = 112
--De todos los recorridos que ha hecho ese tren, tenemos que comprobar que alguno se corresponda con el viaje
--que nos pasan por parametros. En el caso de que sí sea, deberán aparecer dos filas: 
--Tren: 104; Linea: la que sea; Estacion: La estacion de entrada del viaje; Momento: El momento de entrada del viaje
--Tren: 104; Linea: la que sea; Estacion: La estacion de salida del viaje; Momento: El momento de salida del viaje

SELECT * FROM LM_Viajes

SELECT * FROM LM_Recorridos AS R
WHERE R.Momento = (SELECT MomentoEntrada
				    FROM LM_Viajes
					WHERE ID = 210)
AND  R.estacion = (SELECT IDEstacionEntrada
				   FROM LM_Viajes
				   WHERE ID = 210)

SELECT * FROM LM_Recorridos

--A VER SI HAY ALGUN VIAJE QUE TIENE 2017-02-26 03:25:05.000 COMO UN MOMENTO Y LA ESTACION 4

--Esta consulta me demuestra que hay viajes que tienen varios trenes, eso como puede ser?
SELECT DISTINCT V1.*, R.Tren FROM LM_Trenes AS T
INNER JOIN LM_Recorridos AS R ON R.Tren = T.ID
INNER JOIN LM_Estaciones AS E ON E.ID = R.estacion
INNER JOIN LM_Viajes AS V1 ON V1.IDEstacionEntrada = E.ID
INNER JOIN LM_Viajes AS V2 ON V2.IDEstacionSalida = E.ID

	 ORDER BY MomentoEntrada, MomentoSalida



SELECT * FROM LM_Viajes

--6. Crea un procedimiento SustituirTarjeta que Cree una nueva tarjeta y la asigne al mismo usuario y con el mismo
--saldo que otra tarjeta existente. El código de la tarjeta a sustituir se pasará como parámetro.

--Pero elimino la tarjeta anterior? O creo una mas y la asocio al mismo usuario
--Si decidiera eliminarla, en cualquier caso actualizaría primero todas las filas de las tablas
--en las que IDTarjeta es foreign key para el nuevo valor de la ID de tarjeta y posteriormente
--eliminaría la tarjeta antigua en la tabla tarjetas. Supongamos que no la elimino

--CREO QUE ESTA BIEN

GO
CREATE PROCEDURE SustituirTarjeta @IDASustituir int
AS

DECLARE @IDNueva int

INSERT INTO LM_Tarjetas(Saldo, IDPasajero)
SELECT Saldo, IDPasajero
FROM LM_Tarjetas
WHERE ID = @IDASustituir

--Almaceno el ultimo valor identity generado (La nueva ID de tarjeta)
SELECT @IDNueva = SCOPE_IDENTITY()

--Ahora tengo que actualizar todos los records de viajes y recargas donde este la ID de tarjeta anterior

UPDATE LM_Viajes
SET IDTarjeta = @IDNueva
WHERE IDTarjeta = @IDASustituir

UPDATE LM_Recargas
SET ID_Tarjeta = @IDNueva
WHERE ID_Tarjeta = @IDASustituir

--Ahora elimino la tarjeta antigua?

--DELETE FROM LM_Tarjetas
--WHERE ID = @IDASustituir

GO

--7. Las estaciones de la zona 3 tienen ciertas deficiencias, lo que nos ha obligado a introducir una serie de
--modificaciones en los trenes  para cumplir las medidas de seguridad.

--A consecuencia de estas modificaciones, la capacidad de los trenes se ha visto reducida en 6 plazas para los
--trenes de tipo 1 y 4 plazas para los trenes de tipo 2.

--Realiza un procedimiento al que se pase un intervalo de tiempo y modifique la capacidad de todos los trenes
--que hayan circulado más de una vez por alguna estación de la zona 3 en ese intervalo.