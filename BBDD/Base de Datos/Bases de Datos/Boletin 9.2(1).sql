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

/**/



/**/



/**/



/**/



/**/



/**/



/**/



/**/



/**/



/**/


