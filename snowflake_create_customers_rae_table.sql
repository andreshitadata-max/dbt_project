USE ROLE ACCOUNTADMIN;
USE DATABASE DB_ANALYTICS;


CREATE OR REPLACE TABLE DB_ANALYTICS.RAW_SCHEMA.CUSTOMERS (
    customer_id   INTEGER        NOT NULL,
    first_name    VARCHAR(50),
    last_name     VARCHAR(50),
    email         VARCHAR(100),
    phone         VARCHAR(30),
    city          VARCHAR(50),
    country       VARCHAR(50),
    created_at    TIMESTAMP_NTZ  DEFAULT CURRENT_TIMESTAMP()
);

-- Clientes 1 a 6 (los de los pedidos manuales)
INSERT INTO DB_ANALYTICS.RAW_SCHEMA.CUSTOMERS
    (customer_id, first_name, last_name, email, phone, city, country, created_at)
VALUES
    (1, 'Lucía',  'Fernández', 'lucia.fernandez@example.com', '+34 600 111 222',  'Granada',          'España',         '2025-11-02 10:15:00'),
    (2, 'Carlos', 'Ruiz',      'carlos.ruiz@example.com',      '+34 611 222 333',  'Madrid',           'España',         '2025-11-20 09:40:00'),
    (3, 'Emma',   'Johnson',   'emma.johnson@example.com',     '+1 415 555 0134',  'San Francisco',    'Estados Unidos', '2025-12-05 14:30:00'),
    (4, 'Mateo',  'Silva',     'mateo.silva@example.com',      '+57 300 123 4567', 'Bogotá',           'Colombia',       '2025-12-18 17:05:00'),
    (5, 'Sofía',  'Martínez',  'sofia.martinez@example.com',   '+52 55 1234 5678', 'Ciudad de México', 'México',         '2026-01-10 11:20:00'),
    (6, 'Liam',   'Brown',     'liam.brown@example.com',       '+44 20 7946 0958', 'Londres',          'Reino Unido',    '2026-01-25 08:50:00');

-- Clientes 7 a 50 (ciudad, país y prefijo telefónico coherentes)
INSERT INTO DB_ANALYTICS.RAW_SCHEMA.CUSTOMERS
    (customer_id, first_name, last_name, email, phone, city, country, created_at)
WITH ids AS (
    SELECT 6 + ROW_NUMBER() OVER (ORDER BY SEQ4()) AS customer_id
    FROM TABLE(GENERATOR(ROWCOUNT => 44))
),
locations AS (
    SELECT * FROM (VALUES
        (0, 'Granada',          'España',         '+34 6'),
        (1, 'Madrid',           'España',         '+34 6'),
        (2, 'Barcelona',        'España',         '+34 6'),
        (3, 'Bogotá',           'Colombia',       '+57 3'),
        (4, 'Medellín',         'Colombia',       '+57 3'),
        (5, 'Ciudad de México', 'México',         '+52 55'),
        (6, 'Guadalajara',      'México',         '+52 33'),
        (7, 'Londres',          'Reino Unido',    '+44 20'),
        (8, 'San Francisco',    'Estados Unidos', '+1 415'),
        (9, 'Nueva York',       'Estados Unidos', '+1 212')
    ) AS t(loc_id, city, country, phone_prefix)
),
base AS (
    SELECT
        customer_id,
        ARRAY_CONSTRUCT('Ana','Pablo','Laura','Diego','Marta','Javier','Elena','Andrés','Clara','Hugo')[MOD(customer_id, 10)]::STRING AS first_name,
        ARRAY_CONSTRUCT('García','López','Torres','Moreno','Smith','Rojas','Navarro','Gómez','Wilson','Castro')[MOD(customer_id * 3, 10)]::STRING AS last_name
    FROM ids
)
SELECT
    b.customer_id,
    b.first_name,
    b.last_name,
    LOWER(TRANSLATE(b.first_name || '.' || b.last_name, 'áéíóúñ', 'aeioun')) || b.customer_id || '@example.com',
    l.phone_prefix || ' ' || LPAD(UNIFORM(0, 9999999, RANDOM())::STRING, 7, '0'),
    l.city,
    l.country,
    DATEADD(day, -UNIFORM(366, 700, RANDOM()), CURRENT_TIMESTAMP())
FROM base b
JOIN locations l ON l.loc_id = MOD(b.customer_id, 10);
