USE Northwind
GO

/*1*/
SELECT CompanyName, Address FROM Customers
WHERE Country <> 'USA'

/*2*/
SELECT CompanyName, Address FROM Customers
WHERE Country <> 'USA'
Order By Country, City

/*3*/
SELECT FirstName, LastName, City, (YEAR (CURRENT_TIMESTAMP - BirthDate) - 1900) AS 'Edad', HireDate FROM Employees
Order By HireDate
GO

/*4*/
SELECT ProductName, UnitPrice FROM Products
Order By UnitPrice Desc
GO

/*5*/
SELECT CompanyName, Address FROM Suppliers
WHERE Country = 'USA' OR 
	  Country = 'Canada'OR
	  Country = 'Mexico'
GO

/*6*/
SELECT ProductName, UnitsInStock, UnitsInStock * UnitPrice FROM Products
WHERE CategoryID <> 4
GO

/*7*/
SELECT CompanyName, ContactName, Address FROM Customers
WHERE (Country <> 'USA' OR  Country <> 'Canada' OR Country <> 'Mexico') AND ContactTitle <> 'Owner'
GO

/*8*/
SELECT CustomerID, COUNT(CustomerID) AS [Numero de pedidos] FROM Orders
GROUP BY CustomerID
ORDER BY [Numero de pedidos] DESC

/*9*/
SELECT ShipCity, COUNT(ShipCity) AS [Numero de pedidos] FROM Orders
GROUP BY ShipCity

/*10*/
SELECT CategoryID, COUNT(CategoryID) AS [Numero de productos] FROM Products
GROUP BY CategoryID

SELECT * FROM Products