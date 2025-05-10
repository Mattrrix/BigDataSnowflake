-- Сколько уникальных покупателей?
SELECT count(DISTINCT customer_email) AS uniq_customer_emails FROM mock_data;

-- Сколько уникальных продавцов?
SELECT count(DISTINCT seller_email)   AS uniq_seller_emails   FROM mock_data;

-- Товары (по product_name)
SELECT count(DISTINCT product_name)   AS uniq_products        FROM mock_data;

-- Магазины
SELECT count(DISTINCT store_name)     AS uniq_stores          FROM mock_data;

-- Поставщики
SELECT count(DISTINCT supplier_name)  AS uniq_suppliers       FROM mock_data;

-- Несколько случайных покупателей
SELECT customer_first_name, customer_last_name, customer_email, customer_country
FROM   mock_data
ORDER  BY random()
LIMIT  5;

-- Случайные товары
SELECT product_name, product_category, pet_category, product_brand, product_price
FROM   mock_data
ORDER  BY random()
LIMIT  5;

-- Даты продаж: мин/макс/кол-во дней
SELECT min(sale_date)  AS min_date,
       max(sale_date)  AS max_date,
       count(DISTINCT sale_date) AS days_covered
FROM   mock_data;

-- Дублирующиеся e-mail покупателей
SELECT customer_email, count(*) AS cnt
FROM   mock_data
GROUP  BY customer_email
HAVING count(*) > 1
LIMIT  10;

-- Дублирующиеся (product_name, brand)
SELECT product_name, product_brand, count(*)
FROM   mock_data
GROUP  BY product_name, product_brand
HAVING count(*) > 1
LIMIT  10;
-- Уникальные заказчики, товары и общее количество товаров
SELECT
  COUNT(*)                        AS total_rows,
  COUNT(DISTINCT customer_email)  AS distinct_customers,
  COUNT(DISTINCT sale_product_id) AS distinct_products

FROM mock_data;

-- Карта NULL-ов и число уникальных для каждого столбца-кандидата в измерения
SELECT
  column_name,
  COUNT(*) FILTER (WHERE col IS NULL)       AS null_count,
  COUNT(DISTINCT col)                       AS distinct_vals
FROM (
  SELECT customer_country AS col, 'customer_country' AS column_name FROM mock_data
  UNION ALL SELECT customer_pet_name,    'customer_pet_name'    FROM mock_data
  UNION ALL SELECT customer_pet_type,    'customer_pet_type'    FROM mock_data
  UNION ALL SELECT customer_pet_breed,   'customer_pet_breed'   FROM mock_data
  UNION ALL SELECT product_category,     'product_category'     FROM mock_data
  UNION ALL SELECT product_brand,        'product_brand'        FROM mock_data
  UNION ALL SELECT product_color,        'product_color'        FROM mock_data
  UNION ALL SELECT product_material,     'product_material'     FROM mock_data
  UNION ALL SELECT product_size,         'product_size'         FROM mock_data
  UNION ALL SELECT product_weight::TEXT, 'product_weight'       FROM mock_data
  UNION ALL SELECT store_city,           'store_city'           FROM mock_data
  UNION ALL SELECT supplier_country,     'supplier_country'     FROM mock_data
) t
GROUP BY column_name
ORDER BY null_count DESC;