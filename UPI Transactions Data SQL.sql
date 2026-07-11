SELECT COUNT(*) AS total_rows
FROM upi_transactions_2024;

SELECT *
FROM upi_transactions_2024
LIMIT 10;

SELECT `transaction id`, COUNT(*) AS occurrence
FROM upi_transactions_2024
GROUP BY `transaction id`
HAVING COUNT(*) > 1;

SELECT
    SUM(`transaction id` IS NULL) AS transaction_id_nulls,
    SUM(`timestamp` IS NULL) AS timestamp_nulls,
    SUM(`transaction type` IS NULL) AS transaction_type_nulls,
    SUM(`merchant_category` IS NULL) AS merchant_category_nulls,
    SUM(`amount (INR)` IS NULL) AS amount_nulls,
    SUM(`transaction_status` IS NULL) AS status_nulls,
    SUM(`sender_age_group` IS NULL) AS sender_age_nulls,
    SUM(`receiver_age_group` IS NULL) AS receiver_age_nulls,
    SUM(`sender_state` IS NULL) AS state_nulls,
    SUM(`sender_bank` IS NULL) AS sender_bank_nulls,
    SUM(`receiver_bank` IS NULL) AS receiver_bank_nulls,
    SUM(`device_type` IS NULL) AS device_nulls,
    SUM(`network_type` IS NULL) AS network_nulls,
    SUM(`fraud_flag` IS NULL) AS fraud_nulls,
    SUM(`hour_of_day` IS NULL) AS hour_nulls,
    SUM(`day_of_week` IS NULL) AS day_nulls,
    SUM(`is_weekend` IS NULL) AS weekend_nulls
FROM upi_transactions_2024;


SELECT
    MIN(`amount (INR)`) AS minimum_amount,
    MAX(`amount (INR)`) AS maximum_amount,
    AVG(`amount (INR)`) AS average_amount
FROM upi_transactions_2024;


SELECT
    MIN(`timestamp`) AS earliest_transaction,
    MAX(`timestamp`) AS latest_transaction
FROM upi_transactions_2024;


SELECT DISTINCT `transaction type`
FROM upi_transactions_2024;

SELECT DISTINCT `transaction_status`
FROM upi_transactions_2024;

SELECT DISTINCT `device_type`
FROM upi_transactions_2024;

SELECT DISTINCT `network_type`
FROM upi_transactions_2024;




SELECT
    COUNT(*) AS total_transactions,
    SUM(`amount (INR)`) AS total_transaction_value,
    AVG(`amount (INR)`) AS average_transaction_value,
    COUNT(CASE WHEN transaction_status = 'SUCCESS' THEN 1 ELSE NULL END)
        AS successful_transactions,
    COUNT(CASE WHEN transaction_status = 'FAILED' THEN 1 ELSE NULL END)
        AS failed_transactions
FROM upi_transactions_2024;


SELECT
    ROUND(COUNT(CASE WHEN transaction_status = 'SUCCESS' THEN 1 END) / COUNT(*) * 100, 2) AS success_rate,
    ROUND(COUNT(CASE WHEN transaction_status = 'FAILED' THEN 1 END) / COUNT(*) * 100, 2) AS failure_rate
FROM upi_transactions_2024;

SELECT
    `transaction type`,
    COUNT(*) AS transaction_volume,
    SUM(`amount (INR)`) AS total_transaction_value
FROM upi_transactions_2024
GROUP BY `transaction type`;

SELECT
    `transaction type`,
    ROUND(AVG(`amount (INR)`), 2) AS average_transaction_amount
FROM upi_transactions_2024
GROUP BY `transaction type`
ORDER BY average_transaction_amount DESC;

SELECT
    merchant_category,
    COUNT(*) AS transaction_volume,
    SUM(`amount (INR)`) AS total_transaction_value
FROM upi_transactions_2024
GROUP BY merchant_category
ORDER BY transaction_volume DESC;


SELECT
    merchant_category,
    ROUND(AVG(`amount (INR)`), 2) AS average_transaction_amount
FROM upi_transactions_2024
GROUP BY merchant_category
ORDER BY average_transaction_amount DESC;

