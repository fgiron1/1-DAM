/*  1. Nombre de los proveedores y n�mero de productos que nos vende cada uno */

SELECT S.CompanyName, COUNT(P.ProductID) AS [Numero productos]
FROM Suppliers AS S
INNER JOIN Products AS P
ON S.SupplierID = P.SupplierID
GROUP BY S.CompanyName

/*	2. Nombre completo y telefono de los vendedores que trabajen en New York, eattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.*/

SELECT 

/*	3. N�mero de productos de cada categor�a y nombre de la categor�a.*/

SELECT C.CategoryName, COUNT(P.ProductID) AS [Numero productos]
FROM Products AS P
INNER JOIN Categories AS C
ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryName


/*	4. Nombre de la compa��a de todos los clientes que hayan comprado queso de cabrales o tofu.*/

SELECT C.CompanyName, P.ProductName
FROM Products AS P
INNER JOIN [Order Details] AS OD
ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O
ON OD.OrderID = O.OrderID
INNER JOIN Customers AS C
ON O.CustomerID = C.CustomerID
WHERE ProductName = 'Queso Cabrales' OR ProductName LIKE '%tofu%'
GO

/*	5. Empleados (ID, nombre, apellidos y tel�fono) que han vendido algo a Bon app' o Meter Franken.*/

SELECT E.EmployeeID, E.FirstName, E.LastName, E.HomePhone, E.Extension FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID = O.EmployeeID
WHERE ShipName IN ('Bon app''', 'Meter Franken')


/*	6. Empleados (ID, nombre, apellidos, mes y d�a de su cumplea�os) que no han vendido nunca nada a ning�n cliente de Francia. **/

SELECT DISTINCT E.EmployeeID, E.FirstName, E.LastName, YEAR(E.BirthDate) AS [A�o nacimiento], MONTH(E.BirthDate) AS [Mes nacimiento] FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID = O.EmployeeID
INNER JOIN Customers AS C
ON O.CustomerID = C.CustomerID

EXCEPT

SELECT DISTINCT E.EmployeeID, E.FirstName, E.LastName, YEAR(E.BirthDate) AS [A�o nacimiento], MONTH(E.BirthDate) AS [Mes nacimiento] FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID = O.EmployeeID
INNER JOIN Customers AS C
ON O.CustomerID = C.CustomerID
WHERE C.Country = 'France'

/*EMPLOYEE -> ORDER -> CUSTOMERS*/


/*	7. Total de ventas en US$ de productos de cada categor�a (nombre de la categor�a).*/

SELECT C.CategoryName, SUM(Quantity) AS [Ventas] FROM Categories AS C /**/
INNER JOIN Products AS P
ON P.CategoryID = C.CategoryID
INNER JOIN 

GROUP BY C.CategoryName

/*	8. Total de ventas en US$ de cada empleado cada a�o (nombre, apellidos, direcci�n).*/



/*	9. Ventas de cada producto en el a�o 97. Nombre del producto y unidades.*/



/*	10. Cu�l es el producto del que hemos vendido m�s unidades en cada pa�s. **/



/*	11. Empleados (nombre y apellidos) que trabajan a las �rdenes de Andrew Fuller.*/



/*	12. N�mero de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.*/



