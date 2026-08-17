/*******************************************************************************
* Task         : 2
* Session      : 7
* Date         : 17.08.2026
* Author       : Mohammed Atef
* Organization : NTI (National Telecommunication Institute)
* Note         : Run PracticeDB.sql, Task1_data.sql, and Task2_data.sql
                 in sequence before executing this script.
*******************************************************************************/
USE PracticeDB;
GO

-- Q1: Show CustomerName, ProductName, and Amount for every order 
--     that has a matching customer.
SELECT CustomerName, ProductName, Amount
FROM Orders
    INNER JOIN Customers ON Customers.CustomerID = Orders.CustomerID;
GO

--------------------------------------------------------------------------------

-- Q2: Show every customer along with any orders they placed 
--     (CustomerName, OrderID, ProductName) — customers with no orders should 
--     still appear, with NULLs for order info.
SELECT CustomerName, OrderID, ProductName
FROM Customers
    LEFT JOIN Orders ON Orders.CustomerID = Customers.CustomerID;
GO

--------------------------------------------------------------------------------

-- Q3: Using the result idea from Q2, find only the customers who have
--     NEVER placed an order.
SELECT CustomerName, OrderID, ProductName
FROM Customers
    LEFT JOIN Orders ON Orders.CustomerID = Customers.CustomerID
WHERE OrderID IS NULL;
GO

--------------------------------------------------------------------------------

-- Q4: Show every order along with its customer info 
--     (OrderID, ProductName, CustomerName) — including orders
--     whose CustomerID doesn't match any customer.
SELECT OrderID, ProductName, CustomerName
FROM Customers
    RIGHT JOIN Orders ON Orders.CustomerID = Customers.CustomerID;
GO

--------------------------------------------------------------------------------

-- Q5: Using the result idea from Q4, find only the "orphan" orders —
--     orders placed under a CustomerID that doesn't exist in the
--     Customers table.
SELECT OrderID, ProductName, CustomerName
FROM Customers
    RIGHT JOIN Orders ON Orders.CustomerID = Customers.CustomerID
WHERE Customers.CustomerID IS NULL;
GO

--------------------------------------------------------------------------------

-- Q6: Show ALL customers and ALL orders combined — matched or not — in 
--     one result set (CustomerName, OrderID, ProductName).
SELECT CustomerName, OrderID, ProductName
FROM Orders 
    FULL JOIN Customers ON Orders.CustomerID = Customers.CustomerID;
GO