SELECT
    sender_bank,
    COUNT(*) AS transaction_volume,
    SUM(`amount (INR)`) AS total_transaction_value,
    ROUND(
        COUNT(CASE WHEN transaction_status = 'FAILED' THEN 1 END)
        / COUNT(*) * 100,
        2
    ) AS failure_rate
FROM upi_transactions_2024
GROUP BY sender_bank
ORDER BY transaction_volume DESC;


SELECT
    network_type,
    COUNT(*) AS transaction_volume,
    COUNT(CASE WHEN transaction_status = 'FAILED' THEN 1 END)
        AS failed_transactions,
    ROUND(
        COUNT(CASE WHEN transaction_status = 'FAILED' THEN 1 END)
        / COUNT(*) * 100,
        2
    ) AS failure_rate
FROM upi_transactions_2024
GROUP BY network_type
ORDER BY failure_rate DESC;


SELECT
    `transaction type`,
    COUNT(*) AS total_transactions,
    COUNT(CASE WHEN fraud_flag = 1 THEN 1 END) AS fraud_transactions,
    ROUND(
        COUNT(CASE WHEN fraud_flag = 1 THEN 1 END)
        / COUNT(*) * 100,
        2
    ) AS fraud_rate
FROM upi_transactions_2024
GROUP BY `transaction type`
ORDER BY fraud_rate DESC;


SELECT
    `transaction type`,
    SUM(`amount (INR)`) AS total_transaction_value,
    SUM(CASE WHEN fraud_flag = 1 THEN `amount (INR)` ELSE 0 END)
        AS fraudulent_transaction_value,
    ROUND(
        SUM(CASE WHEN fraud_flag = 1 THEN `amount (INR)` ELSE 0 END)
        / SUM(`amount (INR)`) * 100,
        2
    ) AS fraud_value_percentage
FROM upi_transactions_2024
GROUP BY `transaction type`
ORDER BY fraud_value_percentage DESC;

WITH bank_transaction_value AS (
    SELECT
        sender_bank,
        SUM(`amount (INR)`) AS total_transaction_value
    FROM upi_transactions_2024
    GROUP BY sender_bank
)

SELECT
    sender_bank,
    total_transaction_value,
    RANK() OVER (
        ORDER BY total_transaction_value DESC
    ) AS bank_rank
FROM bank_transaction_value;


WITH category_value AS (
    SELECT
        merchant_category,
        SUM(`amount (INR)`) AS total_transaction_value
    FROM upi_transactions_2024
    GROUP BY merchant_category
)

SELECT
    merchant_category,
    total_transaction_value,
    ROUND(
        total_transaction_value
        / SUM(total_transaction_value) OVER () * 100,
        2
    ) AS percentage_contribution
FROM category_value
ORDER BY percentage_contribution DESC;



WITH monthly_transactions AS (
    SELECT
        MONTH(`timestamp`) AS month_number,
        MONTHNAME(`timestamp`) AS month_name,
        SUM(`amount (INR)`) AS total_transaction_value
    FROM upi_transactions_2024
    GROUP BY
        MONTH(`timestamp`),
        MONTHNAME(`timestamp`)
),

monthly_comparison AS (
    SELECT
        month_number,
        month_name,
        total_transaction_value,
        LAG(total_transaction_value) OVER (
            ORDER BY month_number
        ) AS previous_month_value
    FROM monthly_transactions
)

SELECT
    month_name,
    total_transaction_value,
    previous_month_value,
    ROUND(
        (total_transaction_value - previous_month_value)
        / previous_month_value * 100,
        2
    ) AS mom_growth_rate
FROM monthly_comparison
ORDER BY month_number;



SELECT
    hour_of_day,
    COUNT(*) AS total_transactions,
    COUNT(CASE WHEN fraud_flag = 1 THEN 1 END) AS fraud_transactions,
    ROUND(
        COUNT(CASE WHEN fraud_flag = 1 THEN 1 END)
        / COUNT(*) * 100,
        2
    ) AS fraud_rate
FROM upi_transactions_2024
GROUP BY hour_of_day
ORDER BY fraud_rate DESC;