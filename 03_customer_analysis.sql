-- 1. Orders per Customer
SELECT
c.customer_unique_id,
COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id;

-- 2. Distribution of Orders
SELECT
total_orders,
COUNT(*) AS customer_count
FROM (
SELECT
c.customer_unique_id,
COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
) t
GROUP BY total_orders
ORDER BY total_orders;

-- 3. Repeat Customers
SELECT
COUNT(*) AS repeat_customers
FROM (
SELECT
c.customer_unique_id,
COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 1
) t;

-- 4. Total Customers
SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;

-- 5. Repeat Rate
WITH customer_orders AS (
SELECT
c.customer_unique_id,
COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
)
SELECT
COUNT() FILTER (WHERE total_orders > 1) * 1.0 / COUNT() AS repeat_rate
FROM customer_orders;

-- 6. Total Spend per Customer
SELECT
c.customer_unique_id,
SUM(p.payment_value) AS total_spent
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN payments p
ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC;

-- 7. Top Customers
SELECT
c.customer_unique_id,
SUM(p.payment_value) AS total_spent
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN payments p
ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;
