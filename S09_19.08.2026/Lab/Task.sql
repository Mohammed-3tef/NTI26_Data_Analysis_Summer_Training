/*******************************************************************************
* Session      : 9
* Date         : 19.08.2026
* Author       : Mohammed Atef
* Organization : NTI (National Telecommunication Institute)
* Note         : Run PracticeDB.sql (from session 6), Task1_data.sql (from session 7), 
                 Task2_data.sql (from session 7), and database_update.sql (from session 8)
                 in sequence before executing this script.
*******************************************************************************/
USE PracticeDB;
GO

-- Q1: Find all sales that do NOT belong to the 'Electronics' or 'Furniture' categories.
SELECT * FROM Sales
WHERE Category NOT IN ('Electronics', 'Furniture');
GO

--------------------------------------------------------------------------------

-- Q2: find all employees whose Salary is greater than ANY salary earned 
--     in the 'HR' department (i.e., higher than at least one HR employee's salary).
SELECT * FROM Employees
WHERE Salary > ANY (
    SELECT Salary FROM Employees
    WHERE Department = 'HR'
);
GO

--------------------------------------------------------------------------------

-- Q3: find all employees whose Salary is greater than ALL salaries earned 
--     in the 'HR' department (i.e., higher than every single HR employee's salary).
SELECT * FROM Employees
WHERE Salary > ALL (
    SELECT Salary FROM Employees
    WHERE Department = 'HR'
);
GO

--------------------------------------------------------------------------------

-- Q4: Using EXISTS, find the distinct product names from the Sales
--     table that are also sold in StoreA_Products.
SELECT DISTINCT ProductName
FROM Sales s
WHERE EXISTS(
    SELECT ProductName FROM StoreA_Products a
    WHERE a.ProductName = s.ProductName
);
GO

--------------------------------------------------------------------------------

-- Q5: Using NOT EXISTS, find the product names in StoreA_Products
--     that are NOT sold in StoreB_Products.
SELECT ProductName
FROM StoreA_Products a
WHERE NOT EXISTS(
    SELECT 1 FROM StoreB_Products b
    WHERE b.ProductName = a.ProductName
);
GO

--------------------------------------------------------------------------------

-- Q6: Using CASE WHEN, show each employee's FullName, Salary, and a new column called
--     SalaryLevel: 'High' if Salary > 15000, 'Medium' if Salary is 
--     between 10000 and 15000, otherwise 'Low'.
SELECT 
    FullName, Salary,
    CASE
        WHEN Salary > 15000 THEN 'High' 
        WHEN Salary BETWEEN 10000 AND 15000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryLevel
FROM Employees;
GO

--------------------------------------------------------------------------------

-- Q7: Using CASE WHEN, show each order's OrderID, Amount, and a new column called 
--     OrderSize: 'Big Order' if Amount > 100, otherwise 'Small Order'.
SELECT 
    OrderID, Amount,
    CASE 
        WHEN Amount > 100 THEN 'Big Order'
        ELSE 'Small Order'
    END AS OrderSize
FROM Orders;
GO

--------------------------------------------------------------------------------

-- Q8: Show the 5 cheapest products in the Sales table (lowest UnitPrice).
SELECT TOP 5 * FROM Sales
ORDER BY UnitPrice;
GO

--------------------------------------------------------------------------------

-- Q9: Find all employees in the 'IT' department who earn more than 13000.
SELECT * FROM Employees
WHERE Department = 'IT' AND Salary > 13000;
GO

--------------------------------------------------------------------------------

-- Q10: Show how many orders each customer (by CustomerID) has placed.
SELECT CustomerID, COUNT(*) AS NumberOfOrders
FROM Orders
GROUP BY CustomerID;
GO

--------------------------------------------------------------------------------

-- Q11: List all orders ordered by OrderDate, most recent first.
SELECT * FROM Orders
ORDER BY OrderDate DESC;
GO

--------------------------------------------------------------------------------

-- Q12: Show each customer's name along with the total amount they've spent 
--      (sum of their order amounts).
SELECT CustomerName, SUM(Amount) AS TotalAmount
FROM Orders o
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY CustomerName;
GO

--------------------------------------------------------------------------------

-- Q13: Using a LEFT JOIN, show each customer's name along with how many
--      orders they've placed (customers with no orders should show 0).
SELECT 
    c.CustomerName, 
    COUNT(o.OrderID) AS NumberOfOrders
FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName;
GO

--------------------------------------------------------------------------------

-- Q14: Using UNION, list all distinct cities that appear in either the
--      Customers table or the Employees table.
SELECT City FROM Customers
UNION
SELECT City FROM Employees;
GO

--------------------------------------------------------------------------------

-- Q15: Show each employee's FullName converted to lowercase.
SELECT LOWER(FullName) AS FullName
FROM Employees;
GO

--------------------------------------------------------------------------------

-- Q16: Show each sale's ProductName and UnitPrice rounded to the nearest whole number.
SELECT ProductName, ROUND(UnitPrice, 0) AS RoundedUnitPrice
FROM Sales;
GO

--------------------------------------------------------------------------------

-- Q17: For each order, show the OrderDate and how many days ago it was placed, compared to today.
SELECT OrderDate, DATEDIFF(DAY, OrderDate, GETDATE()) AS NumberOfDays
FROM Orders;
GO

--------------------------------------------------------------------------------

-- Q18: Show each order's ShipDate, displaying 'Not Shipped Yet' instead
--      of NULL wherever an order hasn't shipped.
SELECT 
    OrderID, 
    ISNULL(
        CAST(ShipDate AS NVARCHAR(20)), 
        'Not Shipped Yet'
    ) AS ShipDate
FROM Orders;
GO

--------------------------------------------------------------------------------

-- Q19: Using a subquery, find the employee(s) with the lowest salary in the company.
SELECT * FROM Employees
WHERE Salary = (
    SELECT MIN(Salary) FROM Employees
);
GO

--------------------------------------------------------------------------------

-- Q20: Find the total number of orders in the Orders table.
SELECT COUNT(*) AS TotalNumberOfOrders 
FROM Orders;
GO

--------------------------------------------------------------------------------

-- Q21: Find all employees who earn more than the company's average salary.
SELECT * FROM Employees
WHERE Salary > (
    SELECT AVG(Salary) FROM Employees
);
GO

--------------------------------------------------------------------------------

-- Q22: Find the customer (or customers) who has spent the most overall,
--      using a subquery to identify the highest total order amount.
SELECT CustomerID, SUM(Amount) AS TotalSpent
FROM Orders
GROUP BY CustomerID
HAVING SUM(Amount) = (
    SELECT MAX(TotalAmount)
    FROM (
        SELECT SUM(Amount) AS TotalAmount
        FROM Orders
        GROUP BY CustomerID
    ) AS Amounts
);
GO

--------------------------------------------------------------------------------

-- Q23: Find every sale in the Sales table whose UnitPrice is higher than
--      the average UnitPrice of its own Category (e.g., a laptop priced
--      above the average price of all Electronics).
SELECT * FROM Sales s1
WHERE UnitPrice > (
    SELECT AVG(UnitPrice) FROM Sales s2
    WHERE s2.Category = s1.Category
);
GO

--------------------------------------------------------------------------------

-- Q24: Using EXISTS, find all customers who have placed at least one order.
SELECT * FROM Customers c
WHERE EXISTS(
    SELECT 1 FROM Orders o
    WHERE o.CustomerID = c.CustomerID
);
GO

--------------------------------------------------------------------------------

-- Q25: Using NOT EXISTS, find all customers who have never placed an order.
--      (You already solved this with a LEFT JOIN earlier — try it this
--      way instead and compare the two approaches.)
SELECT * FROM Customers c
WHERE NOT EXISTS(
    SELECT 1 FROM Orders o
    WHERE o.CustomerID = c.CustomerID
);
GO

--------------------------------------------------------------------------------

-- Q26: Find all employees who belong to a department that has more than
--      5 employees in it, using a subquery (not a JOIN).
SELECT * FROM Employees
WHERE Department IN (
    SELECT Department FROM Employees 
    GROUP BY Department 
    HAVING COUNT(*) > 5
);
GO

--------------------------------------------------------------------------------

-- Q27: Find all orders whose Amount is greater than the average Amount
--      across all orders.
SELECT * FROM Orders
WHERE Amount > (
    SELECT AVG(Amount) FROM Orders
);
GO

--------------------------------------------------------------------------------

-- Q28: Find the department(s) whose total salary bill is higher than
--      the total salary bill of the 'HR' department.
SELECT Department FROM Employees
GROUP BY Department
HAVING SUM(Salary) > (
    SELECT SUM(Salary) FROM Employees
    WHERE Department = 'HR'
);
GO

--------------------------------------------------------------------------------

-- Q29: Show each order's ProductName, Amount, and how far that Amount
--      is from the overall average order Amount (rounded to 2 decimals).
SELECT 
    ProductName, Amount, 
    ROUND(ABS(Amount - (SELECT AVG(Amount) FROM Orders)), 2) AS DiffFromAvg
FROM Orders;
GO

--------------------------------------------------------------------------------

-- Q30: Find the second-highest salary in the Employees table (without
--      using OFFSET/FETCH) — just a single value.

SELECT MAX(Salary) AS SecondHighestSalary
FROM Employees
WHERE Salary < (SELECT MAX(Salary) FROM Employees);
GO