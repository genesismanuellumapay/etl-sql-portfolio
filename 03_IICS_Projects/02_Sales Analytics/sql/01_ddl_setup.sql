--Delete table if exist in the database
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS contacts;

-- Create table for orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    contact_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20),

    CONSTRAINT fk_orders_contact
        FOREIGN KEY (contact_id)
        REFERENCES contacts(contact_id)
);
--Insert values for orders table
INSERT INTO orders (contact_id, order_date, total_amount, status) VALUES
(1, '2026-01-10', 150.00, 'Completed'),
(1, '2026-01-15',  85.50, 'Completed'),
(2, '2026-01-12', 220.00, 'Pending'),
(2, '2026-01-18',  45.00, 'Cancelled'),
(3, '2026-01-20', 310.75, 'Completed'),
(4, '2026-01-22',  99.99, 'Completed'),
(5, '2026-01-25', 120.00, 'Pending'),
(6, '2026-01-28',  60.00, 'Completed');

-- create table for contacts
CREATE TABLE contacts (
    contact_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    company_name VARCHAR(100),
    address VARCHAR(150),
    city VARCHAR(50),
    state VARCHAR(50),
    post VARCHAR(20),
    phone1 VARCHAR(20),
    phone2 VARCHAR(20),
    email VARCHAR(100),
    web VARCHAR(100)
);

--Create target table
CREATE TABLE monthly_customer_sales (
	month DATE,
	contact_id INT,
	customer_name VARCHAR(100),
	total_orders INT,
	total_sales NUMERIC(10,2),
	avg_sales NUMERIC(10,2)
);