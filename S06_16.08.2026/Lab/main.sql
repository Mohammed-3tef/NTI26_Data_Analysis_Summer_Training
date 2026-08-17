/*******************************************************************************
* Session      : 6
* Date         : 16.08.2026
* Author       : Mohammed Atef
* Organization : NTI (National Telecommunication Institute)
* Note         : You should run PracticeDB.sql & before running this script.
*******************************************************************************/

USE PracticeDB;
GO

-- Q1: Retrieve all columns and all rows from the Sales table.
SELECT * FROM Sales;
GO

--------------------------------------------------------------------------------

-- Q2: List the distinct regions where sales have happened.
SELECT DISTINCT Region
FROM Sales;
GO

--------------------------------------------------------------------------------

-- Q3: Show the top 5 most expensive sales based on UnitPrice (highest first).
SELECT TOP 5 * FROM Sales
ORDER BY UnitPrice DESC;
GO

--------------------------------------------------------------------------------

-- Q4: Retrieve all sales made in the 'Electronics' category.
SELECT * FROM Sales
WHERE Category = 'Electronics';
GO

--------------------------------------------------------------------------------

-- Q5: Retrieve all sales where Quantity is greater than 5 AND the Region is 'North'.
SELECT * FROM Sales
WHERE Quantity > 5 AND Region = 'North';
GO

--------------------------------------------------------------------------------

-- Q6: Show ProductName and UnitPrice for all products priced between 50 and 300 
--     (inclusive), ordered from cheapest to most expensive.
SELECT ProductName, UnitPrice FROM Sales
WHERE UnitPrice >= 50 AND UnitPrice <= 300
ORDER BY UnitPrice ASC;
GO

--------------------------------------------------------------------------------

-- Q7: List the distinct salespeople who have sold something in the 'Furniture' category.
SELECT DISTINCT SalesPerson FROM Sales
WHERE Category = 'Furniture';
GO

--------------------------------------------------------------------------------

-- Q8: Count how many sales transactions happened in each Region.
SELECT Region, COUNT(*) AS TotalSalesTransactions 
FROM Sales
GROUP BY Region;
GO

--------------------------------------------------------------------------------

-- Q9: Find the total Quantity sold for each ProductName, ordered 
--     from highest total quantity to lowest.
SELECT ProductName, SUM(Quantity) AS TotalQuantity
FROM Sales
GROUP BY ProductName
ORDER BY SUM(Quantity) DESC;
GO

--------------------------------------------------------------------------------

-- Q10: Calculate the average UnitPrice for each Category.
SELECT Category, AVG(UnitPrice) AS AvgUnitPrice
FROM Sales
GROUP BY Category;
GO

--------------------------------------------------------------------------------

-- Q11: Find the categories whose total Quantity sold (summed across all rows)
--      is greater than 100.
SELECT Category, SUM(Quantity) AS TotalQuantity
FROM Sales
GROUP BY Category
HAVING SUM(Quantity) > 100;
GO

--------------------------------------------------------------------------------

-- Q12: Find the salespeople who made more than 8 sales transactions in total.
SELECT SalesPerson, COUNT(*) AS TotalSalesTransactions
FROM Sales
GROUP BY SalesPerson
HAVING COUNT(*) > 8;
GO

--------------------------------------------------------------------------------

-- Q13: Find the products whose average UnitPrice is greater than 100.
SELECT ProductName, AVG(UnitPrice) AS AvgUnitPrice
FROM Sales
GROUP BY ProductName
HAVING AVG(UnitPrice) > 100;
GO

--------------------------------------------------------------------------------

-- Q14: Find the top 3 salespeople by total revenue (revenue = Quantity * UnitPrice), 
--      showing their name and total revenue, highest first.
SELECT TOP 3 SalesPerson, SUM(Quantity * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY SalesPerson
ORDER BY TotalRevenue DESC;
GO

--------------------------------------------------------------------------------

-- Q15: Find the regions that have sold more than 3 distinct categories of products.
SELECT Region, COUNT(DISTINCT Category) AS DistinctCategories
FROM Sales
GROUP BY Region
HAVING COUNT(DISTINCT Category) > 3;
GO