
  --1.  Título y tipo de todos los libros en los que alguno de los autores vive en California (CA).

  SELECT T.title, T.type, A.au_fname, A.au_lname FROM Titles AS T
  INNER JOIN titleauthor AS TA
  ON TA.title_id = T.title_id
  INNER JOIN authors AS A
  ON A.au_id = TA.au_id
  WHERE A.state = 'CA'
  ORDER BY T.title

  --2.  Título y tipo de todos los libros en los que ninguno de los autores vive en California (CA).

  SELECT DISTINCT T.title, T.type FROM Titles AS T
  INNER JOIN titleauthor AS TA
  ON TA.title_id = T.title_id
  INNER JOIN authors AS A
  ON A.au_id = TA.au_id
  WHERE A.state <> 'CA'
  ORDER BY T.title

  --3.  Número de libros en los que ha participado cada autor, incluidos los que no han publicado nada.

  SELECT A.au_fname, A.au_lname, COUNT(T.title) AS [Colaboraciones] FROM Titles AS T
  INNER JOIN titleauthor AS TA ON TA.title_id = T.title_id
  RIGHT JOIN authors AS A ON A.au_id = TA.au_id
  GROUP BY A.au_fname, A.au_lname

  --4.  Número de libros que ha publicado cada editorial, incluidas las que no han publicado ninguno.

  SELECT P.pub_name, COUNT(T.title) AS [Numero publicaciones] FROM publishers AS P
  LEFT JOIN titles AS T ON T.pub_id = P.pub_id
  GROUP BY P.pub_id, P.pub_name

  --5.  Número de empleados de cada editorial.

  /*Aquí el distinct sólo sería necesario si un empleado pudiera trabajar en más de una editorial*/

  SELECT P.pub_name, COUNT(DISTINCT E.emp_id) AS [Empleados] FROM employee as E
  INNER JOIN publishers AS P ON P.pub_id = E.pub_id
  GROUP BY P.pub_id, pub_name


  --6.  Calcular la relación entre número de ejemplares publicados y número de empleados de cada editorial, incluyendo el nombre de la misma.
  --La clave está en el DISTINCT de los COUNT, porque cuando los agrupo, en lugar de agrupar y contar 20 instancias de un title_id, cuento solamente una única, y ya sí me dan los resultados de la query algo con sentido, antes diferían el número de empleados con los que he calculado en la de arriba

  SELECT P.pub_name, COUNT(DISTINCT T.title_id) AS Publicaciones, COUNT(DISTINCT E.emp_id) AS Empleados, CAST (COUNT(DISTINCT T.title_id) AS float)/CAST (COUNT(DISTINCT E.emp_id) AS float) AS Proporcion FROM titles AS T
  RIGHT JOIN publishers AS P ON P.pub_id = T.pub_id
  FULL JOIN employee as E ON P.pub_id = E.pub_id
  GROUP BY P.pub_name

  --7.  Nombre, Apellidos y ciudad de todos los autores que han trabajado para la editorial "Binnet & Hardley” o "Five Lakes Publishing”

  SELECT A.au_fname, A.au_lname, A.city, P.pub_name FROM authors as A
  INNER JOIN titleauthor AS TA ON TA.au_id = A.au_id
  INNER JOIN titles AS T ON T.title_id = TA.title_id
  INNER JOIN publishers AS P ON P.pub_id = T.pub_id
  WHERE pub_name IN ('Binnet & Hardley','Five Lakes Publishing')

  --8.  Empleados que hayan trabajado en alguna editorial que haya publicado algún libro en el que alguno de los autores fuera Marjorie Green o Michael O'Leary.
  -- SOLUCIONADO

  SELECT E.fname, E.lname FROM employee AS E
  INNER JOIN publishers AS P ON P.pub_id = E.pub_id
  INNER JOIN titles AS T ON P.pub_id = T.pub_id
  INNER JOIN titleauthor AS TA ON T.title_id = TA.title_id
  INNER JOIN authors AS A ON TA.au_id = A.au_id
  WHERE A.au_id IN ('267-41-2394', '213-46-8915') /*La primera ID es Michael O'Leary y la segunda es Marjorie Green*/
  GROUP BY E.fname, E.lname

  --9.  Número de ejemplares vendidos de cada libro, especificando el título y el tipo. 
  -- ESTÁ BIEN QUE YO SEPA

  SELECT DISTINCT T.title, T.[type], SUM(S.qty) AS Ventas
  FROM titles AS T
  LEFT JOIN sales AS S ON T.title_id = S.title_id
  GROUP BY T.title, T.[type]


 --10.  Número de ejemplares de todos sus libros que ha vendido cada autor. ESTÁ BIEN QUE YO SEPA

 SELECT A.au_fname, A.au_lname, SUM(S.qty) AS Ventas FROM sales AS S
 INNER JOIN titles AS T ON T.title_id = S.title_id
 INNER JOIN titleauthor AS TA ON TA.title_id = T.title_id
 INNER JOIN authors AS A ON TA.au_id = A.au_id
 GROUP BY A.au_fname, A.au_lname

 --11.  Número de empleados de cada categoría (jobs). ESTÁ BIEN

 SELECT J.job_id, J.job_desc, COUNT(*) AS [Empleados] FROM employee AS E
 INNER JOIN jobs AS J ON E.job_id = J.job_id
 GROUP BY J.job_id, J.job_desc

 --12.  Número de empleados de cada categoría (jobs) que tiene cada editorial, incluyendo aquellas categorías en las que no haya ningún empleado.
 -- ESTÁ MAL, PORQUE NO SALE EN LAS QUE HAYA NINGUN EMPLEADO
 --Si no hay ningún empleado trabajando en una categoría particular, no va a existir una fila con el nombre de esa categoría y con información NULL si le haces join con empleados, sino que del tirón no aparece

 SELECT J.job_desc, P.pub_name, COUNT(*) AS [Empleados] FROM employee AS E
 INNER JOIN publishers AS P ON P.pub_id = E.pub_id
 RIGHT JOIN jobs AS J ON E.job_id = J.job_id
 GROUP BY J.job_desc, P.pub_name
 GO

 SELECT P.pub_name, J.job_id FROM employee AS E
 FULL JOIN publishers AS P ON P.pub_id = E.pub_id
 FULL JOIN jobs AS J ON E.job_id = J.job_id
 ORDER BY P.pub_name

 SELECT J.job_desc, E.fname, E.lname FROM employee AS E
 FULL JOIN jobs as J ON E.job_id = J.job_id
 ORDER BY J.job_desc


 --Estaría genial el pivot aquí

 --13.  Autores que han escrito libros de dos o más tipos diferentes ESTÁ BIEN

 SELECT A.au_fname, A.au_lname, T.[type] FROM authors AS A
 INNER JOIN titleauthor AS TA ON A.au_id = TA.au_id
 INNER JOIN titles AS T ON T.title_id = TA.title_id
 GROUP BY A.au_fname, A.au_lname
 HAVING COUNT(DISTINCT T.[type]) >= 2


 --14.  Empleados que no trabajan actualmente en editoriales que han publicado libros cuya columna notes contenga la palabra "and”
 -- ESTÁ BIEN
 SELECT E.fname, E.lname FROM publishers AS P
 FULL JOIN employee AS E ON P.pub_id = E.pub_id
 FULL JOIN titles AS T ON T.pub_id = P.pub_id

 EXCEPT

 SELECT E.fname, E.lname FROM publishers AS P
 FULL JOIN employee AS E ON P.pub_id = E.pub_id
 FULL JOIN titles AS T ON T.pub_id = P.pub_id
 WHERE T.notes LIKE '%and%'