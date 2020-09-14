-- 10. Producto superventas de cada año, indicando año, nombre del producto,
--categoría y cifra total de ventas.

--Revisar todo esto e incluir las ID de las cosas cuyo nombre este puesto, para evitar el problema de la ambiguedad entre nombres iguales pero distintas ID



SELECT Sub3.ProductID, Sub3.ProductName, Sub3.CategoryName, Sub2.Anio, Sub2.Superventas FROM

(SELECT MAX(Sub1.[Cantidad anual]) AS Superventas, Sub1.Anio FROM
--En el corregido pone COUNT(OD.ProductID) como la cantidad de product, pero en realidad lo que me piden es la cantidad comprada para cada OD.ProductID, que es la OD.Quantity, no?
(SELECT OD.ProductID, P.ProductName, SUM(OD.Quantity) AS [Cantidad anual], YEAR(O.OrderDate) AS Anio FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID
GROUP BY OD.ProductID, P.ProductName, YEAR(O.OrderDate)) AS Sub1
GROUP BY Sub1.Anio) AS Sub2

INNER JOIN

(SELECT OD.ProductID, P.ProductName, SUM(OD.Quantity) AS [Cantidad anual], YEAR(O.OrderDate) AS Anio, C.CategoryName FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID
GROUP BY OD.ProductID, P.ProductName, YEAR(O.OrderDate), C.CategoryName) AS Sub3

ON Sub2.Superventas = Sub3.[Cantidad anual]























--Esta me da el dinero, no la cantidad, por eso está comentada
/*SELECT Sub4.ProductName, Sub2.Anho, Sub2.Superventas FROM

(SELECT Sub1.Anho, MAX(Sub1.Ventas) AS Superventas FROM
(SELECT P.ProductName, YEAR(O.OrderDate) AS Anho, SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS Ventas  FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductiD
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
GROUP BY P.ProductName, YEAR(O.OrderDate)) AS Sub1

GROUP BY Sub1.Anho) AS Sub2

INNER JOIN

(SELECT Sub3.ProductName, Sub3.Anho, Sub3.Ventas FROM
(SELECT P.ProductName, YEAR(O.OrderDate) AS Anho, SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS Ventas  FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductiD
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
GROUP BY P.ProductName, YEAR(O.OrderDate)) AS Sub3

) AS Sub4

ON Sub2.Anho = Sub4.Anho AND
	Sub2.Superventas = Sub4.Ventas

-- A TRAVÉS DE ESTA CONSULTA COMPRUEBO MANUALMENTE QUE LOS RESULTADOS DE LA ANTERIOR SON CORRECTOS
SELECT P.ProductName, YEAR(O.OrderDate) AS Anho, SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS Ventas  FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductiD
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
GROUP BY P.ProductName, YEAR(O.OrderDate)
ORDER BY Anho, Ventas DESC*/

-- 11. Cifra de ventas de cada producto en el año 97 y su aumento o disminución
--respecto al año anterior en US $ y en %.


SELECT Ventas97.ProductID, Ventas97.ProductName,
FORMAT (Ventas96.Ventas, 'C', 'en-US') AS [Ventas 1996],
FORMAT (Ventas97.Ventas, 'C', 'en-US') AS [Ventas 1997],
FORMAT (((Ventas97.Ventas/Ventas96.Ventas - 1) * 100), 'P') AS DiferenciaPorcentaje,
FORMAT ((Ventas97.Ventas - Ventas96.Ventas), 'C', 'en-US') AS DiferenciaCantidad FROM

(SELECT P.ProductName, P.ProductID, SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS Ventas FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = '1996'
GROUP BY P.ProductName, P.ProductID) AS Ventas96

INNER JOIN

(SELECT P.ProductName, P.ProductID, SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS Ventas FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = '1997'
GROUP BY P.ProductName, P.ProductID) AS Ventas97

ON Ventas97.ProductID = Ventas96.ProductID

--La clave está en poner ON Anio1.anio = Anio2.anio + 1

-- 12. Mejor cliente (el que más nos compra) de cada país.

--Yo creo que se puede interpretar de varias maneras:
--El que más nos compra es el MAX(COUNT(DISTINCT OD.OrderID)) --> El que más pedidos nos ha hecho. 
--En el corregido han usado COUNT(O.CustomerID), pero en la consulta de abajo se puede ver que hay filas que tienen Quantity y OrderID en null
--El que más nos compra es el MAX(SUM(OD.Quantity)) --> El que más cantidad ha comprado. 
--O ordenarlo no por cantidad, sino por el dinero que invierten

--Voy a usar MAX(COUNT(DISTINCT OD.OrderID)) porque creo que es el que más se ajusta al enunciado

---------------------------------
SELECT C.CustomerID, C.ContactName, C.Country, OD.Quantity, OD.OrderID FROM Customers AS C
FULL JOIN Orders AS O ON O.CustomerID = C.CustomerID
FULL JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
ORDER BY C.CustomerID
---------------------------------

GO

CREATE VIEW ComprasCadaCliente AS

SELECT C.CustomerID, C.ContactName, C.Country, COUNT(DISTINCT OD.OrderID) AS Compras FROM Customers AS C
INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
GROUP BY C.CustomerID, C.ContactName, C.Country

GO

DROP VIEW ComprasCadaCliente

GO

CREATE VIEW VentasMaximasPorPais AS

SELECT Sub2.Country, MAX(Sub2.Compras) AS Superventas FROM
(SELECT C.CustomerID, C.ContactName, C.Country, COUNT(DISTINCT OD.OrderID) AS Compras FROM Customers AS C
INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
GROUP BY C.CustomerID, C.ContactName, C.Country) AS Sub2
GROUP BY Sub2.Country

