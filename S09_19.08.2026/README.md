# SQL Advanced Expressions, Subqueries, DDL, DML & Stored Procedures Cheat Sheet

A comprehensive technical reference covering conditional logic, subquery dimensions and execution models, quantifiable comparison operators, DDL schema management, DML operations, and Stored Procedures.

---

## 1. Conditional Logic: `CASE` Statements

`CASE` statements evaluate conditions sequentially and return a value when the first condition is met (short-circuit evaluation). If no condition evaluates to `TRUE` and no `ELSE` clause exists, it returns `NULL`.

### Syntax Types & Behavior

| `CASE` Type | Syntax Structure | Best For | Null Behavior / Pitfalls |
| --- | --- | --- | --- |
| **Searched `CASE`** | `CASE` <br> `WHEN cond1 THEN res1` <br> `WHEN cond2 THEN res2` <br> `ELSE res3` <br> `END` | Complex evaluations (`<`, `>`, `AND`, `OR`, `IS NULL`). | First `TRUE` condition wins; subsequent conditions are ignored. |
| **Simple `CASE`** | `CASE expr` <br> `WHEN val1 THEN res1` <br> `WHEN val2 THEN res2` <br> `ELSE res3` <br> `END` | Exact equality comparisons against a single expression. | Cannot directly test `WHEN NULL` (must use Searched `CASE WHEN x IS NULL`). |

> **Engine Rules & Type Coercion**
> 1. **Data Type Consistency:** All `THEN` and `ELSE` result expressions must yield the same or implicitly coercible data types. If types conflict, the engine throws a conversion error.
> 2. **Short-Circuit Optimization:** SQL engines stop evaluating `WHEN` clauses as soon as a match evaluates to `TRUE`. Order conditions from most restrictive to least restrictive.

### Code Examples: Searched vs Simple `CASE`

```sql
-- 1. Searched CASE Example (Handles ranges, multiple columns, and NULLs)
SELECT 
    EmployeeId,
    BaseSalary,
    Bonus,
    CASE 
        WHEN Bonus IS NULL THEN 'No Bonus'
        WHEN BaseSalary + Bonus >= 100000 THEN 'Top Earner'
        WHEN BaseSalary + Bonus BETWEEN 70000 AND 99999 THEN 'Mid Earner'
        ELSE 'Standard Earner'
    END AS CompensationTier
FROM HR.Employees;

-- 2. Simple CASE Example (Exact match against a single expression)
SELECT 
    OrderId,
    StatusCode,
    CASE StatusCode
        WHEN 'P' THEN 'Pending'
        WHEN 'S' THEN 'Shipped'
        WHEN 'D' THEN 'Delivered'
        WHEN 'C' THEN 'Cancelled'
        ELSE 'Unknown'
    END AS OrderStatus
FROM Sales.Orders;
```

---

## 2. Subquery Classification & Location Rules

A subquery is a `SELECT` query nested inside another statement. Subqueries are classified by their **Result Dimensionality**, **Execution Dynamics**, and **Location Context**.

### Result Types Matrix

| Subquery Result Type | Dimensions | Expected Format | Valid Placement Contexts |
| --- | --- | --- | --- |
| **Scalar** | $1 \times 1$ | Exactly 1 row, 1 column. | `SELECT` list, `WHERE` (`=`, `<`), `HAVING`, `SET` assignments. |
| **Column Subquery** | $M \times 1$ | Multiple rows, exactly 1 column. | `WHERE` (`IN`, `NOT IN`, `ANY`, `ALL`). |
| **Row Subquery** | $1 \times N$ | Exactly 1 row, multiple columns. | `WHERE (col1, col2) = (SELECT c1, c2 ...)` tuple comparisons. |
| **Table Subquery** | $M \times N$ | Multiple rows, multiple columns. | `FROM` (Derived Table), `JOIN`, `WHERE EXISTS`. |

---

### Execution Dynamics: Uncorrelated vs. Correlated

