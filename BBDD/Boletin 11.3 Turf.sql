--He supuesto que Premio1 y Premio2 son los factores por los que se multiplica el importe de cada apuesta
--en el caso de que el caballo quede primero o segundo, respectivamente. Si el caballo queda en otra posicion,
--el jugador ha perdido todo el dinero de la apuesta


--1.Crea una función inline llamada FnCarrerasCaballo que reciba un rango de fechas (inicio y fin) y nos devuelva
--el número de carreras disputadas por cada caballo entre esas dos fechas. Las columnas serán ID (del caballo),
--nombre, sexo, fecha de nacimiento y número de carreras disputadas.

--He supuesto que si un caballo no ha participado en una carrera, no existe una fila
--que asocie ese caballo a esa carrera en LTCarrerasCaballos

SELECT * FROM LTCaballosCarreras

GO
CREATE OR ALTER FUNCTION FNCarrerasCaballo(@Inicio date, @Fin date) RETURNS TABLE AS
RETURN

SELECT 
	   CA.ID,
	   CA.Nombre,
	   CA.Sexo,
	   CA.FechaNacimiento,
	   COUNT(CC.IDCarrera) AS CarrerasDisputadas
FROM 
	  LTCaballos AS CA
	  INNER JOIN LTCaballosCarreras AS CC ON CA.ID = CC.IDCaballo
	  INNER JOIN LTCarreras AS C ON CC.IDCarrera = C.ID	
	  
WHERE 
	  C.Fecha BETWEEN @Inicio AND @Fin

GROUP BY 
		CA.ID,
		CA.Nombre,
		CA.Sexo,
		CA.FechaNacimiento
GO

--2.Crea una función escalar llamada FnTotalApostadoCC que reciba como parámetros el ID de un caballo y el ID de
--una carrera y nos devuelva el dinero que se ha apostado a ese caballo en esa carrera.

GO
CREATE OR ALTER FUNCTION FNTotalApostadoCC (@IDCaballo int, @IDCarrera int)
RETURNS smallmoney
BEGIN

	DECLARE @DineroApostado smallmoney
	
	SELECT @DineroApostado = SUM(A.Importe) FROM LTApuestas AS A
	WHERE A.IDCaballo = @IDCaballo 
	  AND A.IDCarrera = @IDCarrera

	RETURN @DineroApostado
END
GO
---------------------------------------------------
--TEST

DECLARE @Test smallmoney
EXECUTE @Test = FNTotalApostadoCC 22, 4
PRINT @Test

--Comprobamos que se corresponde:
SELECT * FROM LTApuestas AS A
ORDER BY A.IDCarrera, A.IDCaballo

---------------------------------------------------
--3.Crea una función escalar llamada FnPremioConseguido que reciba como parámetros el ID de una apuesta y nos
--devuelva el dinero que ha ganado dicha apuesta. Si todavía no se conocen las posiciones de los caballos,
--devolverá un NULL

GO
CREATE OR ALTER FUNCTION FNPremioConseguido(@IDApuesta int)
RETURNS smallmoney
BEGIN

	DECLARE @Ganancias smallmoney
	DECLARE @IDCaballoAsociado int
	DECLARE @IDCarreraAsociada int
	DECLARE @ImporteAsociado smallmoney
	
	--Almacenamos la ID del caballo, la ID de la carrera, y el importe 
	--asociadas a la apuesta
	SELECT @IDCaballoAsociado = A.IDCaballo,
	       @IDCarreraAsociada = A.IDCarrera,
		   @ImporteAsociado = A.Importe
	FROM LTApuestas AS A
	WHERE A.ID = @IDApuesta

	
	--Buscamos la carrera y el caballo de la apuesta y devolvemos las ganancias
	SELECT @Ganancias = 
				CASE CC.Posicion
					WHEN 1 THEN CC.Premio1 * @ImporteAsociado - @ImporteAsociado
					WHEN 2 THEN CC.Premio2 * @ImporteAsociado - @ImporteAsociado
					WHEN NULL THEN NULL
					--Lo ganado menos el coste original de la apuesta = beneficios
					ELSE @ImporteAsociado * (-1)
					--Si el caballo al que ha apostado queda en una posicion inferior a la primera o la segunda
					--El jugador no gana nada, es decir, tiene una deuda del valor de su apuesta inicial
					
				END
	
   FROM LTCaballosCarreras AS CC
   WHERE CC.IDCaballo = @IDCaballoAsociado AND
	     CC.IDCarrera = @IDCarreraAsociada

	RETURN @Ganancias
