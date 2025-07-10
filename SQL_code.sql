--use master;
--create database employees;
--use employees;
drop table if exists employees;
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    date_of_birth DATE,
    gender CHAR(1),
    hire_date DATE NOT NULL,
    job_title VARCHAR(100),
    department_id INT,
    department_name VARCHAR(100),
    manager_id INT,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    address_line1 VARCHAR(100),
    address_line2 VARCHAR(100),
    city VARCHAR(50),
    state_province VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50),
    salary DECIMAL(10,2),
    bonus DECIMAL(10,2),
    employment_status VARCHAR(20),  
    termination_date DATE,
    nationality VARCHAR(50),
    marital_status VARCHAR(20),
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);


-- First, let's create a temporary function to generate random data
-- This script uses a procedural approach to generate 7,000 records

-- Declare variables
DECLARE @counter INT = 1;
DECLARE @total_records INT = 11483;
DECLARE @departments TABLE (id INT, name VARCHAR(100));
DECLARE @job_titles TABLE (title VARCHAR(100), dept_id INT);
DECLARE @first_names TABLE (name VARCHAR(50));
DECLARE @last_names TABLE (name VARCHAR(50));

-- Populate department data
INSERT INTO @departments VALUES (1, 'Human Resources');
INSERT INTO @departments VALUES (2, 'Finance');
INSERT INTO @departments VALUES (3, 'Marketing');
INSERT INTO @departments VALUES (4, 'Sales');
INSERT INTO @departments VALUES (5, 'IT');
INSERT INTO @departments VALUES (6, 'Operations');
INSERT INTO @departments VALUES (7, 'Customer Service');
INSERT INTO @departments VALUES (8, 'Research and Development');
INSERT INTO @departments VALUES (9, 'Legal');
INSERT INTO @departments VALUES (10, 'Administration');

-- Populate job titles by department
INSERT INTO @job_titles VALUES ('HR Manager', 1);
INSERT INTO @job_titles VALUES ('HR Associate', 1);
INSERT INTO @job_titles VALUES ('Recruiter', 1);
INSERT INTO @job_titles VALUES ('Finance Manager', 2);
INSERT INTO @job_titles VALUES ('Accountant', 2);
INSERT INTO @job_titles VALUES ('Financial Analyst', 2);
-- Add more job titles as needed...

-- Populate sample first names
INSERT INTO @first_names VALUES ('John'), ('Jane'), ('Michael'), ('Emily'), ('David'), ('Sarah'), 
('Robert'), ('Jennifer'), ('William'), ('Lisa'), ('James'), ('Jessica'), ('Christopher'), ('Amy'),
('Matthew'), ('Ashley'), ('Daniel'), ('Michelle'), ('Andrew'), ('Amanda');
-- Add more names as needed...

-- Populate sample last names
INSERT INTO @last_names VALUES ('Smith'), ('Johnson'), ('Williams'), ('Brown'), ('Jones'), 
('Miller'), ('Davis'), ('Garcia'), ('Rodriguez'), ('Wilson'), ('Martinez'), ('Anderson'),
('Taylor'), ('Thomas'), ('Hernandez'), ('Moore'), ('Martin'), ('Jackson'), ('Thompson'), ('White');
-- Add more names as needed...

-- Begin transaction
BEGIN TRANSACTION;

