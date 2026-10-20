-- 1. Full balance clearing ("Drain & Run")
WITH balance_depletion AS (
    SELECT 
        step,
        type,
        nameOrig,
        amount,
        oldbalanceOrg,
        newbalanceOrig,
        isFraud,
        CASE 
            WHEN oldbalanceOrg > 0 AND newbalanceOrig = 0 AND amount >= oldbalanceOrg 
            THEN 1 ELSE 0 
        END AS is_account_drained
    FROM transactions
    WHERE type IN ('TRANSFER', 'CASH_OUT')
)
SELECT 
    is_account_drained,
    COUNT(*) AS total_tx,
    SUM(isFraud) AS true_positives,
    ROUND(AVG(isFraud) * 100, 2) AS precision_pct
FROM balance_depletion
GROUP BY is_account_drained;

-- 2. Mule Account Network: Transfer followed by immediate Cash-Out within 2 hours
SELECT 
    t1.step AS transfer_step,
    t1.nameOrig AS victim_account,
    t1.amount AS transfer_amount,
    t1.nameDest AS intermediary_account,
    t2.step AS cashout_step,
    t2.amount AS cashout_amount,
    (t2.step - t1.step) AS step_difference,
    t1.isFraud AS transfer_is_fraud,
    t2.isFraud AS cashout_is_fraud
FROM transactions t1
JOIN transactions t2 
    ON t1.nameDest = t2.nameOrig
   AND t2.step BETWEEN t1.step AND t1.step + 2
WHERE t1.type = 'TRANSFER'
  AND t2.type = 'CASH_OUT'
  AND ABS(t1.amount - t2.amount) <= (0.05 * t1.amount)
ORDER BY t1.amount DESC
LIMIT 100;
