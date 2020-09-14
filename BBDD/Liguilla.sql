USE LeoChampionsLeague
SELECT * FROM Partidos


--Voy a hacer en las tablas temporales, fuera de ninguna funcion ni na, los calculos de los datos. Despues vere si interesa
--ponerlos en una funcion
GO
DECLARE @Partidos AS TABLE (
	NombreEquipo varchar(20) NOT NULL,
	PartidosJugados tinyint NOT NULL,
	PartidosGanados tinyint NOT NULL,
	PartidosEmpatados tinyint NOT NULL,
	PartidosPerdidos AS ([PartidosJugados]-([PartidosGanados]+[PartidosEmpatados]))
)
GO
--Se insertan la cantidad de partidos jugados
INSERT INTO @Partidos(NombreEquipo, PartidosJugados)


--Vistas

SELECT * FROM @Partidos
--Esta funcion te devuelve todo lo de un equipo y dentro de ella se emplean las variables tipo tabla

CREATE FUNCTION ClasificacionEquipo(@Equipo AS varchar(4))
RETURNS @T TABLE(Posicion AS tinyint, IDEquipo AS char(4), NombreEquipo AS varchar(20), PartidosJugados AS tinyint, PartidosGanados AS tinyint, PartidosEmpatados AS tinyint, PartidosPerdidos AS [PartidosJugados]-([PartidosGanados]+[PartidosEmpatados], Puntos AS [PartidosGanados]*(3)+[PartidosEmpatados], GolesFavor AS SmallInt, GolesContra AS SmallInt) AS
BEGIN
	asd
	RETURN 
END

GO
--Partidos ganados
SELECT * FROM Partidos AS P
WHERE P.ELocal = 'AJAX' OR P.EVisitante = 'AJAX'
--Los partidos perdidos seran los partidos jugados menos los ganados