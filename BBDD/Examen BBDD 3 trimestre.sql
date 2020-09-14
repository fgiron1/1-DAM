--Ejercicio 1 (2 points)
--Escribe una función a la que se pase un establecimiento y un rango de fechas, un adicional y un tipo de carne y nos devuelva
--el número de serranitos que se han vendido en ese establecimiento que contengan ese tipo de carne y ese adicional en ese
--rango de fechas.

--Interfaz
--Cabecera: FNCantidadSerranitosFiltrados(@Inicio SMALLDATETIME,
										--@Fin SMALLDATETIME,
										--@IDEstablecimiento smallint,
										--@Carne char(12),
										--@IDAdicional tinyint)
--Variables de entrada: Un rango de fechas (fecha de comienzo y de fin), la id de uno de los establecimientos, un tipo de carne y la id de un adicional
--Variables de salida: La cantidad de serranitos de un tipo de carne y con un complemento pasados por parámetros
--vendidos en un rango de fechas y en un establecimiento también especificados por parámetros.
--Precondiciones: @Inicio debe ser una fecha anterior a @Fin, todos los parametros son obligatorios
--Postcondiciones: 

GO
CREATE OR ALTER FUNCTION FNCantidadSerranitosFiltrados(@Inicio SMALLDATETIME,
													   @Fin SMALLDATETIME,
													   @IDEstablecimiento smallint,
													   @Carne char(12),
													   @IDAdicional tinyint)
RETURNS int AS
BEGIN

	DECLARE @CantidadSerranitos int

	--El DISTINCT dentro del COUNT es importante, puesto que la ID de un mismo plato
	--se repetira mas de una vez si tiene mas de un adicional
	SELECT @CantidadSerranitos = COUNT(DISTINCT PL.ID) FROM DSPedidos AS PE
	INNER JOIN DSPlatos AS PL ON PE.ID = PL.IDPedido
	INNER JOIN DSPlatosAdicionales AS PLA ON PLA.IDPlato = PL.ID
	WHERE PE.Enviado BETWEEN @Inicio AND @Fin
	  AND PE.IDEstablecimiento = @IDEstablecimiento
	  AND PL.TipoCarne = @Carne
	  AND PLA.IDAdicional = @IDAdicional

	RETURN @CantidadSerranitos

END
GO

--TEST
	
	DECLARE @FechaInicio smalldatetime
	DECLARE @FechaFinal smalldatetime
	DECLARE @IDEstablecimiento smallint
	DECLARE @Carne char(12)
	DECLARE @IDAdicional tinyint

	SET @FechaInicio = SMALLDATETIMEFROMPARTS(2017, 1, 1, 0, 0)
	SET @FechaFinal = SMALLDATETIMEFROMPARTS(2017, 10, 1, 0, 0)
	SET @IDEstablecimiento = 1
	SET @Carne = 'Ternera'
	SET @IDAdicional = 1
	

	--La funcion devuelve 2
	SELECT dbo.FNCantidadSerranitosFiltrados (@FechaInicio, @FechaFinal, @IDEstablecimiento, @Carne, @IDAdicional)

	--A traves de esta consulta, podemos contar manualmente que, efectivamente, solo dos pedidos satisfacen las condiciones
	SELECT PL.*, PE.IDEstablecimiento, PE.Enviado, PLA.IDAdicional FROM DSPedidos AS PE
	INNER JOIN DSPlatos AS PL ON PE.ID = PL.IDPedido
	INNER JOIN DSPlatosAdicionales AS PLA ON PLA.IDPlato = PL.ID
	WHERE PE.Enviado BETWEEN @FechaInicio AND @FechaFinal
	  AND PE.IDEstablecimiento = @IDEstablecimiento
	  ORDER BY IDAdicional


--Ejercicio 2 (2 points)
--Queremos saber cuál es el adicional que prefieren los clientes de un establecimiento para acompañar cada tipo de carne.
--Escribe una función a la que pasemos el nombre de un establecimiento y nos devuelva una tabla con los distintos tipos de
--carne y el adicional que más veces la acompaña, así como el número total de serranitos vendidos que incluyan ese tipo de
--carne y ese adicional. Utiliza la función desarrollada en el ejercicio 1

--Esta consulta se podria reestructurar como una consulta de multiples instrucciones. La primera subconsulta realizada
--(Sub1), se almacenaria en una tabla temporal y seguidamente iriamos eliminado las filas que no tengan las ocurrencias
--maximas de VecesAcompañamiento para cada carne.

--INTERFAZ
--Cabecera: FNAdicionalPreferido(@NombreEstablecimiento varchar(30))
--Variables de entrada: El nombre de uno de los establecimientos
--Variables de salida: Ninguna
--Precondiciones: Ninguna
--Postcondiciones: No aparecera ningun adicional que no se haya comprado nunca con esa carne. Si existe más de un adicional
--que ha acompañado a una carne particular un mismo numero de veces, aparecerán todos ellos.