-- Insert 7,000 records
WHILE @counter <= @total_records
BEGIN
    DECLARE @dept_id INT = (SELECT TOP 1 id FROM @departments ORDER BY NEWID());
    DECLARE @dept_name VARCHAR(100) = (SELECT name FROM @departments WHERE id = @dept_id);
    DECLARE @job_title VARCHAR(100) = (SELECT TOP 1 title FROM @job_titles WHERE dept_id = @dept_id ORDER BY NEWID());
    DECLARE @first_name VARCHAR(50) = (SELECT TOP 1 name FROM @first_names ORDER BY NEWID());
    DECLARE @last_name VARCHAR(50) = (SELECT TOP 1 name FROM @last_names ORDER BY NEWID());
    DECLARE @middle_name VARCHAR(50) = CASE WHEN RAND() > 0.7 THEN NULL ELSE (SELECT TOP 1 LEFT(name, 1) + '.' FROM @first_names ORDER BY NEWID()) END;
    DECLARE @dob DATE = DATEADD(DAY, -FLOOR(RAND() * 365*50 + 365*18), GETDATE()); -- Age 18-68
    DECLARE @gender CHAR(1) = CASE WHEN RAND() > 0.5 THEN 'M' ELSE 'F' END;
    DECLARE @hire_date DATE = DATEADD(DAY, -FLOOR(RAND() * 365*10), GETDATE()); -- Hired in last 10 years
    DECLARE @manager_id INT = CASE WHEN @counter > 10 THEN FLOOR(RAND() * (@counter-1)) + 1 ELSE NULL END;
    DECLARE @email VARCHAR(100) = LOWER(@first_name) + '.' + LOWER(@last_name) + CAST(@counter AS VARCHAR) + '@company.com';
    DECLARE @salary DECIMAL(10,2) = ROUND(30000 + (RAND() * 120000), 2); -- $30k-$150k
    DECLARE @bonus DECIMAL(10,2) = CASE WHEN RAND() > 0.7 THEN ROUND(@salary * (RAND() * 0.2), 2) ELSE NULL END;
    DECLARE @status VARCHAR(20) = CASE WHEN RAND() > 0.9 THEN 'Terminated' ELSE 'Active' END;
    DECLARE @term_date DATE = CASE WHEN @status = 'Terminated' THEN DATEADD(DAY, FLOOR(RAND() * 365*2), @hire_date) ELSE NULL END;
    
    INSERT INTO employees (
        employee_id, first_name, last_name, middle_name, date_of_birth, gender,
        hire_date, job_title, department_id, department_name, manager_id,
        email, phone_number, address_line1, address_line2, city, state_province,
        postal_code, country, salary, bonus, employment_status, termination_date,
        nationality, marital_status, emergency_contact_name, emergency_contact_phone
    ) VALUES (
        @counter, @first_name, @last_name, @middle_name, @dob, @gender,
        @hire_date, @job_title, @dept_id, @dept_name, @manager_id,
        @email, 
        '(' + CAST(FLOOR(RAND() * 900) + 100 AS VARCHAR) + ') ' + 
        CAST(FLOOR(RAND() * 900) + 100 AS VARCHAR) + '-' + 
        CAST(FLOOR(RAND() * 9000) + 1000 AS VARCHAR), -- Phone number
        CAST(FLOOR(RAND() * 9999) + 1 AS VARCHAR) + ' Main St', -- Address line 1
        CASE WHEN RAND() > 0.7 THEN 'Apt ' + CAST(FLOOR(RAND() * 500) + 1 AS VARCHAR) ELSE NULL END, -- Address line 2
        CASE WHEN RAND() > 0.5 THEN 'New York' ELSE 'Chicago' END, -- City
        CASE WHEN RAND() > 0.5 THEN 'NY' ELSE 'IL' END, -- State
        CAST(FLOOR(RAND() * 90000) + 10000 AS VARCHAR), -- Zip code
        'United States',
        @salary, @bonus, @status, @term_date,
        'US', -- Nationality
        CASE 
            WHEN RAND() > 0.7 THEN 'Single'
            WHEN RAND() > 0.4 THEN 'Married'
            ELSE 'Divorced'
        END,
        CASE 
            WHEN RAND() > 0.5 THEN @first_name + ' ' + @last_name
            ELSE (SELECT TOP 1 name FROM @first_names ORDER BY NEWID()) + ' ' + (SELECT TOP 1 name FROM @last_names ORDER BY NEWID())
        END,
        '(' + CAST(FLOOR(RAND() * 900) + 100 AS VARCHAR) + ') ' + 
        CAST(FLOOR(RAND() * 900) + 100 AS VARCHAR) + '-' + 
        CAST(FLOOR(RAND() * 9000) + 1000 AS VARCHAR) -- Emergency contact phone
    );
    
    SET @counter = @counter + 1;
    
    -- Commit in batches of 1000 to avoid huge transactions
    IF @counter % 1000 = 0
    BEGIN
        COMMIT;
        BEGIN TRANSACTION;
    END
END

COMMIT;

select * from employees;
