/*******************************************************************************
* Session      : 8
* Date         : 18.08.2026
* Author       : Mohammed Atef
* Organization : NTI (National Telecommunication Institute)
* Note         : Run PracticeDB.sql (from session 6), Task1_data.sql (from session 7), 
                 Task2_data.sql (from session 7), and database_update.sql
                 in sequence before executing this script.
*******************************************************************************/
USE PracticeDB;
GO

-- Q1: Show each CustomerName next to its uppercase and lowercase versions.
SELECT CustomerName, UPPER(CustomerName) AS UpperCustomerName, LOWER(CustomerName) AS LowerCustomerName
FROM Customers;
GO

--------------------------------------------------------------------------------

-- Q2: Show each distinct ProductName from the Sales table along with its
--     character length (LEN), ordered from longest name to shortest.
SELECT DISTINCT ProductName, LEN(ProductName) AS ProductNameLength
FROM Sales
ORDER BY ProductNameLength DESC;
GO

--------------------------------------------------------------------------------

-- Q3: For customers who DO have an email on file, extract just the domain part 
--     of the email (everything after the '@').
SELECT SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS DomainPartFromEmail
FROM Customers
WHERE Email IS NOT NULL;
GO

--------------------------------------------------------------------------------

-- Q4: For each employee, produce a single column that combines their name 
--     and job title, formatted like: "Omar Hassan - Software Engineer".
SELECT CONCAT(FullName, ' - ', JobTitle) AS FullNameWithJobTitle
FROM Employees;
GO

--------------------------------------------------------------------------------

-- Q5: Some product names contain a hyphen (like 'T-Shirt'). Show each
--     distinct ProductName from Sales with any hyphens replaced by spaces.
SELECT DISTINCT REPLACE(ProductName, '-', ' ') AS ProductName
FROM Sales;
GO

--------------------------------------------------------------------------------

-- Q6: Show each distinct City from Customers along with just its first
--     3 characters.
SELECT DISTINCT LEFT(City, 3) AS First3CharFromCity
FROM Customers;
GO

--------------------------------------------------------------------------------

-- Q7: Show each employee's FullName, Salary, and Salary rounded to the
--     nearest thousand.
SELECT FullName, Salary, ROUND(Salary, -3) AS RoundedSalary
FROM Employees;
GO

-------------------------------------------------------------------------------- 

-- Q8: Show each employee's FullName, Salary, and the absolute difference
--     between their Salary and the company's average salary.
SELECT 
    FullName, Salary, 
    ABS(Salary - (SELECT AVG(Salary) FROM Employees)) AS SalaryDiffFromAvg
FROM Employees;
GO

--------------------------------------------------------------------------------

-- Q9: For each row in Sales, calculate the revenue (Quantity * UnitPrice)
--     rounded to 2 decimals, and also show its CEILING and FLOOR values.
SELECT 
    ROUND(Quantity * UnitPrice, 2) AS TotalRevenue, 
    CEILING(Quantity * UnitPrice) AS TotalRevenueAfterCeiling,
    FLOOR(Quantity * UnitPrice) AS TotalRevenueAfterFlooring
FROM Sales;
GO

-------------------------------------------------------------------------------- 

-- Q10: For each row in Sales, show the Quantity and its square root.
SELECT Quantity, SQRT(Quantity) AS ItsSquareRoot
FROM Sales;
GO

--------------------------------------------------------------------------------

-- Q11: Show each employee's FullName, HireDate, and how many years
--      they've worked at the company (based on today's date), ordered
--      from longest-serving to newest.
SELECT 
    FullName, HireDate, 
    DATEDIFF(YEAR, HireDate, GETDATE()) AS WorkedAtTheComany
FROM Employees
ORDER BY WorkedAtTheComany DESC;
GO

-------------------------------------------------------------------------------- 

-- Q12: For each row in Sales, show the SaleDate, the name of the month
--      it falls in, and the year.
SELECT SaleDate, DATENAME(MONTH, SaleDate) AS Month, YEAR(SaleDate) AS Year
FROM Sales;
GO

--------------------------------------------------------------------------------

-- Q13: Find all employees who were hired in the year 2020.
SELECT * FROM Employees
WHERE YEAR(HireDate) = 2020;
GO

--------------------------------------------------------------------------------

-- Q14: Find all orders that took more than 5 days to ship (i.e., the gap
--      between OrderDate and ShipDate is more than 5 days). Only consider orders 
--      that have actually shipped.
SELECT * FROM Orders
WHERE DATEDIFF(DAY, OrderDate, ShipDate) > 5;
GO

--------------------------------------------------------------------------------

-- Q15: Show each employee's FullName, HireDate, and what their probation end
--      date would be if probation lasts 90 days after HireDate.
SELECT 
    FullName, HireDate, 
    DATEADD(DAY, 90, HireDate) AS ProbationEndDate
FROM Employees;
GO

--------------------------------------------------------------------------------

-- Q16: Show each CustomerName and their Email — but for customers with
--      no email on file, display 'No Email Provided' instead of NULL.
SELECT CustomerName, ISNULL(Email, 'No Email Provided') AS Email
FROM Customers;
GO

--------------------------------------------------------------------------------

-- Q17: Show each employee's FullName, Salary, Bonus (displaying 0 instead of 
--      NULL where there's no bonus), and their total compensation (Salary + Bonus).
SELECT 
    FullName, Salary, 
    ISNULL(Bonus, 0) AS Bonus, 
    Salary + ISNULL(Bonus, 0) AS TotalSalary
FROM Employees;
GO

--------------------------------------------------------------------------------

-- Q18: Find all customers who have no email address on file.
SELECT * FROM Customers
WHERE Email IS NULL;
GO

--------------------------------------------------------------------------------

-- Q19: Show each order's ProductName and DiscountPercent, displaying
--      0 instead of NULL wherever no discount was applied.
SELECT ProductName, ISNULL(DiscountPercent, 0) AS DiscountPercent
FROM Orders;
GO

--------------------------------------------------------------------------------

-- Q20: Show each order's OrderDate and ShipDate — but if an order shipped
--      on the very same day it was placed, display NULL instead of the
--      ShipDate (hint: this is exactly what NULLIF is for).
SELECT OrderDate, NULLIF(ShipDate, OrderDate) AS ShipDate
FROM Orders;
GO

--------------------------------------------------------------------------------

-- Q21: Produce a single distinct list of product names that are sold in 
--      StoreA OR StoreB (no duplicates).
SELECT ProductName FROM StoreA_Products
UNION
SELECT ProductName FROM StoreB_Products
GO

--------------------------------------------------------------------------------

-- Q22: Produce the same combined list as Q21, but keep duplicates this time. 
--      How many more rows does it return compared to Q21, and why?
SELECT ProductName FROM StoreA_Products
UNION ALL
SELECT ProductName FROM StoreB_Products
GO

--------------------------------------------------------------------------------

-- Q23: Find the product names that are sold in BOTH StoreA and StoreB.
SELECT ProductName FROM StoreA_Products
INTERSECT
SELECT ProductName FROM StoreB_Products;
GO

--------------------------------------------------------------------------------

-- Q24: Find the product names that are sold in StoreA but NOT in StoreB.
SELECT ProductName FROM StoreA_Products
EXCEPT
SELECT ProductName FROM StoreB_Products;
GO