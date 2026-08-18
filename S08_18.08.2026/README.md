# SQL Set Operations & Single-Row Functions Cheat Sheet

A comprehensive technical reference detailing SQL set operations (`UNION`, `UNION ALL`, `INTERSECT`, `EXCEPT`), set structural rules, and single-row functions across character, numeric, date, conversion, and conditional operations.

---

## 1. SQL Set Operations & Engine Rules

Set operators combine the result sets of two or more `SELECT` queries vertically into a single output.

### Set Operators Reference

| Operator | Type | Combination Behavior | Duplicate Resolution | ANSI Standard |
| --- | --- | --- | --- | --- |
| **`UNION`** | Union | Combines all distinct rows from both queries. | Eliminates duplicates across all projected columns. | Yes |
| **`UNION ALL`** | Union | Combines all rows from both queries. | **Preserves duplicates.** Bypasses sorting/deduplication. | Yes |
| **`INTERSECT`** | Intersection | Returns only rows common to both queries. | Eliminates duplicates from the final result set. | Yes |
| **`EXCEPT`** / **`MINUS`** | Difference | Returns rows in Query 1 that do not exist in Query 2. | Eliminates duplicates from the output set. | `EXCEPT` (Standard), `MINUS` (Oracle) |

> **Structural Rules & Engine Constraints**
> 1. **Column & Type Matching:** Every `SELECT` must project the exact same number of columns with compatible data types.
> 2. **Header Ownership:** Output column names and data types are determined **strictly by the first `SELECT` query**; subsequent aliases are ignored.
> 3. **Single Global `ORDER BY`:** `ORDER BY` can only appear once at the very end, applying globally using column positions, expressions, or aliases from the **first query**.

---

### SQL Example: Set Operations & Engine Rules Demonstration

```sql
-- Query 1 establishes column names (PersonName, ContactEmail) and types
SELECT 
    FirstName + ' ' + LastName AS PersonName, 
    Email AS ContactEmail
FROM HR.Employees
WHERE DepartmentId = 3

UNION ALL -- Fast vertical stacking; keeps duplicates, avoids sorting overhead

SELECT 
    CustomerName, -- Second query alias is ignored; header will remain 'PersonName'
    EmailAddress
FROM Sales.Customers
WHERE Region = 'EMEA'

-- Global sorting applied to the combined vertical result set
ORDER BY PersonName ASC;
```

---

## 2. Comprehensive Single-Row Functions Reference

Single-row functions operate on individual rows and return **one value per row**. They can be used in `SELECT`, `WHERE`, `HAVING`, and `ORDER BY` clauses.

### Character Functions

| Function Syntax | Input Type | Description | Example | Result |
| --- | --- | --- | --- | --- |
| `UPPER(str)` | String | Converts all characters to uppercase. | `UPPER('sql')` | `'SQL'` |
| `LOWER(str)` | String | Converts all characters to lowercase. | `LOWER('SQL')` | `'sql'` |
| `LENGTH(str)` / `LEN(str)` | String | Returns the number of characters in a string. | `LENGTH('Database')` | `8` |
| `LEFT(str, n)` | String, Int | Extracts `n` characters starting from the left. | `LEFT('Database', 4)` | `'Data'` |
| `RIGHT(str, n)` | String, Int | Extracts `n` characters starting from the right. | `RIGHT('Database', 4)` | `'base'` |
| `SUBSTR(str, pos, len)` | String, Int | Extracts a substring starting at position `pos` for length `len`. | `SUBSTRING('DataWarehouse', 1, 4)` | `'Data'` |
| `INSTR(str, sub)` / `CHARINDEX()` | String, String | Returns 1-based index of the first occurrence of `sub` in `str`. | `INSTR('PostgreSQL', 'gre')` | `5` |
| `TRIM(str)` | String | Removes leading and trailing whitespace. | `TRIM('  hello  ')` | `'hello'` |
| `LTRIM(str)` / `RTRIM(str)` | String | Removes whitespace from left or right side only. | `LTRIM('  data')` | `'data'` |
| `REPLACE(str, src, dest)` | String | Replaces all occurrences of `src` with `dest`. | `REPLACE('v1.0', '1.0', '2.0')` | `'v2.0'` |
| `CONCAT(str1, str2, ...)` | String | Concatenates two or more strings together. | `CONCAT('SQL', ' ', 'Engine')` | `'SQL Engine'` |
| `LPAD(str, len, pad)` | String, Int, String | Left-pads a string with `pad` until it reaches `len`. | `LPAD('7', 3, '0')` | `'007'` |

