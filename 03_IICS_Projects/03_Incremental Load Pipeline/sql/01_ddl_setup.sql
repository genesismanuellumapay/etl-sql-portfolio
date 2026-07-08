--Drop table if exist in the database
DROP TABLE IF EXISTS incremental_orders;
DROP TABLE IF EXISTS etl_control;

--create target table
CREATE TABLE incremental_orders (
    order_id INT PRIMARY KEY,
    contact_id INT,
    order_date DATE,
    total_amount NUMERIC(10,2),
    status VARCHAR(30)
);

--create control table
CREATE TABLE etl_control (
    pipeline_name VARCHAR(100),
    last_loaded_order_id INT,
    last_run TIMESTAMP
);

--insert coltrol table data
INSERT INTO etl_control
VALUES
(
'incremental_orders_pipeline',
5,
CURRENT_TIMESTAMP
);