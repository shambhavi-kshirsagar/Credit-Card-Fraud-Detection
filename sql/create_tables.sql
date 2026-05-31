
CREATE DATABASE fraud_detection;

-- Table 1: Core transactions (fact table)
CREATE TABLE transactions (
    TransactionID     BIGINT PRIMARY KEY,
    TransactionDT     BIGINT,
    TransactionAmt    FLOAT,
    ProductCD         VARCHAR(10),
    isFraud           SMALLINT,
    hour              SMALLINT,
    day_of_week       SMALLINT,
    amount_bucket     VARCHAR(20),
    is_high_value     SMALLINT,
    email_match       SMALLINT,
    P_emaildomain     VARCHAR(100)
);

-- Table 2: Card information
CREATE TABLE card_info (
    TransactionID     BIGINT PRIMARY KEY REFERENCES transactions(TransactionID),
    card1             FLOAT,
    card2             FLOAT,
    card3             FLOAT,
    card4             VARCHAR(50),
    card5             FLOAT,
    card6             VARCHAR(50)
);

-- Table 3: Address information
CREATE TABLE address_info (
    TransactionID     BIGINT PRIMARY KEY REFERENCES transactions(TransactionID),
    addr1             FLOAT,
    addr2             FLOAT
);

-- Table 4: Identity information
CREATE TABLE identity_info (
    TransactionID     BIGINT PRIMARY KEY REFERENCES transactions(TransactionID),
    DeviceType        VARCHAR(50),
    DeviceInfo        VARCHAR(200),
    id_12             VARCHAR(50),
    id_13             VARCHAR(50),
    id_15             VARCHAR(50),
    id_16             VARCHAR(50),
    id_17             VARCHAR(50),
    id_19             VARCHAR(50),
    id_20             VARCHAR(50),
    id_28             VARCHAR(50),
    id_29             VARCHAR(50),
    id_31             VARCHAR(100)
);

-- Table 5: Behavior signals
CREATE TABLE behavior (
    TransactionID     BIGINT PRIMARY KEY REFERENCES transactions(TransactionID),
    C1 FLOAT, C2 FLOAT, C3 FLOAT, C4 FLOAT, C5 FLOAT,
    C6 FLOAT, C7 FLOAT, C8 FLOAT, C9 FLOAT, C10 FLOAT,
    C11 FLOAT, C12 FLOAT, C13 FLOAT, C14 FLOAT,
    D1 FLOAT, D2 FLOAT, D3 FLOAT, D4 FLOAT,
    D10 FLOAT, D11 FLOAT, D15 FLOAT
);

-- Load data using COPY command
-- COPY transactions FROM '/path/to/transactions.csv' DELIMITER ',' CSV HEADER;
-- COPY card_info FROM '/path/to/card_info.csv' DELIMITER ',' CSV HEADER;
-- COPY address_info FROM '/path/to/address_info.csv' DELIMITER ',' CSV HEADER;
-- COPY identity_info FROM '/path/to/identity_info.csv' DELIMITER ',' CSV HEADER;
-- COPY behavior FROM '/path/to/behavior.csv' DELIMITER ',' CSV HEADER;
