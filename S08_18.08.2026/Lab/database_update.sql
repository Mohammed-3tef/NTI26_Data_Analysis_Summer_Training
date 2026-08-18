USE PracticeDB;
GO
 
ALTER TABLE dbo.Customers ADD Email VARCHAR(60) NULL;
GO
 
ALTER TABLE dbo.Orders ADD DiscountPercent DECIMAL(5,2) NULL, ShipDate DATE NULL;
GO
 
ALTER TABLE dbo.Employees ADD Bonus DECIMAL(10,2) NULL;
GO


UPDATE dbo.Customers SET Email = 'youssef.ali@example.com'   WHERE CustomerID = 1;
UPDATE dbo.Customers SET Email = 'mona.adel@example.com'     WHERE CustomerID = 2;
UPDATE dbo.Customers SET Email = 'salma.nabil@example.com'   WHERE CustomerID = 4;
UPDATE dbo.Customers SET Email = 'ziad.fathy@example.com'    WHERE CustomerID = 5;
UPDATE dbo.Customers SET Email = 'rania.samir@example.com'   WHERE CustomerID = 7;
UPDATE dbo.Customers SET Email = 'tarek.youssef@example.com' WHERE CustomerID = 8;
UPDATE dbo.Customers SET Email = 'heba.ahmed@example.com'    WHERE CustomerID = 9;
GO
 
UPDATE dbo.Orders SET DiscountPercent = 5.00,  ShipDate = '2026-03-03' WHERE OrderID = 101;
UPDATE dbo.Orders SET DiscountPercent = NULL,  ShipDate = '2026-03-02' WHERE OrderID = 102;
UPDATE dbo.Orders SET DiscountPercent = 10.00, ShipDate = '2026-03-10' WHERE OrderID = 103;
UPDATE dbo.Orders SET DiscountPercent = NULL,  ShipDate = NULL         WHERE OrderID = 104; 
UPDATE dbo.Orders SET DiscountPercent = 0.00,  ShipDate = '2026-03-04' WHERE OrderID = 105; 
UPDATE dbo.Orders SET DiscountPercent = 5.00,  ShipDate = '2026-03-08' WHERE OrderID = 106;
UPDATE dbo.Orders SET DiscountPercent = NULL,  ShipDate = '2026-03-07' WHERE OrderID = 107;
UPDATE dbo.Orders SET DiscountPercent = 15.00, ShipDate = '2026-03-09' WHERE OrderID = 108;
UPDATE dbo.Orders SET DiscountPercent = NULL,  ShipDate = '2026-03-08' WHERE OrderID = 109; 
UPDATE dbo.Orders SET DiscountPercent = 5.00,  ShipDate = '2026-03-16' WHERE OrderID = 110;
UPDATE dbo.Orders SET DiscountPercent = NULL,  ShipDate = '2026-03-11' WHERE OrderID = 111;
UPDATE dbo.Orders SET DiscountPercent = 10.00, ShipDate = '2026-03-12' WHERE OrderID = 112;
UPDATE dbo.Orders SET DiscountPercent = NULL,  ShipDate = '2026-03-20' WHERE OrderID = 113;
UPDATE dbo.Orders SET DiscountPercent = 5.00,  ShipDate = '2026-03-14' WHERE OrderID = 114;
UPDATE dbo.Orders SET DiscountPercent = NULL,  ShipDate = '2026-03-15' WHERE OrderID = 115;
UPDATE dbo.Orders SET DiscountPercent = 20.00, ShipDate = NULL         WHERE OrderID = 116; 
UPDATE dbo.Orders SET DiscountPercent = NULL,  ShipDate = '2026-03-17' WHERE OrderID = 117;
UPDATE dbo.Orders SET DiscountPercent = NULL,  ShipDate = '2026-03-18' WHERE OrderID = 118;
UPDATE dbo.Orders SET DiscountPercent = 5.00,  ShipDate = '2026-03-19' WHERE OrderID = 119;
UPDATE dbo.Orders SET DiscountPercent = NULL,  ShipDate = '2026-03-20' WHERE OrderID = 120;
GO
 
UPDATE dbo.Employees SET Bonus = ROUND(Salary * 0.08, 2);
UPDATE dbo.Employees SET Bonus = NULL
WHERE EmployeeID IN (3, 5, 9, 12, 15, 18, 21, 24, 27, 30, 33);
GO
 