END

GO

--4.El procedimiento para calcular los premios en las apuestas de una carrera (los valores que deben figurar en
--la columna Premio1 y Premio2) es el siguiente:

--a.Se calcula el total de dinero apostado en esa carrera

--b.El valor de la columna Premio1 para cada caballo se calcula dividiendo el total de dinero apostado entre lo apostado a ese caballo y se multiplica el resultado por 0.6

--c.El valor de la columna Premio2 para cada caballo se calcula dividiendo el total de dinero apostado entre lo apostado a ese caballo y se multiplica el resultado por 0.2

--d.Si a algún caballo no ha apostado nadie tanto el Premio1 como el Premio2 se ponen a 100.

--Crea una función que devuelva una tabla con tres columnas: ID del caballo, Premio1 y Premio2.
--El parámetro de entrada será el ID de la carrera.

--Debes usar la función del Ejercicio 2. Si lo estimas oportuno puedes crear otras funciones para realizar parte
--de los cálculos.

GO
CREATE OR ALTER FUNCTION FNPremiosCaballosV2(@IDCarrera int)
RETURNS TABLE AS
RETURN

--PROBLEMA: Repito mucho la consulta de los caballos que participan en la carrera

----Se calcula el valor inicial de la VCB
--SELECT @VCB = MIN(CC.IDCaballo)
--FROM LTCaballosCarreras AS CC
--WHERE CC.IDCarrera = @IDCarrera

----Se calcula el valor limite de la VCB
--SELECT @VCBMAX = MAX(CC.IDCaballo)
--FROM LTCaballosCarreras AS CC
--WHERE CC.IDCarrera = @IDCarrera

--LA CONSULTA WENA
SELECT CC.IDCaballo, 
	   dbo.FNCalcularPremio (1, @IDCarrera, CC.IDCaballo) AS Premio1,
	   dbo.FNCalcularPremio (2, @IDCarrera, CC.IDCaballo) AS Premio2
FROM LTCaballosCarreras AS CC
WHERE CC.IDCarrera = @IDCarrera

--Cada iteracion del bucle inserta una fila en la tabla a devolver con la ID de un caballo que ha participado
--en esa carrera y con el Premio1 y Premio2 correspondiente
	--WHILE @VCB <= @VCBMAX
	--	BEGIN

	--		--Se calculan los premios correspondientes al caballo cuya ID es @VCB
	--		EXECUTE @Premio1Calculado = FNCalcularPremio 1, @IDCarrera, @VCB
	--		EXECUTE @Premio2Calculado = FNCalcularPremio 2, @IDCarrera, @VCB

	--		--Se inserta una fila en la tabla a devolver con la ID del caballo y los premios correspondientes
	--		INSERT INTO @TablaPremios(IDCaballo, Premio1, Premio2)
	--		VALUES(@VCB, @Premio1Calculado, @Premio2Calculado)

	--		--Actualizacion de la VCB de forma dinamica (@VCB toma el valor del siguiente ID del caballo incluso
	--		--si hay saltos variables entre los valores)
	--		SELECT @VCB = MIN(CC.IDCaballo)
	--		FROM LTCaballosCarreras AS CC
	--		WHERE CC.IDCarrera = @IDCarrera AND
	--		      @VCB < CC.IDCaballo
	--	END

GO


