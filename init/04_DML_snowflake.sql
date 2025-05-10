BEGIN;

-- 1. dim_country
INSERT INTO dim_country(name)
SELECT DISTINCT c
FROM mock_data m,
     LATERAL unnest(ARRAY[
         m.store_country,
         m.supplier_country,
         m.customer_country,
         m.seller_country
     ]) AS c
WHERE c IS NOT NULL AND trim(c)<>''
ON CONFLICT DO NOTHING;

-- 2. dim_city
INSERT INTO dim_city(name)
SELECT DISTINCT m.store_city
FROM mock_data m
WHERE m.store_city IS NOT NULL AND trim(m.store_city)<>''
ON CONFLICT DO NOTHING;

-- 3. dim_location
INSERT INTO dim_location(location)
SELECT DISTINCT m.store_location
FROM mock_data m
WHERE m.store_location IS NOT NULL AND trim(m.store_location)<>''
ON CONFLICT DO NOTHING;

-- 4. dim_customer
INSERT INTO dim_customer(first_name, last_name, age, email, country_id)
SELECT DISTINCT
    m.customer_first_name,
    m.customer_last_name,
    m.customer_age,
    m.customer_email,
    co.id
FROM mock_data m
LEFT JOIN dim_country co ON co.name=m.customer_country
ON CONFLICT DO NOTHING;

-- 5. dim_pet
INSERT INTO dim_pet(name, customer_id)
SELECT DISTINCT
    m.customer_pet_name,
    cu.id
FROM mock_data m
JOIN dim_customer cu ON cu.email=m.customer_email
WHERE m.customer_pet_name IS NOT NULL
ON CONFLICT DO NOTHING;

-- 6. dim_type
INSERT INTO dim_type(name, pet_id)
SELECT DISTINCT
    m.customer_pet_type,
    p.id
FROM mock_data m
JOIN dim_customer cu ON cu.email=m.customer_email
JOIN dim_pet p ON p.name = m.customer_pet_name AND p.customer_id = cu.id
WHERE m.customer_pet_type IS NOT NULL
ON CONFLICT DO NOTHING;

-- 7. dim_breed
INSERT INTO dim_breed(name, pet_id)
SELECT DISTINCT
    m.customer_pet_breed,
    p.id
FROM mock_data m
JOIN dim_customer cu ON cu.email=m.customer_email
JOIN dim_pet p ON p.name = m.customer_pet_name AND p.customer_id = cu.id
WHERE m.customer_pet_breed IS NOT NULL
ON CONFLICT DO NOTHING;

-- 8. dim_day
INSERT INTO dim_day(day_key, day_of_month)
SELECT DISTINCT
    EXTRACT(DAY FROM m.sale_date)::SMALLINT,
    EXTRACT(DAY FROM m.sale_date)::SMALLINT
FROM mock_data m
WHERE m.sale_date IS NOT NULL
ON CONFLICT DO NOTHING;

-- 9. dim_month
INSERT INTO dim_month(month_key, month_of_year, month_name, quarter)
SELECT DISTINCT
    EXTRACT(MONTH FROM m.sale_date)::SMALLINT,
    EXTRACT(MONTH FROM m.sale_date)::SMALLINT,
    to_char(m.sale_date,'Month'),
    EXTRACT(QUARTER FROM m.sale_date)::SMALLINT
FROM mock_data m
WHERE m.sale_date IS NOT NULL
ON CONFLICT DO NOTHING;

-- 10. dim_weekday
INSERT INTO dim_weekday(weekday_key, weekday_name)
VALUES
    (0,'Sunday'),
    (1,'Monday'),
    (2,'Tuesday'),
    (3,'Wednesday'),
    (4,'Thursday'),
    (5,'Friday'),
    (6,'Saturday')
ON CONFLICT DO NOTHING;

-- 11. dim_date
INSERT INTO dim_date(date_key, year, day_key, month_key, weekday_key)
SELECT
    d.d                  AS date_key,
    EXTRACT(YEAR FROM d.d)::SMALLINT,
    EXTRACT(DAY  FROM d.d)::SMALLINT,
    EXTRACT(MONTH FROM d.d)::SMALLINT,
    EXTRACT(DOW  FROM d.d)::SMALLINT
FROM (
    SELECT generate_series(
        (SELECT MIN(sale_date) FROM mock_data),
        (SELECT MAX(sale_date) FROM mock_data),
        '1 day'
    ) AS d
) AS d
ON CONFLICT DO NOTHING;

