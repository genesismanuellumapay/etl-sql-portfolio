--Delete table if exist in the database
DROP TABLE IF EXISTS customer_clean;

-- Create target table
CREATE TABLE customer_clean (
	customer_id INT,
	full_name VARCHAR(100),
	email VARCHAR(100),
	phone VARCHAR(30),
	city VARCHAR(100),
	state VARCHAR(50),
	registration_date DATE
);