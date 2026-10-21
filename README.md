# FinTech Fraud & Velocity Detection Engine (SQL)

An analytical fraud detection and behavioral anomaly engine implemented in advanced SQL, evaluated against 6.3+ million transactions from the PaySim synthetic mobile money dataset.

---

## 📌 Project Overview
Mobile money networks suffer from organized financial crime rings where compromised customer accounts are liquidated through rapid outbound relays. Static rules (such as hard limits on transfers > 200,000) often fail to capture distributed, rapid draining of funds or multi-account layering schemes  4. Financial Anomaly & Velocity Detection (Fintech / Fraud Ops) The Business Problem: Identifying suspicious card transactions, duplicate charges, or multi-account velocity spikes that bypass standard rule engines. Key SQL Techniques: Sliding frame window functions: AVG(amount) OVER (PARTITION BY user_id ORDER BY tx_time ROWS BETWEEN 30 PRECEDING AND CURRENT ROW). Self-joins or LAG() looking for transactions on the same account under 5 minutes apart in geographically disjoint locations. Standard.

This project designs and tests an analytical SQL fraud detection layer that detects:
- **Velocity Spikes:** Rolling outbound transaction frequency and volume over sliding time windows [cite: 4. Financial Anomaly & Velocity Detection (Fintech / Fraud Ops) The Business Problem: Identifying suspicious card transactions, duplicate charges, or multi-account velocity spikes that bypass standard rule engines. Key SQL Techniques: Sliding frame window functions: AVG(amount) OVER (PARTITION BY user_id ORDER BY tx_time ROWS BETWEEN 30 PRECEDING AND CURRENT ROW). Self-joins or LAG() looking for transactions on the same account under 5 minutes apart in geographically disjoint locations. Standard].
- **Account Draining ("Drain & Run"):** Rapid account emptying where outbound amounts match 100% of the sender's existing balance.
- **Mule Relays:** Coordinated hops where inbound funds received via `TRANSFER` are liquidated via `CASH_OUT` within a short time frame [cite: 4. Financial Anomaly & Velocity Detection (Fintech / Fraud Ops) The Business Problem: Identifying suspicious card transactions, duplicate charges, or multi-account velocity spikes that bypass standard rule engines. Key SQL Techniques: Sliding frame window functions: AVG(amount) OVER (PARTITION BY user_id ORDER BY tx_time ROWS BETWEEN 30 PRECEDING AND CURRENT ROW). Self-joins or LAG() looking for transactions on the same account under 5 minutes apart in geographically disjoint locations. Standard].

---

## 📊 Dataset Details
- **Source:** [Kaggle - PaySim Synthetic Financial Datasets For Fraud Detection](https://www.kaggle.com/datasets/ealaxi/paysim1)
- **Scale:** 6,362,620 transactions (30 days of simulated activity; 1 step = 1 hour).
- **Fraud Instances:** 8,213 labeled fraudulent transactions (~0.13% incidence rate).
- **Targeted Operations:** Fraudulent activity in this dataset is confined exclusively to `TRANSFER` and `CASH_OUT` transaction types.

---

## 📁 Repository Structure
```text
financial-fraud-detection-sql/
├── .gitignore
├── README.md
├── data/
│   └── sample_transactions.csv     # First 2,000 transactions for local execution
└── sql/
    ├── 01_schema_setup.sql         # Typed DDL and index creation
    ├── 02_exploratory_analysis.sql # Transaction breakdown & baseline loss analysis
    └── 03_fraud_heuristics.sql     # Velocity windows, mule hops, and balance drain logic
