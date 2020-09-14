USE Northwind

BEGIN TRANSACTION

--1. Deseamos incluir un producto en la tabla Products llamado "Cruzcampo lata” pero no estamos seguros si
--se ha insertado o no.
--El precio son 4,40, el proveedor es el 16, la categoría 1 y la cantidad por unidad es "Pack 6 latas”
--"Discontinued” toma el valor 0 y el resto de columnas se dejarán a NULL.
--Escribe un script que compruebe si existe un producto con ese nombre. En caso afirmativo, actualizará
--el precio y en caso negativo insertarlo.

GO


--He intentado utilizar @@ROWCOUNT pero no consegui hacer que funcionara

--Comprueba si es una consulta vacía

IF NOT EXISTS (SELECT ProductName
		  	   FROM Products
	           WHERE ProductName = 'Cruzcampo lata')
	
	BEGIN
		INSERT INTO Products(ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
		VALUES('Cruzcampo lata', 16, 1, 'Pack 6 latas', 4.40, NULL, NULL, NULL, 0)
	PRINT 'Datos insertados'
	END
	 
ELSE
	BEGIN
		UPDATE Products
		SET UnitPrice = 4.40
		WHERE ProductName = 'Cruzcampo lata'
		PRINT 'Precio actualizado'
	END

GO

--2. Comprueba si existe una tabla llamada ProductSales. Esta tabla ha de tener de cada producto el ID, el Nombre,
--el Precio unitario, el número total de unidades vendidas y el total de dinero facturado con ese producto.
--Si no existe, créala

GO
IF (OBJECT_ID('Northwind.dbo.ProductSales', 'U') IS NULL)
	
	BEGIN
		
		CREATE TABLE ProductSales(
		
			ProductID int NOT NULL,
			ProductName nvarchar(40) NOT NULL,
			UnitPrice money NULL,
			UnitsSold int NULL, --No puedo ponerlo como columnas calculadas porque necesito columnas de otras tablas
			BilledAmount money NULL, --No puedo ponerlo como columnas calculadas porque necesito columnas de otras tablas

			--Para hacer UnitsSold y BilledAmount columnas calculadas, otra opcion seria incluir las columnas
			--necesarias en esta tabla, pero el enunciado me pide especificamente estas 5 columnas, asi que no
			--creo que sea buena opcion

			CONSTRAINT FK_ProductID FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
			CONSTRAINT PK_ProductSales PRIMARY KEY (ProductID)

			--Como garantizo que el UnitPrice para un determinado ProductID es el UnitPrice de la tabla Products?

		)


		--El precio unitario mas reciente es el que esta en Products

		INSERT INTO ProductSales

			SELECT Sub1.ProductID, Sub1.ProductName, Sub1.UnitPrice, Sub2.Vendidos, Sub2.Facturado FROM

			(SELECT ProductID, ProductName, UnitPrice FROM Products) AS Sub1

			INNER JOIN

			(SELECT ProductID, SUM(Quantity) AS Vendidos, CAST(SUM(Quantity * UnitPrice * (1 - Discount)) AS money) AS Facturado FROM [Order Details]
			GROUP BY ProductID) AS Sub2

			ON Sub1.ProductID = Sub2.ProductID
			ORDER BY Sub1.ProductID
	END
GO

--3. Comprueba si existe una tabla llamada ShipShip. Esta tabla ha de tener de cada Transportista el ID,
--el Nombre de la compañía, el número total de envíos que ha efectuado y el número de países diferentes a los que ha
--llevado cosas. Si no existe, créala

GO
IF (OBJECT_ID('Northwind.dbo.ShipShip', 'U') IS NULL)

	BEGIN

		CREATE TABLE ShipShip(

			ShipperID int IDENTITY(1,1) NOT NULL,
			CompanyName nvarchar(40) NOT NULL,
			TotalShipments int NOT NULL,
			TotalCountries int NOT NULL,

			CONSTRAINT FK_ShipperID FOREIGN KEY (ShipperID) REFERENCES Shippers(ShipperID),
			CONSTRAINT PK_ShipShip PRIMARY KEY (ShipperID)

		)

		INSERT INTO ShipShip
		SELECT S.ShipperID, S.CompanyName, COUNT(*) AS NumeroEnvios, COUNT(DISTINCT O.ShipCountry) AS PaisesTotales  FROM Shippers AS S
		INNER JOIN Orders AS O ON O.ShipVia = S.ShipperID
		GROUP BY S.ShipperID, S.CompanyName

	END
GO


--4. Comprueba si existe una tabla llamada EmployeeSales. Esta tabla ha de tener de cada empleado su ID, el Nombre
--completo, el número de ventas totales que ha realizado, el número de clientes diferentes a los que ha vendido
--y el total de dinero facturado. Si no existe, créala.

GO
IF (OBJECT_ID('Northwind.dbo.EmployeeSales', 'U') IS NULL)

	BEGIN

		CREATE TABLE EmployeeSales(
		
			EmployeeID int IDENTITY(1,1) NOT NULL,
			LastName nvarchar(20) NOT NULL,
			FirstName nvarchar(10) NOT NULL,
			Sales int NOT NULL,
			Clients int NOT NULL,
			BilledAmount money NOT NULL

			CONSTRAINT FK_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
			CONSTRAINT PK_EmployeeSales PRIMARY KEY (EmployeeID)

		)

		INSERT INTO EmployeeSales
		SELECT

			E.EmployeeID,
			E.FirstName,
			E.LastName,
			COUNT(O.OrderID) AS Ventas,
			COUNT(DISTINCT O.CustomerID) AS Clientes,
			CAST(
				ISNULL(
					SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)), 0) AS money) AS TotalFacturado
			
		FROM Employees AS E
		LEFT JOIN Orders AS O ON O.EmployeeID = E.EmployeeID
		LEFT JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
		GROUP BY E.EmployeeID, E.FirstName, E.LastName


--5. Entre los años 96 y 97 hay productos que han aumentado sus ventas y otros que las han disminuido.
--Queremos cambiar el precio unitario según la tabla.

--Puedes crear dos vistas con el @Anio siendo 1996 y 1997 y no usar una funcion

GO
CREATE FUNCTION FNVentasAnio(@Anio AS int) RETURNS TABLE AS
RETURN 

SELECT P.ProductID, P.ProductName, SUM(OD.Quantity) AS UnidadesVendidas
FROM Products AS P
LEFT JOIN [Order Details] AS OD ON OD.ProductID = P.ProductID
LEFT JOIN Orders AS O ON O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = 1996
GROUP BY P.ProductID, P.ProductName

GO