USE PracticeDB;
GO
 
/* ---------------------------------------------------------------------
   --------------------------------------------------------------------- */
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL
    DROP TABLE dbo.Employees;
GO
 
CREATE TABLE dbo.Employees (
    EmployeeID  INT PRIMARY KEY,
    FullName    VARCHAR(50)   NOT NULL,
    Department  VARCHAR(30)   NOT NULL,
    City        VARCHAR(30)   NOT NULL,
    JobTitle    VARCHAR(40)   NOT NULL,
    Salary      DECIMAL(10,2) NOT NULL,
    HireDate    DATE          NOT NULL
);
GO
 
/* ---------------------------------------------------------------------
   --------------------------------------------------------------------- */
INSERT INTO dbo.Employees (EmployeeID, FullName, Department, City, JobTitle, Salary, HireDate) VALUES
(1,  'Omar Hassan',    'IT',        'Cairo',     'Software Engineer', 14000.00, '2019-03-01'),
(2,  'Nour Ali',       'IT',        'Cairo',     'Database Admin',    13500.00, '2020-06-15'),
(3,  'Laila Fathy',    'IT',        'Giza',      'IT Manager',        22000.00, '2015-01-10'),
(4,  'Kareem Adel',    'IT',        'Alexandria','Software Engineer', 13800.00, '2021-09-20'),
(5,  'Hana Mostafa',   'HR',        'Cairo',     'HR Specialist',     9500.00,  '2018-04-12'),
(6,  'Yousef Samir',   'HR',        'Giza',      'HR Manager',        18000.00, '2016-02-05'),
(7,  'Dina Rami',      'HR',        'Cairo',     'Recruiter',         8800.00,  '2022-07-01'),
(8,  'Tarek Nabil',    'Sales',     'Alexandria','Sales Executive',   9000.00,  '2020-11-11'),
(9,  'Salma Ezz',      'Sales',     'Mansoura',  'Sales Executive',   8700.00,  '2021-03-03'),
(10, 'Ahmed Gamal',    'Sales',     'Cairo',     'Sales Manager',     19000.00, '2014-08-25'),
(11, 'Mariam Khaled',  'Sales',     'Giza',      'Sales Executive',   9200.00,  '2023-01-15'),
(12, 'Sherif Adel',    'Finance',   'Cairo',     'Financial Analyst', 12500.00, '2019-10-10'),
(13, 'Rana Tarek',     'Finance',   'Alexandria','Accountant',        10500.00, '2020-05-05'),
(14, 'Mostafa Kamel',  'Finance',   'Cairo',     'Finance Manager',   21000.00, '2013-12-01'),
(15, 'Nada Ibrahim',   'Marketing', 'Giza',      'Marketing Specialist', 9800.00, '2022-02-14'),
(16, 'Amr Sobhy',      'Marketing', 'Cairo',     'Marketing Manager', 17500.00, '2017-06-30'),
(17, 'Yara Hosny',     'Marketing', 'Mansoura',  'Content Creator',   8200.00,  '2023-08-08'),
(18, 'Fady Milad',     'IT',        'Cairo',     'Software Engineer', 14200.00, '2020-01-20'),
(19, 'Rania Sameh',    'IT',        'Alexandria','QA Engineer',       11000.00, '2021-04-04'),
(20, 'Karim Fouad',    'HR',        'Cairo',     'HR Specialist',     9600.00,  '2019-09-09'),
(21, 'Ola Wagdy',      'HR',        'Giza',      'Recruiter',         8900.00,  '2022-10-10'),
(22, 'Hossam Reda',    'Sales',     'Cairo',     'Sales Executive',   9100.00,  '2021-12-12'),
(23, 'Menna Sherif',   'Sales',     'Alexandria','Sales Executive',   8600.00,  '2023-03-03'),
(24, 'Adham Yasser',   'Finance',   'Giza',      'Financial Analyst', 12800.00, '2020-07-07'),
(25, 'Sara Nagy',      'Finance',   'Cairo',     'Accountant',        10700.00, '2021-11-11'),
(26, 'Ziad Hany',      'Marketing', 'Cairo',     'Marketing Specialist', 9700.00, '2022-05-05'),
(27, 'Doaa Emad',      'Marketing', 'Alexandria','Content Creator',   8300.00,  '2023-09-09'),
(28, 'Bassem Fathy',   'IT',        'Giza',      'Software Engineer', 14100.00, '2018-08-18'),
(29, 'Heba Amin',      'IT',        'Cairo',     'QA Engineer',       11200.00, '2022-01-01'),
(30, 'Wael Sabry',     'Sales',     'Mansoura',  'Sales Manager',     19500.00, '2015-05-15'),
(31, 'Aya Mahmoud',    'HR',        'Cairo',     'HR Specialist',     9400.00,  '2020-03-03'),
(32, 'Islam Kotb',     'Finance',   'Alexandria','Accountant',        10300.00, '2022-06-06'),
(33, 'Reem Salah',     'Marketing', 'Giza',      'Marketing Manager', 17800.00, '2016-10-10'),
(34, 'Hazem Nasr',     'IT',        'Cairo',     'Database Admin',    13700.00, '2021-02-02'),
(35, 'Marwa Younes',   'Sales',     'Cairo',     'Sales Executive',   9300.00,  '2023-04-04');
GO