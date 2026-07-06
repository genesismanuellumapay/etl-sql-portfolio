--01_DDL_SETUP.SQL

DROP TABLE IF EXISTS err_vendor_products;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS ref_category;

--Create Reference Lookup Table
CREATE TABLE ref_category (
    category_code VARCHAR(10) PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

-- Insert sample reference data for ref_category table
INSERT INTO ref_category (category_code, category_name) VALUES
('ELEC', 'Electronics'),
('FURN', 'Furniture'),
('OFFC', 'Office Supplies');

--Create Production Target Table
CREATE TABLE dim_product (
    product_sk SERIAL PRIMARY KEY,
    vendor_sku VARCHAR(50) NOT NULL,
    product_name VARCHAR(100),
    category_code VARCHAR(10),
    unit_price DECIMAL(10,2),
    stock_qty INT,
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--Create Quarantine/Error Log Table
CREATE TABLE err_vendor_products (
    error_id SERIAL PRIMARY KEY,
    vendor_sku VARCHAR(50),
    raw_record_data TEXT,
    error_reason VARCHAR(255),
    error_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);