---

### Numeric Functions

| Function Syntax | Input Type | Description | Example | Result |
| --- | --- | --- | --- | --- |
| `ROUND(n, d)` | Numeric, Int | Rounds `n` to `d` decimal places. | `ROUND(123.456, 2)` | `123.46` |
| `TRUNC(n, d)` / `TRUNCATE()` | Numeric, Int | Truncates `n` to `d` decimal places without rounding. | `TRUNC(123.456, 2)` | `123.45` |
| `CEIL(n)` / `CEILING(n)` | Numeric | Returns the smallest integer greater than or equal to `n`. | `CEIL(4.1)` | `5` |
| `FLOOR(n)` | Numeric | Returns the largest integer less than or equal to `n`. | `FLOOR(4.9)` | `4` |
| `ABS(n)` | Numeric | Returns the absolute value of `n`. | `ABS(-42.5)` | `42.5` |
| `MOD(m, n)` / `m % n` | Numeric | Returns the remainder of `m` divided by `n`. | `MOD(10, 3)` | `1` |
| `POWER(b, e)` | Numeric | Raises base `b` to exponent power `e`. | `POWER(2, 3)` | `8` |
| `SQRT(n)` | Numeric | Returns the square root of `n`. | `SQRT(16)` | `4` |

---

### Date & Time Functions

| Function Syntax | Return Type | Description | Example | Result |
| --- | --- | --- | --- | --- |
| `CURRENT_DATE` / `GETDATE()` | Date / Datetime | Returns the current system date and time. | `CURRENT_DATE` | `2026-08-18` |
| `CURRENT_TIMESTAMP` | Datetime | Standard ANSI function returning current timestamp with time zone. | `CURRENT_TIMESTAMP` | `2026-08-18 12:50:00` |
| `SYSDATETIME()` | Datetime2 | T-SQL function returning current system date and time with high fractional seconds precision. | `SYSDATETIME()` | `2026-08-18 12:50:00.1234567` |
| `DAY(d)` | Integer | T-SQL/MySQL shortcut returning day component of a date. | `DAY('2026-08-18')` | `18` |
| `MONTH(d)` | Integer | T-SQL/MySQL shortcut returning month component of a date. | `MONTH('2026-08-18')` | `8` |
| `YEAR(d)` | Integer | T-SQL/MySQL shortcut returning year component of a date. | `YEAR('2026-08-18')` | `2026` |
| `EXTRACT(part FROM d)` | Integer | ANSI standard to extract a specific date unit (`YEAR`, `MONTH`, `DAY`, `HOUR`). | `EXTRACT(MONTH FROM DATE '2026-08-18')` | `8` |
| `DATEPART(part, d)` | Integer | T-SQL function returning a specific date part as an integer. | `DATEPART(quarter, '2026-08-18')` | `3` |
| `DATENAME(part, d)` | String | T-SQL function returning a string representation of a date part. | `DATENAME(month, '2026-08-18')` | `'August'` |
| `DATETRUNC(unit, d)` | Datetime | Truncates input date/time to the specified unit boundaries (e.g., month, year). | `DATETRUNC(month, '2026-08-18')` | `2026-08-01 00:00:00` |
| `DATEADD(unit, n, d)` | Date / Datetime | Adds `n` date units to a given date `d`. | `DATEADD(day, 7, '2026-08-18')` | `2026-08-25` |
| `DATEDIFF(unit, d1, d2)` | Integer | Returns the integer difference (`d2 - d1`) in specified units. | `DATEDIFF(day, '2026-08-01', '2026-08-18')` | `17` |
| `LAST_DAY(d)` | Date | Returns the last day of the month for date `d`. | `LAST_DAY('2026-02-01')` | `2026-02-28` |
| `EOMONTH(d [, offset])` | Date | T-SQL function returning the last day of the month containing `d` (with optional month offset). | `EOMONTH('2026-08-18', 1)` | `2026-09-30` |

