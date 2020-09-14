/*1. N�mero de clientes de cada pa�s.*/

SELECT Country, COUNT(*) AS [Numero clientes] FROM Customers
GROUP BY Country

/*2. N�mero de clientes diferentes que compran cada producto. Incluye el nombre del producto*/

SELECT DISTINCT P.ProductName, COUNT(*) AS [Compradores]
FROM Customers AS C
INNER JOIN Orders AS O
ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] AS OD
ON OD.OrderID = O.OrderID
INNER JOIN Products as P
ON P.ProductID = OD.ProductID
GROUP BY P.ProductName

/*3. N�mero de pa�ses diferentes en los que se vende cada producto. Incluye el nombre del producto*/

SELECT P.ProductName, COUNT(O.ShipCountry) AS [Paises compradores]
FROM Orders AS O
INNER JOIN [Order Details] AS OD
ON OD.OrderID = O.OrderID
INNER JOIN Products AS P
ON P.ProductID = OD.ProductID
GROUP BY P.ProductName

/*4. Empleados (nombre y apellido) que han vendido alguna vez �Gudbrandsdalsost�, �Lakkalik��ri�, �Tourti�re� o �Boston Crab Meat�. */

SELECT E.FirstName, E.LastName
FROM Employees AS E
INNER JOIN Orders AS O
ON O.EmployeeID = E.EmployeeID
INNER JOIN [Order Details] AS OD
ON OD.OrderID = O.OrderID
INNER JOIN Products AS P
ON P.ProductID = OD.ProductID
WHERE P.ProductName IN ('Gudbrandsdalsost','Lakkalik��ri','Tourti�re','Boston Crab Meat') 


/*5. Empleados que no han vendido nunca �Northwoods Cranberry Sauce� o �Carnarvon Tigers�.*/

SELECT E.FirstName, E.LastName
FROM Employees AS E
INNER JOIN Orders AS O
ON O.EmployeeID = E.EmployeeID
INNER JOIN [Order Details] AS OD
ON OD.OrderID = O.OrderID
INNER JOIN Products AS P
ON P.ProductID = OD.ProductID
WHERE P.ProductName NOT IN ('Northwoods Cranberry Sauce','Carnarvon Tigers')

/*6. N�mero de unidades de cada categor�a de producto que ha vendido cada empleado. Incluye el nombre y apellidos del empleado y el nombre de la categor�a. */

SELECT C.CategoryName, E.FirstName, E.LastName, COUNT(*) AS [Ventas]
FROM Employees AS E
INNER JOIN Orders AS O
ON O.EmployeeID = E.EmployeeID
INNER JOIN [Order Details] AS OD
ON OD.OrderID = O.OrderID
INNER JOIN Products AS P
ON P.ProductID = OD.ProductID
INNER JOIN Categories AS C
ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName, E.FirstName, E.LastName

/*7.Total de ventas (US$) de cada categor�a en el a�o 97. Incluye el nombre de la categor�a*/

SELECT C.CategoryName, FORMAT (SUM(OD.UnitPrice * OD.Quantity), 'C', 'us-US') AS [Total vendido]
FROM Orders AS O
INNER JOIN [Order Details] as OD
ON OD.OrderID = O.OrderID
INNER JOIN Products AS P
ON P.ProductID = OD.ProductID
INNER JOIN Categories AS C
ON C.CategoryID = P.CategoryID
WHERE YEAR(O.OrderDate) = '1997'
GROUP BY C.CategoryName


/*8. Productos que han comprado m�s de un cliente del mismo pa�s, indicando el
nombre del producto, el pa�s y el n�mero de clientes distintos de ese pa�s que
lo han comprado. */

Products -> Order Details -> Orders -> Customers

SELECT P.ProductName, C.Country, SUM()
FROM Products AS P
INNER JOIN [Order Details] AS OD
ON OD.ProductID = P.ProductID
INNER JOIN Orders AS O
ON O.OrderID = OD.OrderID
INNER JOIN Customers AS C
ON O.CustomerID = C.CustomerID
WHERE (COUNT *) > 1


/*9. Total de ventas (US$) en cada pa�s cada a�o*/



/*10. Producto superventas de cada a�o, indicando a�o, nombre del producto,
categor�a y cifra total de ventas*/



/*11. Cifra de ventas de cada producto en el a�o 97 y su aumento o disminuci�n
respecto al a�o anterior en US $ y en %*/



/*12. Mejor cliente (el que m�s nos compra) de cada pa�s. */



/*13. N�mero de productos diferentes que nos compra cada cliente. Incluye el
nombre y apellidos del cliente y su direcci�n completa. */



/**/



/**/



/**/


