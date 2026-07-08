DROP TABLE IF EXIST employee_source;
DROP TABLE IF EXIST dim_employee;

-- 1. Source Table
CREATE TABLE employee_source (
    employee_id  INT PRIMARY KEY,
    first_name   VARCHAR(50),
    last_name    VARCHAR(50),
    department   VARCHAR(50),
    job_title    VARCHAR(50),
    salary       NUMERIC(10,2),
    hire_date    DATE
);

-- 2. Target Historical Dimension Table
CREATE TABLE dim_employee (
    surrogate_key  SERIAL PRIMARY KEY, -- Auto-incrementing warehouse identity key
    employee_id    INT,                -- surrogate key
    full_name      VARCHAR(100),
    department     VARCHAR(50),
    job_title      VARCHAR(50),
    salary         NUMERIC(10,2),
    effective_date DATE NOT NULL,      -- Dimensional record start date
    end_date       DATE,               -- Dimensional record expiration date
    current_flag   CHAR(1) NOT NULL    -- Active record tracker ('Y' or 'N')
);