-- 12. dim_brand
INSERT INTO dim_brand(name)
SELECT DISTINCT m.product_brand
FROM mock_data m
WHERE m.product_brand IS NOT NULL
ON CONFLICT DO NOTHING;

-- 13. dim_category
INSERT INTO dim_category(name)
SELECT DISTINCT m.product_category
FROM mock_data m
WHERE m.product_category IS NOT NULL
ON CONFLICT DO NOTHING;

-- 14. dim_color
INSERT INTO dim_color(color)
SELECT DISTINCT m.product_color
FROM mock_data m
WHERE m.product_color IS NOT NULL
ON CONFLICT DO NOTHING;

-- 15. dim_material
INSERT INTO dim_material(material)
SELECT DISTINCT m.product_material
FROM mock_data m
WHERE m.product_material IS NOT NULL
ON CONFLICT DO NOTHING;

-- 16. dim_size
INSERT INTO dim_size(size)
SELECT DISTINCT m.product_size
FROM mock_data m
WHERE m.product_size IS NOT NULL
ON CONFLICT DO NOTHING;

-- 17. dim_weight
INSERT INTO dim_weight(weight)
SELECT DISTINCT m.product_weight
FROM mock_data m
WHERE m.product_weight IS NOT NULL
ON CONFLICT DO NOTHING;

-- 18. dim_product
INSERT INTO dim_product(
    name, category_id, brand_id,
    color_id, material_id, size_id, weight_id,
    description, release_date_key, expiry_date_key
)
SELECT DISTINCT
    m.product_name,
    cat.id,
    br.id,
    col.id,
    mat.id,
    sz.id,
    w.id,
    m.product_description,
    dr.date_key,
    de.date_key
FROM mock_data m
LEFT JOIN dim_category cat ON cat.name=m.product_category
LEFT JOIN dim_brand    br  ON br.name = m.product_brand
LEFT JOIN dim_color    col ON col.color= m.product_color
LEFT JOIN dim_material mat ON mat.material= m.product_material
LEFT JOIN dim_size     sz  ON sz.size= m.product_size
LEFT JOIN dim_weight   w   ON w.weight= m.product_weight
LEFT JOIN dim_date     dr  ON dr.date_key = m.product_release_date
LEFT JOIN dim_date     de  ON de.date_key = m.product_expiry_date
ON CONFLICT DO NOTHING;

-- 19. dim_seller
INSERT INTO dim_seller(first_name, last_name, email, country_id)
SELECT DISTINCT
    m.seller_first_name,
    m.seller_last_name,
    m.seller_email,
    co.id
FROM mock_data m
LEFT JOIN dim_country co ON co.name = m.seller_country
ON CONFLICT DO NOTHING;

-- 20. dim_store
INSERT INTO dim_store(name, location_id, state, phone, email, city_id, country_id)
SELECT DISTINCT
    m.store_name,
    loc.id,
    m.store_state,
    m.store_phone,
    m.store_email,
    ci.id,
    co.id
FROM mock_data m
LEFT JOIN dim_city     ci ON ci.name    = m.store_city
LEFT JOIN dim_country  co ON co.name    = m.store_country
LEFT JOIN dim_location loc ON loc.location = m.store_location
ON CONFLICT DO NOTHING;

-- 21. dim_supplier
INSERT INTO dim_supplier(name, contact, email, phone, address, city_id, country_id)
SELECT DISTINCT
    m.supplier_name,
    m.supplier_contact,
    m.supplier_email,
    m.supplier_phone,
    m.supplier_address,
    ci.id,
    co.id
FROM mock_data m
LEFT JOIN dim_city    ci ON ci.name    = m.supplier_city
LEFT JOIN dim_country co ON co.name    = m.supplier_country
ON CONFLICT DO NOTHING;

-- 22. fact_sales
INSERT INTO fact_sales(
    date_key, customer_id, seller_id, product_id,
    store_id, supplier_id, quantity, total_price
)
SELECT
    m.sale_date,
    cu.id,
    s.id,
    p.id,
    st.id,
    su.id,
    m.sale_quantity,
    m.sale_total_price
FROM mock_data m
LEFT JOIN dim_date     d  ON d.date_key = m.sale_date
LEFT JOIN dim_customer cu ON cu.email   = m.customer_email
LEFT JOIN dim_seller   s  ON s.email     = m.seller_email
LEFT JOIN dim_product  p  ON p.id        = m.sale_product_id
LEFT JOIN dim_store    st ON st.name     = m.store_name
LEFT JOIN dim_supplier su ON su.name     = m.supplier_name
ON CONFLICT DO NOTHING;

COMMIT;
