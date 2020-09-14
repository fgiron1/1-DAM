--1.Número de mascotas que han sufrido cada enfermedad.

SELECT E.Nombre, COUNT(ME.Mascota) AS Afectados FROM BI_Enfermedades AS E
INNER JOIN BI_Mascotas_Enfermedades AS ME ON ME.IDEnfermedad = E.ID
GROUP BY E.Nombre

--2.Número de mascotas que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna mascota.

SELECT E.ID, E.Nombre, COUNT(ME.Mascota) AS Afectados FROM BI_Enfermedades AS E
LEFT JOIN BI_Mascotas_Enfermedades AS ME ON ME.IDEnfermedad = E.ID
GROUP BY E.ID, E.Nombre

--3.Número de mascotas de cada cliente. Incluye nombre completo y dirección del cliente.

SELECT C.Nombre, C.Direccion, COUNT(M.Codigo) AS Mascotas FROM BI_Clientes AS C
LEFT JOIN BI_Mascotas AS M ON M.CodigoPropietario = C.Codigo
GROUP BY C.Nombre, C.Direccion

--4.Número de mascotas de cada especie de cada cliente. Incluye nombre completo y dirección del cliente.

SELECT C.Nombre, C.Direccion, M.Raza, COUNT(M.Codigo) AS Mascotas FROM BI_Clientes AS C
LEFT JOIN BI_Mascotas AS M ON M.CodigoPropietario = C.Codigo
GROUP BY C.Nombre, C.Direccion, M.Raza

--5.Número de mascotas de cada especie que han sufrido cada enfermedad.

SELECT E.Nombre, M.Especie, COUNT(M.Codigo) AS Afectadas FROM BI_Mascotas AS M
INNER JOIN BI_Mascotas_Enfermedades AS ME ON M.Codigo = ME.Mascota
INNER JOIN BI_Enfermedades AS E ON E.ID = ME.IDEnfermedad
GROUP BY M.Especie, E.Nombre

--6.Número de mascotas de cada especie que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna mascota de alguna especie.

SELECT E.Nombre, M.Especie, COUNT(M.Codigo) AS Afectadas FROM BI_Mascotas AS M
LEFT JOIN BI_Mascotas_Enfermedades AS ME ON M.Codigo = ME.Mascota
RIGHT JOIN BI_Enfermedades AS E ON E.ID = ME.IDEnfermedad
GROUP BY M.Especie, E.Nombre

--7.Queremos saber cuál es la enfermedad más común en cada especie. Incluye cuantos casos se han producido

SELECT Parte2.ID, Parte2.Nombre, Parte2.Especie, Parte3.SuperAfectadas FROM 

(SELECT Parte1.Especie, MAX(Parte1.Afectadas) AS SuperAfectadas FROM
(SELECT E.Nombre, M.Especie, COUNT(M.Codigo) AS Afectadas, E.ID FROM BI_Mascotas AS M
LEFT JOIN BI_Mascotas_Enfermedades AS ME ON M.Codigo = ME.Mascota
RIGHT JOIN BI_Enfermedades AS E ON E.ID = ME.IDEnfermedad
GROUP BY M.Especie, E.Nombre, E.ID) AS Parte1
GROUP BY Parte1.Especie) AS Parte3

INNER JOIN

(SELECT E.Nombre, M.Especie, COUNT(M.Codigo) AS Afectadas, E.ID FROM BI_Mascotas AS M
LEFT JOIN BI_Mascotas_Enfermedades AS ME ON M.Codigo = ME.Mascota
RIGHT JOIN BI_Enfermedades AS E ON E.ID = ME.IDEnfermedad
GROUP BY M.Especie, E.Nombre, E.ID) AS Parte2

ON Parte2.Afectadas = Parte3.SuperAfectadas
AND Parte3.Especie = Parte2.Especie


--No hay columnas para relacionar en el join


SELECT Parte1.Nombre, Parte1.Especie, Parte1.Afectadas FROM 

(SELECT E.Nombre, M.Especie, COUNT(M.Codigo) AS Afectadas FROM BI_Mascotas AS M
LEFT JOIN BI_Mascotas_Enfermedades AS ME ON M.Codigo = ME.Mascota
INNER JOIN BI_Enfermedades AS E ON E.ID = ME.IDEnfermedad
GROUP BY E.Nombre, M.Especie) AS Parte1

INNER JOIN

(SELECT E.Nombre, M.Especie, COUNT(M.Codigo) AS Afectadas FROM BI_Mascotas AS M
LEFT JOIN BI_Mascotas_Enfermedades AS ME ON M.Codigo = ME.Mascota
INNER JOIN BI_Enfermedades AS E ON E.ID = ME.IDEnfermedad
GROUP BY E.Nombre, M.Especie) AS Parte2

