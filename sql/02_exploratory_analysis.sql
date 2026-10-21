-- Fraud distribution across transaction types
SELECT 
    type,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_count,
    ROUND(AVG(isFraud) * 100, 4) AS fraud_rate_pct,
    ROUND(SUM(amount) FILTER (WHERE isFraud = 1), 2) AS total_fraud_loss,
    ROUND(AVG(amount) FILTER (WHERE isFraud = 1), 2) AS avg_fraud_ticket_size
FROM transactions
GROUP BY type
ORDER BY fraud_count DESC;
