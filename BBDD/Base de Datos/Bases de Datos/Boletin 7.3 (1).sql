 /* 1. Título, precio y notas de los libros (titles) que tratan de cocina, ordenados de mayor a menor precio.
    2. ID, descripción y nivel máximo y mínimo de los puestos de trabajo (jobs) que pueden tener un nivel 110.
    3. Título, ID y tema de los libros que contengan la palabra "and” en las notas
    4. Nombre y ciudad de las editoriales (publishers) de los Estados Unidos que no estén en California ni en Texas
    5. Título, precio, ID de los libros que traten sobre psicología o negocios y cuesten entre diez y 20 dólares.
    6. Nombre completo (nombre y apellido) y dirección completa de todos los autores que no viven en California ni en Oregón.
    7. Nombre completo y dirección completa de todos los autores cuyo apellido empieza por D, G o S.
    8. ID, nivel y nombre completo de todos los empleados con un nivel inferior a 100, ordenado alfabéticamente
 */

	/*1*/
	SELECT title, price, notes FROM titles
	WHERE type LIKE '%cook%'
	ORDER BY price desc
	GO

	/*2*/
	SELECT job_id, job_desc, min_lvl, max_lvl FROM jobs
	WHERE max_lvl >= 110 AND min_lvl <= 110

	/*3*/
	SELECT title_id, title, notes, [type] FROM titles
	WHERE notes LIKE '%and%'

	/*4*/
	SELECT pub_name, city FROM publishers
	WHERE country = 'USA' AND state <> 'Texas' AND state <> 'California'

	/*5*/
	SELECT title_id, title, price, [type] FROM titles
	WHERE ([type] = 'psychology' OR [type] = 'business') AND (price BETWEEN 10 AND 20)

	/*6*/
	SELECT au_fname, au_lname, [address] FROM authors
	WHERE state <> 'California' AND state <> 'Oregon'
	GO

	/*7*/
	SELECT au_fname, au_lname, [address] FROM authors
	WHERE LEFT(au_lname, 1) IN ('D', 'G', 'S')
	GO

	/*8*/
	SELECT emp_id, job_lvl, fname, lname FROM employee
	WHERE job_lvl < 100
	ORDER BY fname, lname

	SELECT * FROM titles
	GO

/* 1. Inserta un nuevo autor.
   2. Inserta dos libros, escritos por el autor que has insertado antes y publicados por la editorial "Ramona publishers”.
   3. Modifica la tabla jobs para que el nivel mínimo sea 90.
   4. Crea una nueva editorial (publihers) con ID 9908, nombre Mostachon Books y sede en Utrera.
   5. Cambia el nombre de la editorial con sede en Alemania para que se llame "Machen Wücher" y traslasde su sede a Stuttgart
*/

/*1*/
INSERT INTO authors (au_id, au_fname, au_lname, phone, [contract])
VALUES ('542-31-1068', 'Alejo', 'Carpentier', 000000000, 1)
GO

SELECT type FROM titles

/*2*/
INSERT INTO titles (title_id, title, type, pubdate)
VALUES ('PD2502', 'Los pasos perdidos', 'novel', )
GO

SELECT * FROM authors