---

### Conversion & Conditional Functions

| Function Syntax | Description | `NULL` Handling & Rules | Example |
| --- | --- | --- | --- |
| `CAST(val AS type)` | Converts `val` explicitly to specified target data type. | Fails if explicit cast is invalid (use `TRY_CAST` to yield `NULL` on failure). | `CAST('100' AS INTEGER)` |
| `FORMAT(val, fmt [, culture])` | Formats a value with a specified format and optional culture (T-SQL/PostgreSQL). | Returns `NULL` if input value is `NULL`. Commonly used for dates and currency strings. | `FORMAT(1234.5, 'C', 'en-US')` $\rightarrow$ `'$1,234.50'` |
| `ISNULL(check_val, replacement)` | Replaces `NULL` in `check_val` with the specified `replacement` value (T-SQL / MySQL variant). | T-SQL 2-argument function. Returns data type of `check_val`. *(Note: MySQL `ISNULL(x)` returns 1/0 boolean).* | `ISNULL(Bonus, 0.00)` |
| `ISDATE(expression)` | Tests if an expression can be converted to a valid `DATE`, `TIME`, or `DATETIME` (T-SQL). | Returns `1` if valid, `0` if invalid or `NULL`. Prevents runtime errors during explicit casting. | `ISDATE('2026-08-18')` $\rightarrow$ `1` |
| `COALESCE(v1, v2, ...)` | Evaluates arguments in order and returns the **first non-NULL value**. | Returns `NULL` only if **all** parameters evaluate to `NULL`. | `COALESCE(NULL, NULL, 'Fallback')` |
| `NVL(val, default)` / `IFNULL()` | Replaces `val` with `default` if `val` is `NULL` (Oracle / MySQL). | Returns `val` if it is non-null; otherwise returns `default`. | `NVL(Commission, 0.00)` |
| `NULLIF(v1, v2)` | Compares two expressions. | Returns `NULL` if `v1 = v2`; otherwise returns `v1`. | `NULLIF(Status, 'UNKNOWN')` |
| `CASE ... END` | Evaluates conditional expressions sequentially. | Returns value of first matching `WHEN`; falls back to `ELSE` or `NULL`. | `CASE WHEN Score >= 90 THEN 'A' ELSE 'B' END` |

---

## 3. End-to-End Walkthrough: Combined Query Execution

An annotated query demonstrating Set Operations combined with single-row character, date, conversion, and conditional functions.

### Source Datasets

#### `HR.Employees`

| EmployeeId | FirstName | LastName | Department | HireDate | BaseSalary | Bonus |
| --- | --- | --- | --- | --- | --- | --- |
| 10 | John | Doe | Sales | 2021-03-15 | 60000.00 | 5000.00 |
| 11 | Jane | Smith | IT | 2023-07-01 | 85000.00 | `NULL` |
| 12 | Mark | Taylor | Sales | 2019-11-10 | 95000.00 | 12000.00 |

#### `Sales.Contractors`

| ContractorId | FullName | Agency | ContractDate | RatePerHour | OvertimePay |
| --- | --- | --- | --- | --- | --- |
| 501 | JANE SMITH | Apex Tech | 2023-07-01 | 45.00 | `NULL` |
| 502 | ALICE BROWN | Global Services | 2022-01-15 | 55.00 | 250.00 |

---

### Executed SQL Query

