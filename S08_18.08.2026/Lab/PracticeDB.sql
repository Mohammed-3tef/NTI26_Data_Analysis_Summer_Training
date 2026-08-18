CREATE DATABASE PracticeDB;
GO
USE PracticeDB;
GO

IF OBJECT_ID('dbo.Sales', 'U') IS NOT NULL
    DROP TABLE dbo.Sales;
GO
 
CREATE TABLE dbo.Sales (
    SaleID       INT PRIMARY KEY,
    ProductName  VARCHAR(50)   NOT NULL,
    Category     VARCHAR(30)   NOT NULL,
    Region       VARCHAR(20)   NOT NULL,
    SalesPerson  VARCHAR(50)   NOT NULL,
    Quantity     INT           NOT NULL,
    UnitPrice    DECIMAL(10,2) NOT NULL,
    SaleDate     DATE          NOT NULL
);
GO
 

INSERT INTO dbo.Sales (SaleID, ProductName, Category, Region, SalesPerson, Quantity, UnitPrice, SaleDate) VALUES
(1,  'Laptop',      'Electronics', 'North', 'Ahmed',   2,  750.00, '2026-01-05'),
(2,  'Mouse',       'Electronics', 'North', 'Ahmed',   10, 15.00,  '2026-01-05'),
(3,  'Keyboard',    'Electronics', 'South', 'Sara',    5,  25.00,  '2026-01-06'),
(4,  'Monitor',     'Electronics', 'East',  'Mona',    3,  180.00, '2026-01-07'),
(5,  'Desk',        'Furniture',   'West',  'Youssef', 1,  300.00, '2026-01-08'),
(6,  'Chair',       'Furniture',   'West',  'Youssef', 4,  95.00,  '2026-01-08'),
(7,  'Bookshelf',   'Furniture',   'North', 'Karim',   2,  120.00, '2026-01-09'),
(8,  'Notebook',    'Stationery',  'South', 'Sara',    20, 2.50,   '2026-01-10'),
(9,  'Pen',         'Stationery',  'South', 'Sara',    50, 0.75,  '2026-01-10'),
(10, 'Stapler',     'Stationery',  'East',  'Mona',    8,  6.00,  '2026-01-11'),
(11, 'T-Shirt',     'Clothing',    'North', 'Ahmed',   15, 12.00,  '2026-01-12'),
(12, 'Jacket',      'Clothing',    'West',  'Youssef', 6,  55.00,  '2026-01-13'),
(13, 'Laptop',      'Electronics', 'South', 'Sara',    1,  770.00, '2026-01-15'),
(14, 'Mouse',       'Electronics', 'East',  'Mona',    12, 14.00,  '2026-01-16'),
(15, 'Keyboard',    'Electronics', 'North', 'Karim',   7,  27.00,  '2026-01-17'),
(16, 'Monitor',     'Electronics', 'West',  'Youssef', 2,  185.00, '2026-01-18'),
(17, 'Desk',        'Furniture',   'North', 'Ahmed',   3,  310.00, '2026-01-19'),
(18, 'Chair',       'Furniture',   'South', 'Sara',    6,  90.00,  '2026-01-20'),
(19, 'Bookshelf',   'Furniture',   'East',  'Mona',    1,  125.00, '2026-01-21'),
(20, 'Notebook',    'Stationery',  'West',  'Youssef', 30, 2.30,   '2026-01-22'),
(21, 'Pen',         'Stationery',  'North', 'Karim',   60, 0.70,  '2026-01-23'),
(22, 'Stapler',     'Stationery',  'South', 'Sara',    5,  6.50,  '2026-01-24'),
(23, 'T-Shirt',     'Clothing',    'East',  'Mona',    10, 13.00,  '2026-02-01'),
(24, 'Jacket',      'Clothing',    'North', 'Ahmed',   4,  58.00,  '2026-02-02'),
(25, 'Laptop',      'Electronics', 'West',  'Youssef', 3,  740.00, '2026-02-03'),
(26, 'Mouse',       'Electronics', 'North', 'Karim',   9,  15.50,  '2026-02-04'),
(27, 'Keyboard',    'Electronics', 'South', 'Sara',    4,  26.00,  '2026-02-05'),
(28, 'Monitor',     'Electronics', 'East',  'Mona',    5,  178.00, '2026-02-06'),
(29, 'Desk',        'Furniture',   'North', 'Ahmed',   2,  305.00, '2026-02-07'),
(30, 'Chair',       'Furniture',   'West',  'Youssef', 8,  92.00,  '2026-02-08'),
(31, 'Bookshelf',   'Furniture',   'South', 'Sara',    3,  118.00, '2026-02-09'),
(32, 'Notebook',    'Stationery',  'East',  'Mona',    25, 2.40,   '2026-02-10'),
(33, 'Pen',         'Stationery',  'West',  'Youssef', 40, 0.80,  '2026-02-11'),
(34, 'Stapler',     'Stationery',  'North', 'Karim',   6,  6.20,  '2026-02-12'),
(35, 'T-Shirt',     'Clothing',    'South', 'Sara',    18, 12.50,  '2026-02-13'),
(36, 'Jacket',      'Clothing',    'East',  'Mona',    5,  56.00,  '2026-02-14'),
(37, 'Laptop',      'Electronics', 'North', 'Karim',   4,  760.00, '2026-02-15'),
(38, 'Mouse',       'Electronics', 'South', 'Sara',    14, 15.20,  '2026-02-16'),
(39, 'Monitor',     'Electronics', 'West',  'Youssef', 6,  182.00, '2026-02-17'),
(40, 'Desk',        'Furniture',   'East',  'Mona',    2,  298.00, '2026-02-18');
GO