USE ROLE ACCOUNTADMIN;
USE DATABASE DB_ANALYTICS;

--CREATE SCHEMA IF NOT EXISTS RAW_SCHEMA;

CREATE OR REPLACE TABLE DB_ANALYTICS.RAW_SCHEMA.ORDERS (
    o_id       INTEGER        NOT NULL,
    cust_id    INTEGER        NOT NULL,
    order_date     DATE           NOT NULL,
    status         VARCHAR(20),
    total_amount   NUMBER(10,2),
    currency       VARCHAR(3),
    created_at     TIMESTAMP_NTZ  DEFAULT CURRENT_TIMESTAMP()
);


INSERT INTO DB_ANALYTICS.RAW_SCHEMA.ORDERS
    (o_id, cust_id, order_date, status, total_amount, currency)
SELECT
    2000 + SEQ4(),
    UNIFORM(1, 50, RANDOM()),
    DATEADD(day, -UNIFORM(0, 365, RANDOM()), CURRENT_DATE()),
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'completed' WHEN 2 THEN 'shipped'
        WHEN 3 THEN 'pending'   WHEN 4 THEN 'returned'
        ELSE 'cancelled' END,
    ROUND(UNIFORM(10, 500, RANDOM()) + UNIFORM(0, 99, RANDOM()) / 100, 2),
    CASE UNIFORM(1, 2, RANDOM()) WHEN 1 THEN 'EUR' ELSE 'USD' END
FROM TABLE(GENERATOR(ROWCOUNT => 1000));
