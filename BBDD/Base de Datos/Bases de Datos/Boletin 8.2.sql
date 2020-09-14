USE pubs
GO

/*
1. Numero de libros que tratan de cada tema
2. N�mero de autores diferentes en cada ciudad y estado
3. Nombre, apellidos, nivel y antig�edad en la empresa de los empleados con un nivel entre 100 y 150.
4. N�mero de editoriales en cada pa�s. Incluye el pa�s.
5. N�mero de unidades vendidas de cada libro en cada a�o (title_id, unidades y a�o).
6. N�mero de autores que han escrito cada libro (title_id y numero de autores).
7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor superior a $7.000, ordenado por tipo y t�tulo

Shipper = Distribuidor
Supplier = Proveedor
*/

SELECT COUNT(title_id) FROM titles
GROUP BY type
GO

SELECT DISTINCT city, state, COUNT(au_id) AS [Numero autores] FROM authors
GROUP BY city,[state]
GO

SELECT fname, lname, job_lvl, YEAR(CURRENT_TIMESTAMP - CAST (hire_date AS SmallDateTime)) - 1900 AS Antig�edad FROM employee
WHERE job_lvl >= 100 AND job_lvl <= 150
GO

SELECT COUNT(pub_id) AS [Numero editoriales], country FROM publishers
GROUP BY country
GO

SELECT title_id, COUNT(title_id) FROM titles
GROUP BY fname
GO


SELECT title_id, title, [type], price FROM titles
WHERE advance > 7000
ORDER BY [type], title

SELECT * FROM titles