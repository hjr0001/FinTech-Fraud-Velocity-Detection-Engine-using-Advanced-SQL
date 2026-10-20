CREATE TABLE IF NOT EXISTS transactions (
    step INTEGER,
    type TEXT,
    amount REAL,
    nameOrig TEXT,
    oldbalanceOrg REAL,
    newbalanceOrig REAL,
    nameDest TEXT,
    oldbalanceDest REAL,
    newbalanceDest REAL,
    isFraud INTEGER,
    isFlaggedFraud INTEGER
);
CREATE INDEX IF NOT EXISTS idx_orig_step ON transactions(nameOrig, step);
CREATE INDEX IF NOT EXISTS idx_dest_step ON transactions(nameDest, step);
CREATE INDEX IF NOT EXISTS idx_type ON transactions(type);