| Dimension | Uncorrelated Subquery | Correlated Subquery |
| --- | --- | --- |
| **Outer Dependency** | Independent; does **not** reference columns from the outer query. | Dependent; references one or more columns from the outer query table alias. |
| **Execution Model** | Evaluates **once** for the entire main query statement. | Evaluates **repeatedly**—conceptually once per candidate outer row. |
| **Standalone Testability** | Can be copied and executed independently as a self-contained query. | Cannot run standalone; throws an "unbound identifier" error outside main query context. |
| **Performance Profile** | Fast ($O(1)$ subquery executions); easily cached or materialised by the optimizer. | Higher resource cost ($O(N)$ executions); depends heavily on index support on joining key. |

#### Code Example: Uncorrelated vs. Correlated Subqueries

```sql
-- 1. Uncorrelated Subquery (Runs once: finds company-wide threshold first)
SELECT EmployeeId, BaseSalary
FROM HR.Employees
WHERE BaseSalary > (
    SELECT AVG(BaseSalary) -- Self-contained: runs independent of outer query
    FROM HR.Employees
);

-- 2. Correlated Subquery (Runs per outer row: compares employee against THEIR department avg)
SELECT e.EmployeeId, e.DepartmentId, e.BaseSalary
FROM HR.Employees e
WHERE e.BaseSalary > (
    SELECT AVG(sub.BaseSalary)
    FROM HR.Employees sub
    WHERE sub.DepartmentId = e.DepartmentId -- Outer reference binds execution to outer row 'e'
);
```

---

### Location Constraints & Rules

| Clause Location | Required Subquery Result | Execution Constraints & Engine Rules |
| --- | --- | --- |
| **`SELECT` List** | **Scalar** | Executes per outer row if correlated. Must evaluate to 1 row and 1 column, or runtime error occurs. |
| **`FROM` / `JOIN`** | **Table** | Must be given an **explicit alias** (Derived Table). Engine treats it as a temporary logical table. |
| **`WHERE` / `HAVING`** | **Scalar, Column, Row, or Table** | Depends on operator: Scalar for (`=, <, >`), Column for (`IN, ANY, ALL`), Row for tuple comparisons `(a, b)`, Table for `EXISTS`. |

### Code Examples: Subqueries by Placement & Type

```sql
-- 1. Scalar Subquery in SELECT (1x1 result per outer row)
SELECT 
    e.EmployeeId,
    e.BaseSalary,
    (SELECT AVG(BaseSalary) FROM HR.Employees) AS CompanyAvgSalary,
    e.BaseSalary - (SELECT AVG(BaseSalary) FROM HR.Employees) AS DeviationFromAvg
FROM HR.Employees e;

-- 2. Column Subquery in WHERE (Mx1 result set evaluated with multi-row operator)
SELECT EmployeeId, LastName
FROM HR.Employees
WHERE DepartmentId IN (
    SELECT DepartmentId 
    FROM HR.Departments 
    WHERE IsActive = 1
);

-- 3. Row Subquery in WHERE (1xN multi-column tuple comparison)
SELECT EmployeeId, ManagerId, DepartmentId
FROM HR.Employees
WHERE (ManagerId, DepartmentId) = (
    SELECT ManagerId, DepartmentId 
    FROM HR.Employees 
    WHERE EmployeeId = 101
);

-- 4. Table Subquery in FROM (Derived Table - Requires an Alias)
SELECT 
    dept_summary.DepartmentId,
    dept_summary.AvgSalary
FROM (
    SELECT DepartmentId, AVG(BaseSalary) AS AvgSalary
    FROM HR.Employees
    GROUP BY DepartmentId
) AS dept_summary
WHERE dept_summary.AvgSalary > 75000;

-- 5. Table Subquery in JOIN
SELECT 
    e.EmployeeId, 
    e.LastName, 
    recent_orders.LastOrderDate
FROM HR.Employees e
INNER JOIN (
    SELECT EmployeeId, MAX(OrderDate) AS LastOrderDate
    FROM Sales.Orders
    GROUP BY EmployeeId
) AS recent_orders ON e.EmployeeId = recent_orders.EmployeeId;
```

