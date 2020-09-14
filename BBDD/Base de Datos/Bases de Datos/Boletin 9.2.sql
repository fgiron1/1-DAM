/*1. Número de clientes de cada país.*/

SELECT Country, COUNT(*) AS [Numero clientes] FROM Customers
GROUP BY Country

/*2. Número de clientes diferentes que compran cada producto. Incluye el nombre del producto*/

SELECT DISTINCT P.ProductName, COUNT(*) AS [Compradores]
FROM Customers AS C
INNER JOIN Orders AS O
ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] AS OD
ON OD.OrderID = O.OrderID
INNER JOIN Products as P
ON P.ProductID = OD.ProductID
GROUP BY P.ProductName

/*3. Número de países diferentes en los que se vende cada producto. Incluye el nombre del producto*/

SELECT P.ProductName, COUNT(O.ShipCountry) AS [Paises compradores]
FROM Orders AS O
INNER JOIN [Order Details] AS OD
ON OD.OrderID = O.OrderID
INNER JOIN Products AS P
ON P.ProductID = OD.ProductID
GROUP BY P.ProductName

/*4. Empleados (nombre y apellido) que han vendido alguna vez “Gudbrandsdalsost”, “Lakkalikööri”, “Tourtière” o “Boston Crab Meat”. */

SELECT E.FirstName, E.LastName
FROM Employees AS E
INNER JOIN Orders AS O
ON O.EmployeeID = E.EmployeeID
INNER JOIN [Order Details] AS OD
ON OD.OrderID = O.OrderID
INNER JOIN Products AS P
ON P.ProductID = OD.ProductID
WHERE P.ProductName IN ('Gudbrandsdalsost','Lakkalikööri','Tourtière','Boston Crab Meat') 


/*5. Empleados que no han vendido nunca “Northwoods Cranberry Sauce” o “Carnarvon Tigers”.*/

SELECT E.FirstName, E.LastName
FROM Employees AS E
INNER JOIN Orders AS O
ON O.EmployeeID = E.EmployeeID
INNER JOIN [Order Details] AS OD
ON OD.OrderID = O.OrderID
INNER JOIN Products AS P
ON P.ProductID = OD.ProductID
WHERE P.ProductName NOT IN ('Northwoods Cranberry Sauce','Carnarvon Tigers')

/*6. Número de unidades de cada categoría de producto que ha vendido cada empleado. Incluye el nombre y apellidos del empleado y el nombre de la categoría. */

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

/*7.Total de ventas (US$) de cada categoría en el año 97. Incluye el nombre de la categoría*/

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


/*8. Productos que han comprado más de un cliente del mismo país, indicando el
nombre del producto, el país y el número de clientes distintos de ese país que
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


/*9. Total de ventas (US$) en cada país cada año*/



/*10. Producto superventas de cada año, indicando año, nombre del producto,
categoría y cifra total de ventas*/



/*11. Cifra de ventas de cada producto en el año 97 y su aumento o disminución
respecto al año anterior en US $ y en %*/



/*12. Mejor cliente (el que más nos compra) de cada país. */



/*13. Número de productos diferentes que nos compra cada cliente. Incluye el
nombre y apellidos del cliente y su dirección completa. */



/**/



/**/



/**/


