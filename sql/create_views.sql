
-- View 1: Fraud KPI Overview
CREATE VIEW vw_fraud_overview AS
SELECT
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS total_fraud,
    ROUND(SUM(isFraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct,
    ROUND(SUM(TransactionAmt)::numeric, 2) AS total_transaction_value,
    ROUND(SUM(CASE WHEN isFraud = 1 THEN TransactionAmt ELSE 0 END)::numeric, 2) AS total_fraud_value,
    ROUND(AVG(CASE WHEN isFraud = 1 THEN TransactionAmt END)::numeric, 2) AS avg_fraud_amount,
    ROUND(AVG(CASE WHEN isFraud = 0 THEN TransactionAmt END)::numeric, 2) AS avg_legit_amount
FROM transactions;

-- View 2: Fraud by Product Category
CREATE VIEW vw_fraud_by_product AS
SELECT
    ProductCD,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_count,
    ROUND(SUM(isFraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct,
    ROUND(SUM(CASE WHEN isFraud = 1 THEN TransactionAmt ELSE 0 END)::numeric, 2) AS fraud_value
FROM transactions
GROUP BY ProductCD
ORDER BY fraud_rate_pct DESC;

-- View 3: Fraud by Hour of Day
CREATE VIEW vw_fraud_by_hour AS
SELECT
    hour,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_count,
    ROUND(SUM(isFraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct
FROM transactions
GROUP BY hour
ORDER BY hour;

-- View 4: Fraud by Amount Bucket
CREATE VIEW vw_fraud_by_amount AS
SELECT
    amount_bucket,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_count,
    ROUND(SUM(isFraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct,
    ROUND(AVG(TransactionAmt)::numeric, 2) AS avg_amount
FROM transactions
GROUP BY amount_bucket
ORDER BY fraud_rate_pct DESC;

-- View 5: Fraud by Device Type
CREATE VIEW vw_fraud_by_device AS
SELECT
    i.DeviceType,
    COUNT(*) AS total_transactions,
    SUM(t.isFraud) AS fraud_count,
    ROUND(SUM(t.isFraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct
FROM transactions t
LEFT JOIN identity_info i ON t.TransactionID = i.TransactionID
GROUP BY i.DeviceType
ORDER BY fraud_rate_pct DESC;

-- View 6: Fraud by Card Network and Type
CREATE VIEW vw_fraud_by_card AS
SELECT
    c.card4 AS card_network,
    c.card6 AS card_type,
    COUNT(*) AS total_transactions,
    SUM(t.isFraud) AS fraud_count,
    ROUND(SUM(t.isFraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct,
    ROUND(SUM(CASE WHEN t.isFraud = 1 THEN t.TransactionAmt ELSE 0 END)::numeric, 2) AS fraud_value
FROM transactions t
LEFT JOIN card_info c ON t.TransactionID = c.TransactionID
GROUP BY c.card4, c.card6
ORDER BY fraud_rate_pct DESC;

-- View 7: Fraud by Day of Week
CREATE VIEW vw_fraud_by_day AS
SELECT
    day_of_week,
    CASE day_of_week
        WHEN 0 THEN 'Monday'
        WHEN 1 THEN 'Tuesday'
        WHEN 2 THEN 'Wednesday'
        WHEN 3 THEN 'Thursday'
        WHEN 4 THEN 'Friday'
        WHEN 5 THEN 'Saturday'
        WHEN 6 THEN 'Sunday'
    END AS day_name,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_count,
    ROUND(SUM(isFraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct
FROM transactions
GROUP BY day_of_week
ORDER BY day_of_week;
