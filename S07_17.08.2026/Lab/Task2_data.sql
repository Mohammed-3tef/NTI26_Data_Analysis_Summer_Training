USE PracticeDB;
GO
CREATE TABLE dbo.Customers (
    CustomerID   INT PRIMARY KEY,
    CustomerName VARCHAR(50) NOT NULL,
    City         VARCHAR(30) NOT NULL
);
GO
 
CREATE TABLE dbo.Orders (
    OrderID      INT PRIMARY KEY,
    CustomerID   INT            NOT NULL,  
    ProductName  VARCHAR(50)    NOT NULL,
    Amount       DECIMAL(10,2)  NOT NULL,
    OrderDate    DATE           NOT NULL
);
GO
 
INSERT INTO dbo.Customers (CustomerID, CustomerName, City) VALUES
(1,  'Youssef Ali',    'Cairo'),
(2,  'Mona Adel',      'Giza'),
(3,  'Karim Hussein',  'Alexandria'),
(4,  'Salma Nabil',    'Cairo'),
(5,  'Ziad Fathy',     'Mansoura'),
(6,  'Nour Kamal',     'Cairo'),
(7,  'Rania Samir',    'Giza'),
(8,  'Tarek Youssef',  'Alexandria'),
(9,  'Heba Ahmed',     'Cairo'),      
(10, 'Omar Khaled',    'Tanta');      
GO
 
INSERT INTO dbo.Orders (OrderID, CustomerID, ProductName, Amount, OrderDate) VALUES
(101, 1,  'Laptop',    750.00, '2026-03-01'),
(102, 1,  'Mouse',     15.00,  '2026-03-01'),
(103, 2,  'Keyboard',  25.00,  '2026-03-02'),
(104, 3,  'Monitor',   180.00, '2026-03-03'),
(105, 4,  'Desk',      300.00, '2026-03-04'),
(106, 5,  'Chair',     95.00,  '2026-03-05'),
(107, 6,  'Bookshelf', 120.00, '2026-03-06'),
(108, 6,  'Notebook',  2.50,   '2026-03-07'),
(109, 7,  'Pen',       0.75,   '2026-03-08'),
(110, 8,  'Stapler',   6.00,   '2026-03-09'),
(111, 1,  'T-Shirt',   12.00,  '2026-03-10'),
(112, 3,  'Jacket',    55.00,  '2026-03-11'),
(113, 4,  'Laptop',    770.00, '2026-03-12'),
(114, 5,  'Mouse',     14.00,  '2026-03-13'),
(115, 2,  'Keyboard',  27.00,  '2026-03-14'),
(116, 7,  'Monitor',   185.00, '2026-03-15'),
(117, 90, 'Desk',      310.00, '2026-03-16'),  
(118, 91, 'Chair',     90.00,  '2026-03-17'),  
(119, 8,  'Bookshelf', 125.00, '2026-03-18'),
(120, 6,  'Notebook',  2.30,   '2026-03-19');
GO
 
 

 
CREATE TABLE dbo.StoreA_Products (
    ProductID   INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL
);
GO
 
CREATE TABLE dbo.StoreB_Products (
    ProductID   INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL
);
GO
 
INSERT INTO dbo.StoreA_Products (ProductID, ProductName) VALUES
(1, 'Laptop'),
(2, 'Mouse'),
(3, 'Keyboard'),
(4, 'Monitor'),
(5, 'Desk'),
(6, 'Chair'),
(7, 'Notebook'),
(8, 'Pen');
GO
 
INSERT INTO dbo.StoreB_Products (ProductID, ProductName) VALUES
(1, 'Mouse'),
(2, 'Keyboard'),
(3, 'Bookshelf'),
(4, 'Jacket'),
(5, 'Notebook'),
(6, 'Stapler'),
(7, 'T-Shirt'),
(8, 'Desk');
GO
 