GO
CREATE OR ALTER FUNCTION FNPremiosCaballosV1(@IDCarrera int) RETURNS 
@TablaPremios TABLE(

	IDCaballo int NOT NULL,
	Premio1 smallmoney NOT NULL,
	Premio2 smallmoney NOT NULL

)

AS
BEGIN

	DECLARE @VCB int
	DECLARE @VCBMax int
	DECLARE @Premio1Calculado smallmoney
	DECLARE @Premio2Calculado smallmoney

	--Se calcula el valor inicial de la VCB
	SELECT @VCB = MIN(CC.IDCaballo)
	FROM LTCaballosCarreras AS CC
	WHERE CC.IDCarrera = @IDCarrera

	--Se calcula el valor limite de la VCB
	SELECT @VCBMAX = MAX(CC.IDCaballo)
	FROM LTCaballosCarreras AS CC
	WHERE CC.IDCarrera = @IDCarrera

		WHILE @VCB <= @VCBMAX
		BEGIN

			--Se calculan los premios correspondientes al caballo cuya ID es @VCB
			EXECUTE @Premio1Calculado = FNCalcularPremio 1, @IDCarrera, @VCB
			EXECUTE @Premio2Calculado = FNCalcularPremio 2, @IDCarrera, @VCB

			--Se inserta una fila en la tabla a devolver con la ID del caballo y los premios correspondientes
			INSERT INTO @TablaPremios(IDCaballo, Premio1, Premio2)
			VALUES(@VCB, @Premio1Calculado, @Premio2Calculado)

			--Actualizacion de la VCB de forma dinamica (@VCB toma el valor del siguiente ID del caballo incluso
			--si hay saltos variables entre los valores)
			SELECT @VCB = MIN(CC.IDCaballo)
			FROM LTCaballosCarreras AS CC
			WHERE CC.IDCarrera = @IDCarrera AND
			      @VCB < CC.IDCaballo
		END


	RETURN

END

GO
---------------------------------------------------------------
--TEST

SELECT * FROM FNPremiosCaballosV1(4)
SELECT * FROM FNPremiosCaballosV2(4)
ORDER BY IDCaballo
SELECT * FROM LTCaballosCarreras AS CC
WHERE CC.IDCarrera = 4

DECLARE @Test smallmoney
EXECUTE @Test = FNCalcularPremio 2, 5, 28
PRINT @Test
-------------------------------------------------------------


GO
CREATE OR ALTER FUNCTION FNCalcularPremio(@Tipo int, @IDCarrera int, @IDCaballo int)
RETURNS smallmoney
BEGIN

DECLARE @DineroTotal smallmoney
DECLARE @DineroCaballo smallmoney
DECLARE @Calculo smallmoney
DECLARE @Premio smallmoney

--Asignamos todo el dinero apostado en esa carrera a la variable @DineroTotal
SELECT @DineroTotal = SUM(A.Importe) FROM LTApuestas AS A
WHERE A.IDCarrera = @IDCarrera

--Asignamos todo el dinero apostado al caballo en esa carrera a la variable @DineroCaballo
EXECUTE @DineroCaballo = FNTotalApostadoCC @IDCaballo, @IDCarrera

--Si alguien ha apostado por el caballo de @IDCaballo, distinguimos dos premios diferentes en funcion del parametro @Premio
IF(@DineroCaballo <> 0)

	BEGIN
		SET @Premio = CASE @Tipo
						  WHEN 1 THEN (@DineroTotal / @DineroCaballo) * 0.6
						  WHEN 2 THEN (@DineroTotal / @DineroCaballo) * 0.2
						  ELSE NULL
					  END
	END
--Si alguien no ha apostado por el caballo de @IDCaballo, independientemente del parametro @Tipo, el valor devuelto sera 100
ELSE IF (@DineroCaballo > 0)

	BEGIN
		SET @Premio = 100
	END

	--Se redondea a los 2 decimales			
	RETURN ROUND(@Premio, 1)
