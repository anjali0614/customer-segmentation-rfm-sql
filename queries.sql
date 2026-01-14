/* =====================================================
   Customer Segmentation using RFM Analysis (MySQL 8+)
   ===================================================== */

/* =====================================================
   1. Table Creation
   ===================================================== */

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_amount DECIMAL(10,2)
);

/* =====================================================
   2. Data Insertion (from cleaned source)
   ===================================================== */

INSERT INTO orders (order_id, customer_id, order_date, order_amount)
SELECT
    OrderID,
    CustomerID,
    PurchaseDate,
    TransactionAmount
FROM orders_raw
WHERE CustomerID IS NOT NULL
  AND TransactionAmount > 0;

/* =====================================================
   3. RFM Metric Calculation
   Analysis date = 2023-06-11
   ===================================================== */

WITH rfm_base AS (
    SELECT
        customer_id,
        DATEDIFF('2023-06-11', MAX(order_date)) AS recency,
        COUNT(order_id) AS frequency,
        SUM(order_amount) AS monetary
    FROM orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    recency,
    frequency,
    monetary
FROM rfm_base;

/* =====================================================
   4. RFM Scoring using NTILE
   ===================================================== */

WITH rfm_base AS (
    SELECT
        customer_id,
        DATEDIFF('2023-06-11', MAX(order_date)) AS recency,
        COUNT(order_id) AS frequency,
        SUM(order_amount) AS monetary
    FROM orders
    GROUP BY customer_id
),
rfm_scores AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,
        NTILE(4) OVER (ORDER BY recency ASC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency DESC) AS f_score,
        NTILE(4) OVER (ORDER BY monetary DESC) AS m_score
    FROM rfm_base
)
SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score
FROM rfm_scores;

/* =====================================================
   5. Customer Segmentation
   ===================================================== */

WITH rfm_base AS (
    SELECT
        customer_id,
        DATEDIFF('2023-06-11', MAX(order_date)) AS recency,
        COUNT(order_id) AS frequency,
        SUM(order_amount) AS monetary
    FROM orders
    GROUP BY customer_id
),
rfm_scores AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,
        NTILE(4) OVER (ORDER BY recency ASC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency DESC) AS f_score,
        NTILE(4) OVER (ORDER BY monetary DESC) AS m_score
    FROM rfm_base
)
SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    CASE
        WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Champions'
        WHEN f_score >= 3 AND r_score >= 2 THEN 'Loyal Customers'
        WHEN r_score >= 3 AND f_score = 1 THEN 'Potential Loyalists'
        WHEN r_score <= 2 AND f_score >= 2 THEN 'At Risk'
        ELSE 'Lost Customers'
    END AS customer_segment
FROM rfm_scores;

/* =====================================================
   6. Segment Distribution Summary
   ===================================================== */

WITH rfm_base AS (
    SELECT
        customer_id,
        DATEDIFF('2023-06-11', MAX(order_date)) AS recency,
        COUNT(order_id) AS frequency,
        SUM(order_amount) AS monetary
    FROM orders
    GROUP BY customer_id
),
rfm_scores AS (
    SELECT
        customer_id,
        NTILE(4) OVER (ORDER BY recency ASC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency DESC) AS f_score,
        NTILE(4) OVER (ORDER BY monetary DESC) AS m_score
    FROM rfm_base
),
segments AS (
    SELECT
        CASE
            WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Champions'
            WHEN f_score >= 3 AND r_score >= 2 THEN 'Loyal Customers'
            WHEN r_score >= 3 AND f_score = 1 THEN 'Potential Loyalists'
            WHEN r_score <= 2 AND f_score >= 2 THEN 'At Risk'
            ELSE 'Lost Customers'
        END AS customer_segment
    FROM rfm_scores
)
SELECT
    customer_segment,
    COUNT(*) AS customer_count
FROM segments
GROUP BY customer_segment
ORDER BY customer_count DESC;
