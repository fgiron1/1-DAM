--Ejercicio 1
--Queremos saber nombre, apellidos y edad de cada miembro y el número de regatas que ha disputado
--en barcos de cada clase.


SELECT 
M.nombre,
M.apellidos,
YEAR(CURRENT_TIMESTAMP - CONVERT(smalldatetime, M.f_nacimiento)) - 1900 AS Edad
FROM EV_Miembros AS M


SELECT 
M.licencia_federativa,
M.nombre,
M.apellidos,
YEAR(CURRENT_TIMESTAMP - CONVERT(smalldatetime, M.f_nacimiento)) - 1900 AS Edad,
C.nombre,
COUNT(R.f_inicio) AS Regatas
FROM EV_Miembros AS M
INNER JOIN EV_Miembros_Barcos_Regatas AS MBR ON M.licencia_federativa = MBR.licencia_miembro
INNER JOIN EV_Regatas AS R ON R.f_inicio = MBR.f_inicio_regata
INNER JOIN EV_Barcos AS B ON MBR.n_vela = B.n_vela
INNER JOIN EV_Clases AS C ON C.nombre = B.nombre_clase
GROUP BY 
M.nombre,
M.apellidos,
YEAR(CURRENT_TIMESTAMP - CONVERT(smalldatetime, M.f_nacimiento)) - 1900,
M.licencia_federativa,
C.nombre

--Ejercicio 2
--Miembros que tengan más de 250 horas de cursos y que nunca hayan disputado una regata compartiendo
--barco con Esteban Dido.




--Ejercicio 3
--Crea una vista VTrabajoMonitores que contenga número de licencia, nombre y apellidos de cada monitor,
--número de cursos y número total de horas que ha impartido, así como el número total de alumnos que han
--participado en sus cursos. A la hora de contar los asistentes, se contaran participaciones, no personas.
--Es decir, si un mismo miembro ha asistido a tres cursos distintos, se contará como tres, no como uno.
--Deben incluirse los monitores a cuyos cursos no haya asistido nadie, para echarles una buena bronca.

GO
CREATE VIEW VTrabajoMonitores AS

SELECT Sub1.licencia_federativa, Sub1.nombre, Sub1.apellidos, Sub1.Participantes, Sub2.Cursos, ISNULL(0, Sub2.Horas) AS Horas FROM 

(SELECT Mon.licencia_federativa, Mi.nombre, Mi.apellidos, COUNT(MC.licencia_federativa) AS Participantes FROM EV_Monitores AS Mon
LEFT JOIN EV_Miembros AS Mi ON Mi.licencia_federativa = Mon.licencia_federativa
LEFT JOIN EV_Cursos AS C ON C.licencia = Mon.licencia_federativa
LEFT JOIN EV_Miembros_Cursos AS MC ON MC.codigo_curso = C.codigo_curso
GROUP BY Mon.licencia_federativa, Mi.nombre, Mi.apellidos) AS Sub1

INNER JOIN

(SELECT Mon.licencia_federativa, COUNT(C.codigo_curso) AS Cursos, SUM(C.duracion) AS Horas FROM EV_Monitores AS Mon
LEFT JOIN EV_Miembros AS Mi ON Mi.licencia_federativa = Mon.licencia_federativa
LEFT JOIN EV_Cursos AS C ON C.licencia = Mon.licencia_federativa
GROUP BY Mon.licencia_federativa, Mi.nombre, Mi.apellidos) AS Sub2

ON Sub1.licencia_federativa = Sub2.licencia_federativa
GO

SELECT * FROM EV_Monitores AS M
INNER JOIN EV_Cursos AS C ON M.licencia_federativa = C.licencia
WHERE M.licencia_federativa = '207'


--Ejercicio 4
--Número de horas de cursos acumuladas por cada miembro que no haya disputado una regata en la clase 470
--en los dos últimos años (2013 y 2014). Se contarán únicamente las regatas que se hayan disputado en un
--campo de regatas situado en longitud Oeste (W). Se sabe que la longitud es W porque el número es negativo.

SELECT M.licencia_federativa, M.nombre, M.apellidos, SUM(C.duracion) AS Duracion FROM EV_Cursos AS C
INNER JOIN EV_Miembros_Cursos AS MC ON MC.codigo_curso = C.codigo_curso
INNER JOIN EV_Miembros AS M ON M.licencia_federativa = MC.licencia_federativa
WHERE M.licencia_federativa NOT IN
--Yo creo que está bien esta subconsulta pero no me devuelve a nadie
(SELECT DISTINCT M.licencia_federativa FROM EV_Miembros AS M
INNER JOIN EV_Miembros_Barcos_Regatas AS MBC ON M.licencia_federativa = MBC.licencia_miembro
INNER JOIN EV_Regatas AS R ON R.f_inicio = MBC.f_inicio_regata
INNER JOIN EV_Campo_Regatas AS CR ON CR.nombre_campo = R.nombre_campo
INNER JOIN EV_Barcos AS B ON B.n_vela = MBC.n_vela
INNER JOIN EV_Clases AS C ON C.nombre = B.nombre_clase
WHERE C.nombre = '470' AND CR.longitud < 0 AND CR.longitud_llegada < 0 AND (YEAR(R.f_inicio) = '2013' OR YEAR(R.f_inicio) = '2014'))

GROUP BY M.licencia_federativa, M.nombre, M.apellidos

SELECT * FROM EV_Miembros

--Ejercicio 5

--El comité de competiciones está preocupado por el bajo rendimiento de los regatistas en
--las clases Tornado y 49er, así que decide organizar unos cursos para repasar las técnicas más importantes.
--Los cursos se titulan "Perfeccionamiento Tornado” y "Perfeccionamiento 49er”, ambos de 120 horas de duración.
--Comezarán los días 21 de marzo y 10 de abril, respectivamente. El primero será impartido por Salud Itos y
--el segundo por Fernando Minguero.
--Escribe un INSERT-SELECT para matricular en estos cursos a todos los miembros que hayan participado en
--regatas en alguna de estas clases desde el 1 de Abril de 2014, cuidando de que los propios monitores no
--pueden ser también alumnos.