ON Parte1.Afectadas = Parte2.Afectadas

HAVING MAX(Parte1.Afectadas) <> MIN(Parte2.Afectadas)



--8.Duración media, en días, de cada enfermedad, desde que se detecta hasta que se cura.
--Incluye solo los casos en que el animal se haya curado.
--Se entiende que una mascota se ha curado si tiene fecha de curación y está viva
--o su fecha de fallecimiento es posterior a la fecha de curación.

--Pero la existencia de fecha de curación es condición necesaria y suficiente para afirmar que se ha curado

SELECT E.Nombre, AVG(DATEDIFF(day, ME.FechaInicio, ME.FechaCura)) AS DuracionMedia
FROM BI_Enfermedades AS E
INNER JOIN BI_Mascotas_Enfermedades AS ME ON ME.IDEnfermedad = E.ID
INNER JOIN BI_Mascotas AS M ON M.Codigo = ME.Mascota
WHERE ME.FechaInicio IS NOT NULL AND
ME.FechaCura IS NOT NULL 
GROUP BY E.Nombre

--9.Número de veces que ha acudido a consulta cada cliente con alguna de sus mascotas. Incluye nombre y apellidos del cliente.

SELECT C.Codigo, C.Nombre, COUNT(V.IDVisita) AS Visitas FROM BI_Clientes AS C
INNER JOIN BI_Mascotas AS M ON M.CodigoPropietario = C.Codigo
INNER JOIN BI_Visitas AS V ON V.Mascota = M.Codigo
GROUP BY C.Codigo, C.Nombre

--10.Número de visitas a las que ha acudido cada mascota, fecha de su primera y de su última visita
-- PROBLEMA: Dos mascotas con el mismo alias ya dan datos erróneos, podría poner el código muy fácilmente
--Simplemente cambiando M.Alias por M.Codigo, pero lo que me piden es el

SELECT Sub1.Codigo, Sub1.Visitas, Sub2.FechaMin AS PrimeraVisita, Sub2.FechaMax AS UltimaVisita FROM

(SELECT M.Codigo, COUNT(V.IDVisita) AS Visitas
FROM BI_Mascotas AS M
LEFT JOIN BI_Visitas AS V ON M.Codigo = V.Mascota
GROUP BY M.Codigo) AS Sub1

INNER JOIN 

(SELECT M.Codigo, MIN(V.Fecha) AS FechaMin, MAX(V.Fecha) AS FechaMax FROM Bi_Visitas as V
RIGHT JOIN Bi_Mascotas AS M ON V.Mascota = M.Codigo
GROUP BY M.Codigo) AS Sub2

ON Sub1.Codigo = Sub2.Codigo

GO

--11.Incremento (o disminución) de peso que ha experimentado cada mascota entre cada dos consultas sucesivas.
-- Incluye nombre de la mascota, especie, fecha de las dos consultas sucesivas e incremento o disminución de peso.

SELECT Sub1.Codigo, Sub1.Alias, Sub1.Especie, Sub2.Peso - Sub1.Peso FROM 
(SELECT M.Codigo, M.Alias, M.Especie FROM BI_Mascotas AS M
INNER JOIN BI_Visitas AS V ON M.Codigo = V.Mascota) AS Sub1

INNER JOIN

(SELECT * FROM BI_Mascotas AS M
INNER JOIN BI_Visitas AS V ON M.Codigo = V.Mascota) AS Sub2

ON Sub1.Fecha = MIN(Sub2.)
-----------------------------------------------
SELECT Sub1.Fecha, Sub2.Fecha FROM
(SELECT M.Codigo, M.Alias, M.Especie, V.Fecha FROM BI_Mascotas AS M
INNER JOIN BI_Visitas AS V ON M.Codigo = V.Mascota) AS Sub1

INNER JOIN

(SELECT M.Codigo, M.Alias, M.Especie, V.Fecha FROM BI_Mascotas AS M
INNER JOIN BI_Visitas AS V ON M.Codigo = V.Mascota) AS Sub2
--A la columna fechas aplicarle datediff a cada fila con otra columna de fechas y coger el min
ON Sub1.Fecha < Sub2.Fecha
----------------------------------------------------
-----------------------------------------------------------
SELECT Sub1.Fecha, Sub2.Fecha FROM
(SELECT M.Codigo, M.Alias, M.Especie, V.Fecha FROM BI_Mascotas AS M
INNER JOIN BI_Visitas AS V ON M.Codigo = V.Mascota) AS Sub1

INNER JOIN

(SELECT M.Codigo, M.Alias, M.Especie, V.Fecha FROM BI_Mascotas AS M
INNER JOIN BI_Visitas AS V ON M.Codigo = V.Mascota) AS Sub2

ON Sub1.Fecha = Sub2.Fecha
-------------------------------------------