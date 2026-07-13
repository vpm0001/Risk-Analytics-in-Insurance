CREATE TABLE insurance_claims (
    customer VARCHAR(20),
    state VARCHAR(50),
    customer_lifetime_value DECIMAL(15,2),
    response VARCHAR(10),
    coverage VARCHAR(20),
    coverage_index INT,
    education VARCHAR(50),
    education_index INT,
    effective_to_date VARCHAR(20),
    employment_status VARCHAR(50),
    employment_status_index INT,
    gender VARCHAR(10),
    income INT,
    location VARCHAR(20),
    location_index INT,
    marital_status VARCHAR(20),
    marital_status_index INT,
    monthly_premium_auto INT,
    months_since_last_claim INT,
    months_since_policy_inception INT,
    number_of_open_complaints INT,
    number_of_policies INT,
    policy_type VARCHAR(30),
    policy_type_index INT,
    policy VARCHAR(30),
    policy_index INT,
    renew_offer_type INT,
    sales_channel VARCHAR(30),
    sales_channel_index INT,
    total_claim_amount DECIMAL(15,2),
    vehicle_class VARCHAR(50),
    vehicle_class_index INT,
    vehicle_size VARCHAR(20),
    vehicle_size_index INT
);



USE insurance_analytics;

LOAD DATA LOCAL INFILE 'C:/Users/HP/OneDrive/Desktop/AutoInsuranceClaims2024.csv'
INTO TABLE insurance_claims
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM insurance_claims;


DESCRIBE insurance_claims;



SELECT customer, COUNT(*) AS customer_count
FROM insurance_claims
GROUP BY customer
HAVING COUNT(*) > 1;




SELECT
    SUM(customer IS NULL) AS customer_nulls,
    SUM(customer_lifetime_value IS NULL) AS clv_nulls,
    SUM(income IS NULL) AS income_nulls,
    SUM(monthly_premium_auto IS NULL) AS premium_nulls,
    SUM(total_claim_amount IS NULL) AS claim_nulls,
    SUM(policy_type IS NULL) AS policy_type_nulls,
    SUM(vehicle_class IS NULL) AS vehicle_class_nulls
FROM insurance_claims;





SELECT DISTINCT state FROM insurance_claims;
SELECT DISTINCT response FROM insurance_claims;
SELECT DISTINCT coverage FROM insurance_claims;
SELECT DISTINCT education FROM insurance_claims;
SELECT DISTINCT employment_status FROM insurance_claims;
SELECT DISTINCT gender FROM insurance_claims;
SELECT DISTINCT location FROM insurance_claims;
SELECT DISTINCT marital_status FROM insurance_claims;
SELECT DISTINCT policy_type FROM insurance_claims;
SELECT DISTINCT policy FROM insurance_claims;
SELECT DISTINCT renew_offer_type FROM insurance_claims;
SELECT DISTINCT sales_channel FROM insurance_claims;
SELECT DISTINCT vehicle_class FROM insurance_claims;
SELECT DISTINCT vehicle_size FROM insurance_claims;



SELECT
    MIN(customer_lifetime_value) AS min_clv,
    MAX(customer_lifetime_value) AS max_clv,
    
    MIN(income) AS min_income,
    MAX(income) AS max_income,
    
    MIN(monthly_premium_auto) AS min_premium,
    MAX(monthly_premium_auto) AS max_premium,
    
    MIN(months_since_last_claim) AS min_months_claim,
    MAX(months_since_last_claim) AS max_months_claim,
    
    MIN(number_of_open_complaints) AS min_complaints,
    MAX(number_of_open_complaints) AS max_complaints,
    
    MIN(number_of_policies) AS min_policies,
    MAX(number_of_policies) AS max_policies,
    
    MIN(total_claim_amount) AS min_claim,
    MAX(total_claim_amount) AS max_claim
FROM insurance_claims;



SELECT effective_to_date
FROM insurance_claims
LIMIT 10;

-- this is making a new col for date and dropping the prev date col and then reclaiming the name, because the prev format was different and changing merely will be error or something.

ALTER TABLE insurance_claims
ADD COLUMN effective_date DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE insurance_claims
SET effective_date = STR_TO_DATE(effective_to_date, '%m/%d/%Y');

SELECT COUNT(*)
FROM insurance_claims
WHERE effective_date IS NULL;

ALTER TABLE insurance_claims
DROP COLUMN effective_to_date;

ALTER TABLE insurance_claims
RENAME COLUMN effective_date TO effective_to_date;

DESCRIBE insurance_claims;



-- EDA

SELECT
    COUNT(*) AS total_customers,
    SUM(total_claim_amount) AS total_claim_amount,
    AVG(total_claim_amount) AS avg_claim_amount,
    AVG(monthly_premium_auto) AS avg_monthly_premium,
    AVG(customer_lifetime_value) AS avg_customer_lifetime_value,
    SUM(number_of_policies) AS total_policies
FROM insurance_claims;


SELECT
    coverage,
    COUNT(*) AS total_customers,
    SUM(total_claim_amount) AS total_claim_amount,
    AVG(total_claim_amount) AS avg_claim_amount,
    AVG(monthly_premium_auto) AS avg_monthly_premium
FROM insurance_claims
GROUP BY coverage
ORDER BY avg_claim_amount DESC;


