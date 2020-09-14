BEGIN TRANSACTION

--1.Inserta un nuevo cliente.
INSERT INTO Customers
VALUES ('PABMO',
		'Mère Paillarde',
		'Pablo Motos',
		'Sales Associate',
		'Via Ludovico il Moro 26',
		'Bergamo',
		NULL,
		'24100',
		'Italy',
		'035-6413872',
		NULL)

GO

--2.Véndele (hoy) tres unidades de "Pavlova”, diez de "Inlagd Sill” y 25 de "Filo Mix”.
--El distribuidor será Speedy Express y el vendedor Laura Callahan.

INSERT INTO Orders --No hace falta introducir el OrderID porque se genera automaticamente
VALUES ('PABMO',
		'8',
		CURRENT_TIMESTAMP,
		CURRENT_TIMESTAMP + 10,
		NULL,
		'1', --Es 1 porque Speedy Express es 1 en su tabla (ShipVia es FK de la tabla Shippers)
		'51.05',
		'Mère Paillarde',
		'Via Ludovico il Moro 26',
		'Bergamo',
		NULL,
		'24100',
		'Italy'

)

SELECT * FROM Orders
WHERE CustomerID = 'PABMO'

SELECT * FROM [Order Details] AS OD
WHERE OD.OrderID = 11080

INSERT INTO [Order Details]
VALUES ('11078',
		'16', --Pavlova 16
		'17.45',
		'3',
		'0'
)

INSERT INTO [Order Details]
VALUES ('11078',
		'52', --Filo Mix 52
		'7.00',
		'25',
		'0'
)

INSERT INTO [Order Details]
VALUES ('11078',
		'36', --Inlagd Sill 36
		'19.00',
		'10',
		'0'
)


--Ante la bajada de ventas producida por la crisis, hemos de adaptar nuestros precios según las siguientes reglas:

--1. Los productos de la categoría de bebidas (Beverages) que cuesten más de $10 reducen su precio en un dólar.
--2. Los productos de la categoría Lácteos que cuesten más de $5 reducen su precio en un 10%.
--3. Los productos de los que se hayan vendido menos de 200 unidades en el último año, reducen su precio en un 5%

--1.
UPDATE Products
SET UnitPrice = UnitPrice - 1
WHERE ProductID IN (SELECT P.ProductID FROM Products AS P
					INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID
					WHERE C.CategoryName = 'Beverages' AND P.UnitPrice > '10.00'
					)


--2.
UPDATE Products
SET UnitPrice = UnitPrice * 0.90
WHERE ProductID IN (SELECT P.ProductID FROM Products AS P
					INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID
					WHERE C.CategoryName = 'Dairy Products' AND P.UnitPrice > '5.00'
					)


--3.
--Los productos de los cuales se han vendido menos de 200 unidades en el ultimo año
--reducen su precio en un 5%
--Yo por ultimo año entiendo el año anterior al actual

--La ID de los productos de los cuales se han vendido menos de 200 ud. el ultimo año
SELECT P.ProductID FROM Products AS P
INNER JOIN [Order Details] AS OD ON OD.ProductID = P.ProductID
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = YEAR(CURRENT_TIMESTAMP)
GROUP BY P.ProductID
HAVING SUM(OD.Quantity) < 200

--La actualización final

UPDATE Products
SET UnitPrice = UnitPrice * 0.95
WHERE ProductID IN (SELECT P.ProductID FROM Products AS P
					LEFT JOIN [Order Details] AS OD ON OD.ProductID = P.ProductID
					LEFT JOIN Orders AS O ON O.OrderID = OD.OrderID
					WHERE YEAR(O.OrderDate) = YEAR(CURRENT_TIMESTAMP)
					GROUP BY P.ProductID
					HAVING SUM(OD.Quantity) < 200)
					
					

--4. Inserta un nuevo vendedor llamado Michael Trump. Asígnale los territorios de Louisville, Phoenix, Santa Cruz y Atlanta.

INSERT INTO Employees
VALUES ('Trump',
		'Michael',
		'Sales Representative',
		'Mr.',
		'1947-11-02 00:00:00.000',
		'1993-01-05 00:00:00.000',
		'25 Ivory Tower',
		'Seattle',
		'WA',
		'98105',
		'USA',
		NULL,
		NULL,
		NULL,
		NULL,
		2,
		NULL)

--Consulta que me devuelve el empleado que yo quiera

--Esta función me devuelve el ID de un empleado que se corresponde con el nombre introducido

