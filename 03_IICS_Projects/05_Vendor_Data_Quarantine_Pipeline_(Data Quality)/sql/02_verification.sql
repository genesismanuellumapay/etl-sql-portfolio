-- 02_VERIFICATION.SQL

-- Review successfully loaded production data
SELECT 
    product_sk, 
    vendor_sku, 
    product_name, 
    category_code, 
    unit_price, 
    stock_qty 
FROM dim_product 
ORDER BY product_sk;

-- Aggregate errors by rule violation
SELECT 
    error_reason, 
    COUNT(*) AS total_error
FROM err_vendor_products
GROUP BY error_reason
ORDER BY total_error DESC;