GO



SELECT ComprasCadaCliente.CustomerID, ComprasCadaCliente.ContactName, VentasMaximasPorPais.Country, VentasMaximasPorPais.Superventas FROM

ComprasCadaCliente INNER JOIN VentasMaximasPorPais

ON ComprasCadaCliente.Compras = VentasMaximasPorPais.Superventas
AND ComprasCadaCliente.Country = VentasMaximasPorPais.Country

ORDER BY ComprasCadaCliente.Country

--MARIA ANDERS NO ES DE ARGENTINA, LO QUE PASA ES QUE LE HE DICHO QUE CUANDO COINCIDA LA SUPERVENTA CON LA VENTA, LE PEGUE AL NOMBRE DE CONTACTO E ID, EL PAIS Y LAS SUPERVENTAS, ENTONCES CLARO, SI EL PAIS DE LA SUPERVENTA ES ARGENTINA CON 6 VENTAS, EN CUANTO APAREZCA OTRO CON 6 VENTAS LE VA A PONER ARGENTINA

ORDER BY VentasMaximasPorPais.Country

------------ALTERNATIVA USANDO ESTRATEGIA DE PONER where ventas IN (Subconsulta que me devuelva solo una columna que sean las superventas)
--En el caso de que haya un group by, en lugar de ponerlo en el where lo pongo en el having
--No sale bien

SELECT C.CustomerID, C.ContactName, C.Country, COUNT(DISTINCT OD.OrderID) AS Compras FROM Customers AS C
INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
GROUP BY C.CustomerID, C.ContactName, C.Country
HAVING COUNT(DISTINCT OD.OrderID) IN

(SELECT MAX(Sub2.Compras) AS Superventas FROM
(SELECT C.CustomerID, C.ContactName, C.Country, COUNT(DISTINCT OD.OrderID) AS Compras FROM Customers AS C
INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
GROUP BY C.CustomerID, C.ContactName, C.Country) AS Sub2
GROUP BY Sub2.Country)







--Esta me da el dinero, por eso está comentada
/*SELECT Sub2.ContactName, Sub1.Country, Sub1.Superventas FROM (

(
SELECT Eo.Country, MAX(Eo.Ventas) AS Superventas FROM 
(SELECT C.ContactName, C.Country, 
FORMAT(SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)), 'C', 'en-US') AS Ventas FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
GROUP BY C.Country, C.ContactName) AS Eo
GROUP BY Eo.Country

) AS Sub1

INNER JOIN 

(
SELECT C.ContactName, C.Country, 
FORMAT (SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)), 'C', 'en-US') AS Ventas FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
GROUP BY C.Country, C.ContactName

) AS Sub2

ON Sub2.Ventas = Sub1.Superventas)
ORDER BY Sub2.Country*/

-- 13. Número de productos diferentes que nos compra cada cliente. Incluye el
--nombre y apellidos del cliente y su dirección completa.

SELECT C.CustomerID, C.ContactName, C.[Address], COUNT(DISTINCT OD.ProductID) AS Cantidad FROM Customers AS C
INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
GROUP BY C.CustomerID, C.ContactName, C.[Address]

-- 14. Clientes que nos compran más de cinco productos diferentes.

SELECT C.CustomerID, C.ContactName, C.[Address], COUNT(DISTINCT OD.ProductID) AS Cantidad FROM Customers AS C
INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
GROUP BY C.CustomerID, C.ContactName, C.[Address]
HAVING COUNT(DISTINCT OD.ProductID) > 5

-- 15. Vendedores (nombre y apellidos) que han vendido una mayor cantidad que la
--media en US $ en el año 97.

--Lo que ha vendido cada uno en el 97
--Sub1 es lo mismo y a eso se le hace la media. Sólo se coge a través del HAVING a los que superen la media

SELECT E.EmployeeID, E.FirstName, E.LastName, SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS Ventas FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = '1997'
GROUP BY E.EmployeeID, E.FirstName, E.LastName
HAVING SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) > 


(SELECT AVG(Sub1.Ventas) AS Ventas FROM
(SELECT SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS Ventas FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = '1997'
GROUP BY E.EmployeeID, E.FirstName, E.LastName) AS Sub1)

-- 16. Empleados que hayan aumentado su cifra de ventas más de un 10% entre dos
--años consecutivos, indicando el año en que se produjo el aumento. 

--Cifra de ventas de cada empleado en cada año
--El DISTINCT este lo he puesto porque me ayuda, pero no sé por qué me salen tantas filas repetidas de vendedores en el mismo año
SELECT DISTINCT Sub1.EmployeeID, Sub1.FirstName, Sub1.LastName, Sub1.Anio FROM 
(SELECT E.EmployeeID, E.FirstName, E.LastName, YEAR(O.OrderDate) AS Anio, SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS Ventas FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
GROUP BY E.EmployeeID, E.FirstName, E.LastName, YEAR(O.OrderDate)) AS Sub1
--Da 27 filas. Anne Dodsworth ha vendido en el 96, 97 y 98

INNER JOIN
--Cifra de ventas de cada empleado en el año siguiente

(SELECT E.EmployeeID, E.FirstName, E.LastName, YEAR(O.OrderDate) AS Anio, SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS Ventas FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
GROUP BY E.EmployeeID, E.FirstName, E.LastName, YEAR(O.OrderDate)) AS Sub2

ON Sub1.Anio = Sub2.Anio+1
WHERE Sub2.Ventas >= (Sub1.Ventas * 1.10)