END
GO

-----------------------------------------------------
--TEST
DECLARE @Test smallmoney
EXECUTE @Test = FNCalcularPremio 1, 18, 7
PRINT @Test

SELECT * FROM LTCaballosCarreras
ORDER BY IDCarrera, IDCaballo

------------------------------------------------------

--5.Crea una función FnPalmares que reciba un ID de caballo y un rango de fechas y nos devuelva el palmarés de ese
--caballo en ese intervalo de tiempo.
--El palmarés es el número de victorias, segundos puestos, etc. Se devolverá una tabla con dos columnas: Posición
--y NumVeces, que indicarán, respectivamente, cada una de las posiciones y las veces que el caballo ha obtenido ese
--resultado. Queremos que aparezcan 8 filas con las posiciones de la 1 a la 8. Si el caballo nunca ha finalizado en
--alguna de esas posiciones, aparecerá el valor 0 en la columna NumVeces.



--6.Crea una función FnCarrerasHipodromo que nos devuelva las carreras celebradas en un hipódromo en un rango de 
--fechas.
--La función recibirá como parámetros el nombre del hipódromo y la fecha de inicio y fin del intervalo y nos 
--devolverá una tabla con las siguientes columnas: Fecha de la carrera, número de orden, numero de apuestas
--realizadas, número de caballos inscritos, número de caballos que la finalizaron y nombre del ganador.

--7.Crea una función FnObtenerSaldo a la que pasemos el ID de un jugador y una fecha y nos devuelva su saldo
--en esa fecha. Si se omite la fecha, se devolverá el saldo actual

--MIN DATEDIFF(seconds, Fecha, CURRENT_TIMESTAMP)


--Tendria que hacer el caso en el que la fecha no coincide con ninguna.
--Aunque bueno, a lo mejor no, porque me devolveria una consulta vacia
--ya de por si

GO
CREATE OR ALTER FUNCTION FNObtenerSaldo(@IDJugador int, @Fecha date = NULL)
RETURNS money
BEGIN
	DECLARE @Saldo money

	IF(@Fecha IS NULL)

		BEGIN

		--Obtenemos la ultima transaccion del jugador, es decir, la que tenga el maximo valor en la columna Orden
			SELECT @Saldo = Sub2.Saldo FROM
			((SELECT MAX(A.Orden) AS MaxOrden
			FROM LTApuntes AS A
			WHERE A.IDJugador = @IDJugador) AS Sub1

			INNER JOIN

			(SELECT A.Orden, A.Saldo
			FROM LTApuntes AS A
			WHERE A.IDJugador = @IDJugador) AS Sub2

			ON Sub1.MaxOrden = Sub2.Orden)

		END

	ELSE

		BEGIN
			--Puede haber hecho mas de una transaccion en un dia, por lo tanto,
			--se coge la transaccion de orden mayor en el dia
			SELECT @Saldo = Sub1.Saldo FROM
			(SELECT A.Saldo, A.Orden FROM LTApuntes AS A
			 WHERE A.IDJugador = @IDJugador
			   AND A.Fecha = @Fecha) AS Sub1

			INNER JOIN

		    (SELECT MAX(A.Orden) AS MaxOrden FROM LTApuntes AS A
			WHERE A.IDJugador = @IDJugador
			  AND A.Fecha = @Fecha) AS Sub2

			ON Sub1.Orden = Sub2.MaxOrden

		END

	RETURN @Saldo
END
GO
---------------------------------------
--TEST

DECLARE @Test money
DECLARE @TestFecha date
SET @TestFecha = DATEFROMPARTS(2018,2,28)
EXECUTE @Test = FNObtenerSaldo 1, @TestFecha
PRINT @Test

SELECT A.Saldo FROM LTApuntes AS A
			WHERE A.IDJugador = 1
			  AND A.Fecha = @TestFecha

			  


SELECT * FROM LTApuntes
------------------------------------


GO