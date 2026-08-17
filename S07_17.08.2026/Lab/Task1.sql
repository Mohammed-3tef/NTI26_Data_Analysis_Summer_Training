/*******************************************************************************
* Task         : 1
* Session      : 7
* Date         : 17.08.2026
* Author       : Mohammed Atef
* Organization : NTI (National Telecommunication Institute)
* Note         : Run PracticeDB.sql and Task1_data.sql in sequence before 
                 executing this script.
*******************************************************************************/
USE PracticeDB;
GO

-- Q1: Retrieve all columns and all rows from the Employees table.
SELECT * FROM Employees;
GO

--------------------------------------------------------------------------------

-- Q2: List the distinct Departments in the company.
SELECT DISTINCT Department
FROM Employees;
GO

--------------------------------------------------------------------------------

-- Q3: Show the top 5 highest-paid employees (by Salary).
SELECT TOP 5 * FROM Employees
ORDER BY Salary DESC;
GO

--------------------------------------------------------------------------------

-- Q4: Retrieve all employees who work in the 'IT' department.
SELECT * FROM Employees
WHERE Department = 'IT';
GO

--------------------------------------------------------------------------------

-- Q5: Retrieve all employees whose Salary is greater than 12000 AND 
--     who work in 'Cairo'.
SELECT * FROM Employees
WHERE Salary > 12000 AND City = 'Cairo';
GO

--------------------------------------------------------------------------------

-- Q6: Show FullName and Salary for employees with a Salary between 9000 
--     and 15000, ordered from lowest to highest.
SELECT FullName, Salary 
FROM Employees
WHERE Salary BETWEEN 9000 AND 15000
ORDER BY Salary ASC;
GO

--------------------------------------------------------------------------------

-- Q7: List the distinct job titles held by employees in the 'Sales' department.
SELECT DISTINCT JobTitle FROM Employees
WHERE Department = 'Sales';
GO

--------------------------------------------------------------------------------

-- Q8: Count how many employees work in each City.
SELECT City, COUNT(*) AS NumberOfEmployees
FROM Employees
GROUP BY City;
GO

--------------------------------------------------------------------------------

-- Q9: Find the total Salary paid  per Department, ordered from highest 
--     total to lowest.
SELECT Department, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Department
ORDER BY TotalSalary DESC;
GO

--------------------------------------------------------------------------------

-- Q10: Calculate the average Salary for each JobTitle.
SELECT JobTitle, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY JobTitle;
GO

--------------------------------------------------------------------------------

-- Q11: Find the departments whose average Salary is greater than 12000.
SELECT Department, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 12000;
GO

--------------------------------------------------------------------------------

-- Q12: Find the cities that have more than 5 employees.
SELECT City, COUNT(*) AS NumberOfEmployees
FROM Employees
GROUP BY City
HAVING COUNT(*) > 5;
GO

--------------------------------------------------------------------------------

-- Q13: Find the job titles that have more than 2 employees assigned to them.
SELECT JobTitle, COUNT(*) AS NumberOfEmployees
FROM Employees
GROUP BY JobTitle
HAVING COUNT(*) > 2;
GO

--------------------------------------------------------------------------------

-- Q14: Find the top 3 departments by average Salary, showing the 
--      department name and its average salary, highest first.
SELECT TOP 3 Department, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department
ORDER BY AvgSalary DESC;
GO

--------------------------------------------------------------------------------

-- Q15: Find the cities that have employees working in more than 
--      3 distinct departments.
SELECT City FROM Employees
GROUP BY City
HAVING COUNT(DISTINCT Department) > 3;
GO