---

## 3. Multi-Row Operators (`IN`, `ANY`, `ALL`, `EXISTS`)

These operators allow logical evaluation between scalar values and subquery result sets.

| Operator | Evaluates To `TRUE` When | Critical Edge Case / `NULL` Pitfall |
| --- | --- | --- |
| **`IN`** | Outer value matches **at least one** value in the subquery. | Equivalent to `= ANY`. |
| **`NOT IN`** | Outer value does **not** match any value in the subquery. | **`NULL` Trap:** If subquery returns even a single `NULL`, `NOT IN` returns **0 rows** (evaluates to `UNKNOWN`). |
| **`ANY` / `SOME`** | Comparison (`=`, `>`, `<`) is `TRUE` for **at least one** row. | `> ANY (10, 20)` means "greater than the minimum (10)". |
| **`ALL`** | Comparison (`=`, `>`, `<`) is `TRUE` for **every** row in the set. | `> ALL (10, 20)` means "greater than the maximum (20)". |
| **`EXISTS`** | Subquery returns **at least 1 row** (short-circuits on 1st match). | Unaffected by `NULL` values in subquery projected columns. Use `SELECT 1`. |
| **`NOT EXISTS`** | Subquery returns **0 rows**. | Preferred over `NOT IN` because it safely handles `NULL` values in correlated keys. |

### Code Examples: Multi-Row Operators & `NULL` Safety

```sql
-- 1. IN vs NOT IN (Demonstrating NULL Trap)
-- Safe IN query
SELECT EmployeeId, LastName 
FROM HR.Employees
WHERE DepartmentId IN (SELECT DepartmentId FROM HR.Departments WHERE IsActive = 1);

-- RISKY NOT IN: Returns zero rows if subquery returns ANY NULL value
SELECT EmployeeId, LastName 
FROM HR.Employees
WHERE DepartmentId NOT IN (SELECT ManagerId FROM HR.Employees); -- Fails if ManagerId has NULLs!

-- 2. EXISTS vs NOT EXISTS (Safe Pattern handling NULLs)
-- SAFEST: Unaffected by NULLs in subquery
SELECT e.EmployeeId, e.LastName 
FROM HR.Employees e
WHERE NOT EXISTS (
    SELECT 1 
    FROM Sales.Orders o 
    WHERE o.EmployeeId = e.EmployeeId
);

-- 3. ANY / SOME Example
-- Finds employees earning more than AT LEAST ONE employee in Dept 3 (i.e. > MIN)
SELECT EmployeeId, BaseSalary
FROM HR.Employees
WHERE BaseSalary > ANY (
    SELECT BaseSalary FROM HR.Employees WHERE DepartmentId = 3
);

-- 4. ALL Example
-- Finds employees earning more than EVERY employee in Dept 3 (i.e. > MAX)
SELECT EmployeeId, BaseSalary
FROM HR.Employees
WHERE BaseSalary > ALL (
    SELECT BaseSalary FROM HR.Employees WHERE DepartmentId = 3
);
```

---

## 4. DDL (Data Definition Language) Reference

DDL statements create, modify, and drop database structures.

### Key DDL Commands & Constraints

```sql
-- 1. CREATE TABLE with Full Column Constraints
CREATE TABLE Sales.Orders (
    OrderId INT IDENTITY(1,1) CONSTRAINT PK_Orders PRIMARY KEY,
    CustomerId INT NOT NULL,
    OrderDate DATE DEFAULT CURRENT_DATE,
    TotalAmount DECIMAL(10,2) CHECK (TotalAmount >= 0.00),
    Status VARCHAR(20) DEFAULT 'Pending',
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerId) 
        REFERENCES Sales.Customers(CustomerId) ON DELETE CASCADE
);

-- 2. ALTER TABLE Operations (Add, Drop, Modify Column & Constraint)
-- Add new column
ALTER TABLE Sales.Orders ADD PaymentMethod VARCHAR(50) NULL;

-- Modify existing column data type
ALTER TABLE Sales.Orders ALTER COLUMN PaymentMethod VARCHAR(100) NOT NULL;

-- Drop a column
ALTER TABLE Sales.Orders DROP COLUMN Status;

-- Add a unique constraint
ALTER TABLE Sales.Orders ADD CONSTRAINT UQ_Order_Customer UNIQUE (OrderId, CustomerId);

-- Drop a constraint
ALTER TABLE Sales.Orders DROP CONSTRAINT UQ_Order_Customer;

-- 3. DROP TABLE vs TRUNCATE TABLE
TRUNCATE TABLE Sales.TempLogs; -- Instant deallocation, resets identity, keeps schema
DROP TABLE Sales.OldOrders;    -- Completely removes table structure and data from catalog
```