GO
CREATE FUNCTION FNDeNombreAID(@Nombre AS nvarchar(10), @Apellido AS nvarchar(20)) RETURNS TABLE AS
RETURN
SELECT EmployeeID FROM Employees
WHERE FirstName = @Nombre AND LastName = @Apellido

GO

--Esta función me devuelve el ID de un territorio que se corresponde son el nombre introducido
GO
CREATE FUNCTION FNDeTerritorioAID (@Territorio AS nchar(50)) RETURNS TABLE AS
RETURN
SELECT TerritoryID FROM Territories
WHERE TerritoryDescription = @Territorio
GO


--Asi es mas facil añadirle a otros vendedores mas territorios
SELECT * FROM FNDeTerritorioAID('Louisville')

INSERT INTO EmployeeTerritories
VALUES  (
		(SELECT * FROM FNDeNombreAID('Michael', 'Trump')),
		(SELECT * FROM FNDeTerritorioAID('Louisville')) 
		),

		(
		(SELECT * FROM FNDeNombreAID('Michael', 'Trump')),
		(SELECT * FROM FNDeTerritorioAID('Santa Cruz')) 
		),

		(
		(SELECT * FROM FNDeNombreAID('Michael', 'Trump')),
		(SELECT * FROM FNDeTerritorioAID('Atlanta')) 
		),

		(
		(SELECT * FROM FNDeNombreAID('Michael', 'Trump')),
		(SELECT * FROM FNDeTerritorioAID('Phoenix')) 
		)


--5. Haz que las ventas del año 97 de Robert King que haya hecho a clientes de los estados de California
--y Texas se le asignen al nuevo empleado.

--Ventas del año 97 hechas por Robert King a clientes de california y texas

SELECT O.OrderID FROM Orders AS O
WHERE O.EmployeeID = (SELECT * FROM FNDeNombreAID('Robert', 'King')) AND 
YEAR(O.OrderDate) = '1997' AND
(O.ShipRegion = 'CA' OR O.ShipRegion = 'TX') --En ShipRegion se pone el nombre del estado




UPDATE Orders
SET EmployeeID = (SELECT * FROM FNDeNombreAID('Michael', 'Trump'))
WHERE OrderID IN (SELECT O.OrderID FROM Orders AS O
				  WHERE O.EmployeeID = (SELECT * FROM FNDeNombreAID('Robert', 'King')) AND 
				  YEAR(O.OrderDate) = '1997' AND
				  (O.ShipRegion = 'CA' OR O.ShipRegion = 'TX'))

--Actualizacion final (0 filas afectadas porque Robert King no ha vendido nada en el 97 ni en california ni en texas)
--Como se puede ver en esta consulta

SELECT * FROM Orders
WHERE ShipCountry = 'USA' AND EmployeeID = (SELECT * FROM FNDeNombreAID('Robert','King'))
ORDER BY ShipRegion

--6. Inserta un nuevo producto con los siguientes datos:

--  ProductID: 90
--  ProductName: Nesquick Power Max
--  SupplierID: 12
--  CategoryID: 3
--  QuantityPerUnit: 10 x 300g
--  UnitPrice: 2,40
--  UnitsInStock: 38
--  UnitsOnOrder: 0
--  ReorderLevel: 0
--  Discontinued: 0

INSERT INTO Products --No puedo ponerle de ID el valor 90 porque es autogenerado
VALUES ('Nesquick Power Max',
		12,
		3,
		'10 x 300g',
		'2.40',
		'38',
		'0',
		'0',
		'0')



INSERT INTO Products --No puedo ponerle de ID el valor 91 porque es autogenerado
VALUES ('Mecca Cola',
		1,
		1,
		'6 x 75cl',
		7.35,
		14,
		0,
		0,
		0)

--11. Todos los que han comprado "Outback Lager" han comprado cinco años después la misma cantidad de
-- Mecca Cola al mismo vendedor

--Todos los que han comprado outback lager, el vendedor a quien se los han comprado, el año

GO
CREATE VIEW GenteLager AS

(SELECT O.CustomerID, O.EmployeeID, YEAR(O.OrderDate), SUM(OD.Quantity) AS Cantidad FROM Orders AS O
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
WHERE P.ProductName = 'Outback Lager'
GROUP BY O.CustomerID, O.EmployeeID, YEAR(O.OrderDate))

GO

SELECT * FROM Orders

INSERT INTO Orders(Las columnas que me interesan)
VALUES (GenteLager.cosa,
		GenteLager.cosa2,
		GenteLager.cosa3)

		