GO
CREATE OR ALTER FUNCTION FNAdicionalPreferido(@NombreEstablecimiento varchar(30)) RETURNS TABLE AS
RETURN

SELECT Sub1.Carne, Sub1.Adicional, Sub2.VecesAcompaña FROM
--Esta subsconsulta devuelve la cantidad de veces que cada carne ha sido acompañada por cada acompañamiento
--Dado que no queremos los resultados en funcion de un rango temporal, pero la funcion del ejercicio 1
--pide fechas por parametros, ponemos un rango de fecha muy grande, de tal forma que entren todos los pedidos
(SELECT TC.Carne, A.Adicional, dbo.FNCantidadSerranitosFiltrados (SMALLDATETIMEFROMPARTS(2000, 1, 1, 0, 0),
																	  SMALLDATETIMEFROMPARTS(2040, 1, 1, 0, 0),
																	  dbo.FNNombreAIDEstablecimiento(@NombreEstablecimiento),
																	  TC.Carne,
																	  A.ID ) AS VecesAcompaña
FROM DSTiposCarne AS TC
CROSS JOIN --Relacionamos cada carne con cada acompañamiento
DSAdicionales AS A) AS Sub1

INNER JOIN 
--Esta subconsulta me devuelve cada carne y el maximo numero de veces que ha sido acompañada por un adicional
(SELECT TC.Carne, MAX(dbo.FNCantidadSerranitosFiltrados (SMALLDATETIMEFROMPARTS(2000, 1, 1, 0, 0),
														 SMALLDATETIMEFROMPARTS(2040, 1, 1, 0, 0),
														 dbo.FNNombreAIDEstablecimiento(@NombreEstablecimiento),
														 TC.Carne,
														 A.ID )) AS VecesAcompaña
FROM DSTiposCarne AS TC
CROSS JOIN
DSAdicionales AS A
GROUP BY TC.Carne) AS Sub2

ON Sub1.Carne = Sub2.Carne AND
   Sub1.VecesAcompaña = Sub2.VecesAcompaña
   AND (Sub1.VecesAcompaña <> 0 OR Sub2.VecesAcompaña <> 0)
   --Quitamos los acompañamientos que nunca hayan aparecido con un tipo de carne, pues es informacion irrelevante
   --(no tiene nada que ver con los acompañamientos favoritos)
GO

--TEST

SELECT * FROM dbo.FNAdicionalPreferido ('La Fragua')

SELECT Sub1.Carne, Sub1.Adicional, Sub2.VecesAcompaña FROM
--Esta subsconsulta devuelve la cantidad de veces que cada carne ha sido acompañada por cada acompañamiento
(SELECT TC.Carne, A.Adicional, dbo.FNCantidadSerranitosFiltrados (SMALLDATETIMEFROMPARTS(2000, 1, 1, 0, 0),
																	  SMALLDATETIMEFROMPARTS(2040, 1, 1, 0, 0),
																	  1, --Probamos el establecimiento de ID 1
																      TC.Carne,
																	  A.ID ) AS VecesAcompaña
FROM DSTiposCarne AS TC
CROSS JOIN
DSAdicionales AS A) AS Sub1

INNER JOIN 
--Esta subconsulta me devuelve cada carne y el maximo numero de veces que ha sido acompañada por un adicional
(SELECT TC.Carne, MAX(dbo.FNCantidadSerranitosFiltrados (SMALLDATETIMEFROMPARTS(2000, 1, 1, 0, 0),
														 SMALLDATETIMEFROMPARTS(2040, 1, 1, 0, 0),
														 1, --Probamos el establecimiento de ID 1
														 TC.Carne,
														 A.ID )) AS VecesAcompaña
FROM DSTiposCarne AS TC
CROSS JOIN
DSAdicionales AS A
GROUP BY TC.Carne) AS Sub2

ON Sub1.Carne = Sub2.Carne AND
   Sub1.VecesAcompaña = Sub2.VecesAcompaña
   AND (Sub1.VecesAcompaña <> 0 OR Sub2.VecesAcompaña <> 0)
   --Quitamos los acompañamientos que nunca hayan aparecido con un tipo de carne, pues es informacion irrelevante
   --(no tiene nada que ver con los acompañamientos favoritos)

   ORDER BY Sub1.Carne


--Funcion auxiliar que me devuelve el ID de establecimiento correspondiente a un nombre
GO
CREATE OR ALTER FUNCTION FNNombreAIDEstablecimiento(@Nombre varchar(30))
RETURNS smallint
AS
BEGIN

	DECLARE @ID smallint

	SELECT @ID = E.ID FROM DSEstablecimientos AS E
	WHERE E.Denominacion = @Nombre

	RETURN @ID

END

GO


--Ejercicio 3 (3 points)
--A algunos clientes les gusta repetir sus pedidos. Crea un procedimiento al que se pase el nombre y apellidos de un cliente,
--el ID de un establecimiento y una fecha/hora y busque el pedido de ese cliente más cercano a esa fecha/hora (puede haber un
--margen de error de más o de menos) y duplique el pedido con los mismos serranitos, salsas y complementos, en el mismo
--establecimiento, pero asignándole la fecha/hora actual. Deja la fecha de envío a NULL y asígnale como repartidor a Paco
--Bardica.

