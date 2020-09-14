
  --1.  Título y tipo de todos los libros en los que alguno de los autores vive en California (CA).

  SELECT T.title, T.type, A.au_fname, A.au_lname FROM Titles AS T
  INNER JOIN titleauthor AS TA
  ON TA.title_id = T.title_id
  INNER JOIN authors AS A
  ON A.au_id = TA.au_id
  WHERE A.state = 'CA'
  ORDER BY T.title
  
  --The Gourmet Microwave tiene dos autores, siendo uno de ellos californiano y el otro no

  SELECT * FROM titleauthor
  ORDER BY title_id

  SELECT * FROM titles

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


  SELECT * FROM publishers
  SELECT * FROM authors
  SELECT * FROM titleauthor
  SELECT * FROM titles

  --5.  Número de empleados de cada editorial.

  SELECT P.pub_name, COUNT(E.emp_id) AS [Empleados] FROM employee as E
  INNER JOIN publishers AS P ON P.pub_id = E.pub_id
  GROUP BY P.pub_id, pub_name


  --6.  Calcular la relación entre número de ejemplares publicados y número de empleados de cada editorial, incluyendo el nombre de la misma.

   SELECT (T.title/consulta anterior) FROM titles as T

  --7.  Nombre, Apellidos y ciudad de todos los autores que han trabajado para la editorial "Binnet & Hardley” o "Five Lakes Publishing”



  --8.  Empleados que hayan trabajado en alguna editorial que haya publicado algún libro en el que alguno de los autores fuera Marjorie Green o Michael O'Leary.



  --9.  Número de ejemplares vendidos de cada libro, especificando el título y el tipo.



 --10.  Número de ejemplares de todos sus libros que ha vendido cada autor.



 --11.  Número de empleados de cada categoría (jobs).



 --12.  Número de empleados de cada categoría (jobs) que tiene cada editorial, incluyendo aquellas categorías en las que no haya ningún empleado.



 --13.  Autores que han escrito libros de dos o más tipos diferentes



 --14.  Empleados que no trabajan actualmente en editoriales que han publicado libros cuya columna notes contenga la palabra "and”