### `TRUNCATE` vs `DELETE`

| Feature | `TRUNCATE` (DDL) | `DELETE` (DML) |
| --- | --- | --- |
| **Operation Type** | Deallocates data pages. | Deletes rows individually. |
| **Performance** | Extremely fast; minimal logging. | Slower; logs every row deletion. |
| **`WHERE` Clause** | Not allowed. | Supported. |
| **Identity Reset** | Resets `IDENTITY` counter to seed. | Preserves `IDENTITY` counter sequence. |
| **Foreign Keys** | Blocked if referenced by active `FK`. | Allowed (triggers `CASCADE` if configured). |

---

## 5. DML (Data Manipulation Language) Reference

DML statements manage data records within existing schema objects.

### Code Examples: `INSERT`, `UPDATE`, `DELETE`

```sql
-- 1. INSERT Operations
-- Multi-row literal insertion
INSERT INTO HR.DepartmentArchive (DeptId, DeptName)
VALUES (10, 'HR'), (20, 'Finance'), (30, 'Operations');

-- INSERT from Subquery (Data migration)
INSERT INTO HR.HighEarners (EmpId, Salary)
SELECT EmployeeId, BaseSalary 
FROM HR.Employees 
WHERE BaseSalary > 100000;

-- 2. UPDATE with JOIN
UPDATE e
SET 
    e.BaseSalary = e.BaseSalary * 1.10,
    e.LastReviewDate = CURRENT_DATE
FROM HR.Employees e
INNER JOIN HR.Departments d ON e.DepartmentId = d.DepartmentId
WHERE d.DepartmentName = 'Engineering';

-- 3. DELETE with Subquery Filtering
DELETE FROM HR.Employees
WHERE DepartmentId IN (
    SELECT DepartmentId 
    FROM HR.Departments 
    WHERE IsActive = 0
);
```

---

## 6. Stored Procedures

Stored Procedures encapsulate reusable SQL logic, accepting parameters and returning values, dataset output, or error codes.

### Code Example: Stored Procedure Creation & Execution

```sql
-- 1. Procedure Definition with Input/Output Parameters, Error Handling & Transactions
CREATE PROCEDURE Sales.GetCustomerSummary
    @CustomerId INT,                  -- Input Parameter
    @MinOrderValue DECIMAL(10,2) = 0.00,  -- Input Parameter with Default
    @TotalOrders INT OUTPUT               -- Output Parameter
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Calculate aggregate output
        SELECT @TotalOrders = COUNT(OrderId)
        FROM Sales.Orders
        WHERE CustomerId = @CustomerId AND TotalAmount >= @MinOrderValue;

        -- Return primary result set directly to caller
        SELECT OrderId, OrderDate, TotalAmount
        FROM Sales.Orders
        WHERE CustomerId = @CustomerId AND TotalAmount >= @MinOrderValue
        ORDER BY OrderDate DESC;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;

        -- Reraise error details to caller
        THROW;
    END CATCH
END;
GO

-- 2. Execution Example
DECLARE @OrderCount INT;

EXEC Sales.GetCustomerSummary 
    @CustomerId = 101, 
    @MinOrderValue = 500.00, 
    @TotalOrders = @OrderCount OUTPUT;

-- Check output parameter value
SELECT @OrderCount AS TotalQualifyingOrders;
```