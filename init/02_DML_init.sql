DROP TABLE IF EXISTS staging_mock_data;

CREATE TEMP TABLE staging_mock_data (
    id                     INTEGER,
    customer_first_name    TEXT,
    customer_last_name     TEXT,
    customer_age           INTEGER,
    customer_email         TEXT,
    customer_country       TEXT,
    customer_postal_code   TEXT,
    customer_pet_type      TEXT,
    customer_pet_name      TEXT,
    customer_pet_breed     TEXT,

    seller_first_name      TEXT,
    seller_last_name       TEXT,
    seller_email           TEXT,
    seller_country         TEXT,
    seller_postal_code     TEXT,

    product_name           TEXT,
    product_category       TEXT,
    product_price          NUMERIC,
    product_quantity       INTEGER,

    sale_date              TEXT,  
    sale_customer_id       INTEGER,
    sale_seller_id         INTEGER,
    sale_product_id        INTEGER,
    sale_quantity          INTEGER,
    sale_total_price       NUMERIC,

    store_name             TEXT,
    store_location         TEXT,
    store_city             TEXT,
    store_state            TEXT,
    store_country          TEXT,
    store_phone            TEXT,
    store_email            TEXT,

    pet_category           TEXT,
    product_weight         NUMERIC,
    product_color          TEXT,
    product_size           TEXT,
    product_brand          TEXT,
    product_material       TEXT,
    product_description    TEXT,
    product_rating         NUMERIC,
    product_reviews        INTEGER,

    product_release_date   TEXT,
    product_expiry_date    TEXT,

    supplier_name          TEXT,
    supplier_contact       TEXT,
    supplier_email         TEXT,
    supplier_phone         TEXT,
    supplier_address       TEXT,
    supplier_city          TEXT,
    supplier_country       TEXT
);

\echo '>>> COPY CSV-файлы во временную таблицу'

COPY staging_mock_data
FROM '/docker-entrypoint-initdb.d/initial_data/MOCK_DATA_0.csv'
WITH (FORMAT csv, HEADER TRUE);

COPY staging_mock_data
FROM '/docker-entrypoint-initdb.d/initial_data/MOCK_DATA_1.csv'
WITH (FORMAT csv, HEADER TRUE);

COPY staging_mock_data
FROM '/docker-entrypoint-initdb.d/initial_data/MOCK_DATA_2.csv'
WITH (FORMAT csv, HEADER TRUE);

COPY staging_mock_data
FROM '/docker-entrypoint-initdb.d/initial_data/MOCK_DATA_3.csv'
WITH (FORMAT csv, HEADER TRUE);

COPY staging_mock_data
FROM '/docker-entrypoint-initdb.d/initial_data/MOCK_DATA_4.csv'
WITH (FORMAT csv, HEADER TRUE);

COPY staging_mock_data
FROM '/docker-entrypoint-initdb.d/initial_data/MOCK_DATA_5.csv'
WITH (FORMAT csv, HEADER TRUE);

COPY staging_mock_data
FROM '/docker-entrypoint-initdb.d/initial_data/MOCK_DATA_6.csv'
WITH (FORMAT csv, HEADER TRUE);

COPY staging_mock_data
FROM '/docker-entrypoint-initdb.d/initial_data/MOCK_DATA_7.csv'
WITH (FORMAT csv, HEADER TRUE);

COPY staging_mock_data
FROM '/docker-entrypoint-initdb.d/initial_data/MOCK_DATA_8.csv'
WITH (FORMAT csv, HEADER TRUE);

COPY staging_mock_data
FROM '/docker-entrypoint-initdb.d/initial_data/MOCK_DATA_9.csv'
WITH (FORMAT csv, HEADER TRUE);

\echo '>>> INSERT 10 000 строк в mock_data'

INSERT INTO mock_data (
    original_id,
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    customer_country,
    customer_postal_code,
    customer_pet_type,
    customer_pet_name,
    customer_pet_breed,
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code,
    product_name,
    product_category,
    product_price,
    product_quantity,
    sale_date,
    sale_customer_id,
    sale_seller_id,
    sale_product_id,
    sale_quantity,
    sale_total_price,
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email,
    pet_category,
    product_weight,
    product_color,
    product_size,
    product_brand,
    product_material,
    product_description,
    product_rating,
    product_reviews,
    product_release_date,
    product_expiry_date,
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
)
SELECT
    id AS original_id,
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    customer_country,
    customer_postal_code,
    customer_pet_type,
    customer_pet_name,
    customer_pet_breed,
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code,
    product_name,
    product_category,
    product_price,
    product_quantity,
    TO_DATE(sale_date,             'MM/DD/YYYY'),
    sale_customer_id,
    sale_seller_id,
    sale_product_id,
    sale_quantity,
    sale_total_price,
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email,
    pet_category,
    product_weight,
    product_color,
    product_size,
    product_brand,
    product_material,
    product_description,
    product_rating,
    product_reviews,
    TO_DATE(product_release_date,  'MM/DD/YYYY'),
    TO_DATE(product_expiry_date,   'MM/DD/YYYY'),
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
FROM staging_mock_data;

DROP TABLE IF EXISTS staging_mock_data;

ALTER TABLE mock_data DROP COLUMN original_id;

\echo '>>> Проверка количества строк'
SELECT COUNT(*) AS total_rows
FROM   mock_data;