SELECT
    policy_type,
    COUNT(*) AS total_customers,
    SUM(total_claim_amount) AS total_claim_amount,
    AVG(total_claim_amount) AS avg_claim_amount,
    AVG(monthly_premium_auto) AS avg_monthly_premium
FROM insurance_claims
GROUP BY policy_type
ORDER BY avg_claim_amount DESC;


SELECT
    vehicle_class,
    COUNT(*) AS total_customers,
    SUM(total_claim_amount) AS total_claim_amount,
    AVG(total_claim_amount) AS avg_claim_amount,
    AVG(monthly_premium_auto) AS avg_monthly_premium
FROM insurance_claims
GROUP BY vehicle_class
ORDER BY avg_claim_amount DESC;


SELECT
    vehicle_class,
    COUNT(*) AS total_customers,
    ROUND(AVG(total_claim_amount), 2) AS avg_claim_amount,
    ROUND(AVG(monthly_premium_auto), 2) AS avg_monthly_premium,
    ROUND(
        AVG(total_claim_amount) / AVG(monthly_premium_auto),
        2
    ) AS claim_to_premium_ratio
FROM insurance_claims
GROUP BY vehicle_class
ORDER BY claim_to_premium_ratio DESC;


SELECT
    employment_status,
    COUNT(*) AS total_customers,
    ROUND(AVG(income), 2) AS avg_income,
    ROUND(AVG(total_claim_amount), 2) AS avg_claim_amount,
    ROUND(AVG(monthly_premium_auto), 2) AS avg_monthly_premium,
    ROUND(AVG(customer_lifetime_value), 2) AS avg_clv
FROM insurance_claims
GROUP BY employment_status
ORDER BY avg_claim_amount DESC;


SELECT
    CASE
        WHEN income = 0 THEN 'No Income'
        WHEN income < 30000 THEN 'Low Income'
        WHEN income < 60000 THEN 'Middle Income'
        WHEN income < 90000 THEN 'Upper-Middle Income'
        ELSE 'High Income'
    END AS income_segment,
    COUNT(*) AS total_customers,
    ROUND(AVG(total_claim_amount), 2) AS avg_claim_amount,
    ROUND(AVG(monthly_premium_auto), 2) AS avg_monthly_premium,
    ROUND(AVG(customer_lifetime_value), 2) AS avg_clv
FROM insurance_claims
GROUP BY income_segment
ORDER BY avg_claim_amount DESC;


SELECT
    CASE
        WHEN income = 0 THEN 'No Income'
        WHEN income < 30000 THEN 'Low Income'
        WHEN income < 60000 THEN 'Middle Income'
        WHEN income < 90000 THEN 'Upper-Middle Income'
        ELSE 'High Income'
    END AS income_segment,
    vehicle_class,
    COUNT(*) AS total_customers,
    ROUND(AVG(total_claim_amount), 2) AS avg_claim_amount,
    ROUND(AVG(monthly_premium_auto), 2) AS avg_monthly_premium
FROM insurance_claims
GROUP BY income_segment, vehicle_class
HAVING COUNT(*) >= 30
ORDER BY income_segment, avg_claim_amount DESC;



SELECT
    DATE_FORMAT(effective_to_date, '%Y-%m') AS policy_month,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_claim_amount), 2) AS total_claim_amount,
    ROUND(AVG(total_claim_amount), 2) AS avg_claim_amount,
    ROUND(AVG(monthly_premium_auto), 2) AS avg_monthly_premium
FROM insurance_claims
GROUP BY DATE_FORMAT(effective_to_date, '%Y-%m')
ORDER BY policy_month;


-- year checking

SELECT 
    YEAR(effective_to_date) AS year,
    COUNT(*) AS total_rows
FROM insurance_claims
GROUP BY YEAR(effective_to_date);

-- dropping time trend analysis because there is an unexplained gap of 13 years in the dataset..
-- back to EDA


SELECT
    CASE
        WHEN income = 0 THEN 'No Income'
        WHEN income < 30000 THEN 'Low Income'
        WHEN income < 60000 THEN 'Middle Income'
        WHEN income < 90000 THEN 'Upper-Middle Income'
        ELSE 'High Income'
    END AS income_segment,
    vehicle_class,
    coverage,
    COUNT(*) AS total_customers,
    ROUND(AVG(total_claim_amount), 2) AS avg_claim_amount,
    ROUND(AVG(monthly_premium_auto), 2) AS avg_monthly_premium
FROM insurance_claims
GROUP BY income_segment, vehicle_class, coverage
HAVING COUNT(*) >= 30
ORDER BY avg_claim_amount DESC;



SELECT
    CASE
        WHEN income = 0 THEN 'No Income'
        WHEN income < 30000 THEN 'Low Income'
        WHEN income < 60000 THEN 'Middle Income'
        WHEN income < 90000 THEN 'Upper-Middle Income'
        ELSE 'High Income'
    END AS income_segment,
    vehicle_class,
    coverage,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_claim_amount), 2) AS total_claim_amount,
    ROUND(AVG(total_claim_amount), 2) AS avg_claim_amount,
    ROUND(AVG(monthly_premium_auto), 2) AS avg_monthly_premium
FROM insurance_claims
GROUP BY income_segment, vehicle_class, coverage
HAVING COUNT(*) >= 30
ORDER BY total_claim_amount DESC;

