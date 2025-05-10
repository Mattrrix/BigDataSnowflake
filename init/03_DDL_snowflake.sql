CREATE TABLE dim_city (
    id   BIGSERIAL PRIMARY KEY,
    name TEXT UNIQUE
);

CREATE TABLE dim_country (
    id   BIGSERIAL PRIMARY KEY,
    name TEXT UNIQUE
);

CREATE TABLE dim_location (
    id       BIGSERIAL PRIMARY KEY,
    location TEXT UNIQUE
);

CREATE TABLE dim_customer (
    id         BIGSERIAL PRIMARY KEY,
    first_name TEXT,
    last_name  TEXT,
    age        INT,
    email      TEXT UNIQUE,
    country_id BIGINT REFERENCES dim_country(id)
);

CREATE TABLE dim_pet (
    id          BIGSERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    customer_id BIGINT NOT NULL REFERENCES dim_customer(id)
);

CREATE TABLE dim_type (
    id     BIGSERIAL PRIMARY KEY,
    name   TEXT UNIQUE,
    pet_id BIGINT NOT NULL REFERENCES dim_pet(id)
);

CREATE TABLE dim_breed (
    id     BIGSERIAL PRIMARY KEY,
    name   TEXT UNIQUE,
    pet_id BIGINT NOT NULL REFERENCES dim_pet(id)
);

CREATE TABLE dim_day (
    day_key      SMALLINT PRIMARY KEY,
    day_of_month SMALLINT NOT NULL
);

CREATE TABLE dim_month (
    month_key     SMALLINT PRIMARY KEY,
    month_of_year SMALLINT NOT NULL,
    month_name    TEXT       NOT NULL,
    quarter       SMALLINT   NOT NULL
);

CREATE TABLE dim_weekday (
    weekday_key   SMALLINT PRIMARY KEY,
    weekday_name  TEXT     NOT NULL
);

CREATE TABLE dim_date (
    date_key     DATE       PRIMARY KEY,
    year         SMALLINT   NOT NULL,
    day_key      SMALLINT   NOT NULL REFERENCES dim_day(day_key),
    month_key    SMALLINT   NOT NULL REFERENCES dim_month(month_key),
    weekday_key  SMALLINT   NOT NULL REFERENCES dim_weekday(weekday_key)
);

CREATE TABLE dim_brand (
    id   BIGSERIAL PRIMARY KEY,
    name TEXT UNIQUE
);

CREATE TABLE dim_category (
    id   BIGSERIAL PRIMARY KEY,
    name TEXT UNIQUE
);

CREATE TABLE dim_color (
    id    BIGSERIAL PRIMARY KEY,
    color TEXT UNIQUE
);

CREATE TABLE dim_material (
    id       BIGSERIAL PRIMARY KEY,
    material TEXT      UNIQUE
);

CREATE TABLE dim_size (
    id   BIGSERIAL PRIMARY KEY,
    size TEXT      UNIQUE
);

CREATE TABLE dim_weight (
    id     BIGSERIAL PRIMARY KEY,
    weight NUMERIC(10,2) UNIQUE
);

CREATE TABLE dim_product (
    id               BIGSERIAL PRIMARY KEY,
    name             TEXT,
    category_id      BIGINT REFERENCES dim_category(id),
    brand_id         BIGINT REFERENCES dim_brand(id),
    color_id         BIGINT REFERENCES dim_color(id),
    material_id      BIGINT REFERENCES dim_material(id),
    size_id          BIGINT REFERENCES dim_size(id),
    weight_id        BIGINT REFERENCES dim_weight(id),
    description      TEXT,
    release_date_key DATE REFERENCES dim_date(date_key),
    expiry_date_key  DATE REFERENCES dim_date(date_key),
    UNIQUE (name, brand_id)
);

CREATE TABLE dim_seller (
    id         BIGSERIAL PRIMARY KEY,
    first_name TEXT,
    last_name  TEXT,
    email      TEXT UNIQUE,
    country_id BIGINT REFERENCES dim_country(id)
);

CREATE TABLE dim_store (
    id           BIGSERIAL PRIMARY KEY,
    name         TEXT UNIQUE,
    location_id  BIGINT REFERENCES dim_location(id),
    state        TEXT,
    phone        TEXT,
    email        TEXT,
    city_id      BIGINT REFERENCES dim_city(id),
    country_id   BIGINT REFERENCES dim_country(id)
);

CREATE TABLE dim_supplier (
    id         BIGSERIAL PRIMARY KEY,
    name       TEXT UNIQUE,
    contact    TEXT,
    email      TEXT,
    phone      TEXT,
    address    TEXT,
    city_id    BIGINT REFERENCES dim_city(id),
    country_id BIGINT REFERENCES dim_country(id)
);

CREATE TABLE fact_sales (
    id            BIGSERIAL PRIMARY KEY,
    date_key      DATE      REFERENCES dim_date(date_key),
    customer_id   BIGINT    REFERENCES dim_customer(id),
    seller_id     BIGINT    REFERENCES dim_seller(id),
    product_id    BIGINT    REFERENCES dim_product(id),
    store_id      BIGINT    REFERENCES dim_store(id),
    supplier_id   BIGINT    REFERENCES dim_supplier(id),
    quantity      INT,
    total_price   NUMERIC(12,2)
);
CREATE INDEX ON fact_sales (date_key);