```sql
-- Query 1: Normalizes Employee dataset and calculates total compensation
SELECT 
    UPPER(CONCAT(FirstName, ' ', LEFT(LastName, 1), '.')) AS IdentityName,
    'Internal Staff' AS EmploymentType,
    CASE 
        WHEN ISDATE(HireDate) = 1 THEN YEAR(HireDate)
        ELSE NULL
    END AS StartYear,
    DATENAME(month, HireDate) AS HireMonth,
    EOMONTH(HireDate) AS MonthEndDate,
    FORMAT(BaseSalary + ISNULL(Bonus, 0.00), 'C', 'en-US') AS TotalComp,
    CASE 
        WHEN BaseSalary >= 80000.00 THEN 'Tier 1'
        ELSE 'Tier 2'
    END AS PayGrade
FROM HR.Employees
WHERE Department = 'Sales' OR Bonus IS NOT NULL

UNION ALL

-- Query 2: Normalizes Contractor dataset to align with Query 1 schema
SELECT 
    TRIM(FullName), -- Output header is 'IdentityName' (defined in Query 1)
    'External Contractor',
    CASE 
        WHEN ISDATE(ContractDate) = 1 THEN YEAR(ContractDate)
        ELSE NULL
    END,
    DATENAME(month, ContractDate),
    EOMONTH(ContractDate),
    FORMAT((RatePerHour * 2000) + ISNULL(OvertimePay, 0.00), 'C', 'en-US'),
    'Contractor Standard'
FROM Sales.Contractors
WHERE ContractDate >= '2022-01-01'

-- Global ordering across all combined rows using Query 1 column reference
ORDER BY StartYear DESC, IdentityName ASC;
```

---

### Step-by-Step Execution Mechanics

1. **Query 1 Pipeline Execution (`HR.Employees`):**
    * **Filtering:** Evaluates `Department = 'Sales' OR Bonus IS NOT NULL`.
        * Employee 10 (`Sales`): `TRUE`.
        * Employee 11 (`IT`, `Bonus IS NULL`): `FALSE` $\rightarrow$ Discarded.
        * Employee 12 (`Sales`): `TRUE`.

    * **Single-Row Transformations:**
        * `UPPER(CONCAT('John', ' ', LEFT('Doe', 1), '.'))` $\rightarrow$ `'JOHN D.'`
        * `ISDATE('2021-03-15')` $\rightarrow$ `1` $\rightarrow$ `YEAR('2021-03-15')` $\rightarrow$ `2021`
        * `DATENAME(month, '2021-03-15')` $\rightarrow$ `'March'`
        * `EOMONTH('2021-03-15')` $\rightarrow$ `'2021-03-31'`
        * `FORMAT(60000.00 + ISNULL(5000.00, 0.00), 'C', 'en-US')` $\rightarrow$ `'$65,000.00'`
        * `CASE` logic assigns `'Tier 2'` to John and `'Tier 1'` to Mark.

2. **Query 2 Pipeline Execution (`Sales.Contractors`):**
    * **Filtering:** Evaluates `ContractDate >= '2022-01-01'`. Contractors 501 and 502 pass.
    * **Single-Row Transformations:**
        * `TRIM('JANE SMITH')` $\rightarrow$ `'JANE SMITH'`
        * `ISDATE('2023-07-01')` $\rightarrow$ `1` $\rightarrow$ `YEAR('2023-07-01')` $\rightarrow$ `2023`
        * `DATENAME(month, '2023-07-01')` $\rightarrow$ `'July'`
        * `EOMONTH('2023-07-01')` $\rightarrow$ `'2023-07-31'`
        * `FORMAT(45 * 2000 + ISNULL(NULL, 0.00), 'C', 'en-US')` $\rightarrow$ `'$90,000.00'`

3. **`UNION ALL` Set Stacking:**
    * Combines the rows directly without performing sorting or deduplication.
    * Enforces schema definition from **Query 1** (`IdentityName`, `EmploymentType`, `StartYear`, `HireMonth`, `MonthEndDate`, `TotalComp`, `PayGrade`).

4. **Global `ORDER BY` Clause:**
    * Sorts entire dataset by `StartYear DESC`, breaking ties with `IdentityName ASC`.

---

### Final Output Result Set

| IdentityName | EmploymentType | StartYear | HireMonth | MonthEndDate | TotalComp | PayGrade |
| --- | --- | --- | --- | --- | --- | --- |
| ALICE BROWN | External Contractor | 2022 | January | 2022-01-31 | $110,250.00 | Contractor Standard |
| JANE SMITH | External Contractor | 2023 | July | 2023-07-31 | $90,000.00 | Contractor Standard |
| JOHN D. | Internal Staff | 2021 | March | 2021-03-31 | $65,000.00 | Tier 2 |
| MARK T. | Internal Staff | 2019 | November | 2019-11-30 | $107,000.00 | Tier 1 |