--Interfaz
--Cabecera: RepetirPedido @Nombre varchar(20),
						--@Apellidos varchar(30),
						--@IDEstablecimiento smallint,
						--@Fecha smalldatetime
--Variables de entrada: El nombre y apellidos del cliente cuyo pedido vamos a repetir, el id del establecimiento donde lo
--realizó y la fecha y hora aproximada en que lo realizó
--Variables de salida: Ninguna
--Precondiciones: Ninguna
--Postcondiciones: En el estado actual de la funcion, se añadira un nuevo pedido con los platos correspondientes a los platos
--del pedido que esta repitiendo, pero estos no traeran ninguna salsa ni ningun complemento

GO
CREATE PROCEDURE RepetirPedido @Nombre varchar(20), @Apellidos varchar(30), @IDEstablecimiento smallint, @Fecha smalldatetime
AS
BEGIN TRANSACTION --Para añadir seguridad

DECLARE @IDCliente int
DECLARE @IDUltimoPedido bigint
DECLARE @IDRepartidor smallint

--Calculamos la ID de repartidor correspondiente a Paco Bardica y la almacenamos
SELECT @IDRepartidor = R.ID FROM DSRepartidores AS R
WHERE R.Nombre = 'Paco'
AND R.Apellidos = 'Bardica'

--Calculamos la ID de cliente correspondiente a ese nombre y apellidos y lo almacenamos
SELECT @IDCliente = C.ID FROM DSClientes AS C
WHERE C.Nombre = @Nombre
AND C.Apellidos = @Apellidos

--Calculamos el ultimo pedido del cliente y lo almacenamos en la variable @IDUltimoPedido
--La funcion ABS la empleamos para poder comparar la diferencia temporal entre fechas posteriores y anteriores a la
--pasada por parametros. Independientemente del signo del valor, solo nos interesa la cantidad de tiempo transcurrido

--CON RESPECTO A LAS ANOTACIONES DE LEO: He hecho el doble select porque sintácticamente no sabía escribir
--el TOP 1 y la asignación de valor a la variable, me daba error.
SELECT @IDUltimoPedido = Sub1.ID FROM
(SELECT TOP 1 PE.ID, ABS(DATEDIFF(SECOND, @Fecha, PE.Enviado)) AS Tiempo FROM DSPedidos AS PE
WHERE PE.IDCliente = @IDCliente
ORDER BY ABS(DATEDIFF(SECOND, @Fecha, PE.Enviado)) ASC) AS Sub1


--CON RESPECTO A LAS ANOTACIONES DE LEO: No iba a guardar @@IDENTITY en una variable porque tenía pensado insertar
--otra cosa y usar el nuevo valor de @@IDENTITY al llamarla otra vez

--Insertamos un nuevo pedido
INSERT INTO DSPedidos(Recibido, IDCliente, IDEstablecimiento, IDRepartidor, Importe)
SELECT CURRENT_TIMESTAMP, @IDCliente, @IDEstablecimiento, @IDRepartidor, PE.Importe FROM DSPedidos AS PE
WHERE PE.ID = @IDUltimoPedido

--Insertamos los datos de los platos que le correspondian al ultimo pedido realizado por el cliente como nuevos platos
--@@IDENTITY es la ultima ID generada, en este caso la del nuevo pedido de la instrucción INSERT anterior

INSERT INTO DSPlatos(IDPedido, TipoPan, TipoCarne)
SELECT @@IDENTITY, P.TipoCarne, P.TipoPan FROM DSPlatos AS P
WHERE P.IDPedido = @IDUltimoPedido

--Faltarian añadirle las salsas y los complementos a los platos


GO

--TEST
DECLARE @FechaInicio SMALLDATETIME
DECLARE @IDPedidoCandidata bigint
SET @FechaInicio = SMALLDATETIMEFROMPARTS(2018, 3, 21, 0, 0)

--Calculamos el ultimo pedido del cliente

SELECT @IDPedidoCandidata = Sub1.ID FROM
(SELECT TOP 1 PE.ID, ABS(DATEDIFF(SECOND, @FechaInicio, PE.Enviado)) AS Tiempo FROM DSPedidos AS PE
WHERE PE.IDCliente = 4
ORDER BY Tiempo ASC) AS Sub1


--Ejercicio 4 (3 points)
--Crea una función a la que se pase como parámetro el nombre de un establecimiento y nos devuelva una tabla con dos columnas,
--hora y tipo de pan. La tabla tendrá 24 filas, correspondientes a las 24 horas del día y nos dirá qué pan se vende más a cada
--hora. La fila de hora 0 abarcará desde las 0:00 a las 0:59, la hora 1 de las 1:00 a las 1:59 y así sucesivamente.