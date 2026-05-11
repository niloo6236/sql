-- =====================================================
-- Customer Behavior Analysis Project
-- Author: Niloofar
-- Purpose: Analyze customer spending patterns and behavior
-- Tool: SQL
-- =====================================================

-- =====================================================
-- 1. CUSTOMER OVERVIEW & REVENUE ANALYSIS
-- =====================================================

-- Basic dataset check
SELECT * FROM customer;

-- Revenue analysis by gender
SELECT 
    gender, 
    SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY gender;

-- Customers with discount usage and above-average spending
SELECT 
    customer_id, 
    purchase_amount
FROM customer
WHERE discount_applied = 'Yes'
AND purchase_amount >= (SELECT AVG(purchase_amount) FROM customer);

-- Product rating analysis
SELECT 
    item_purchased,
    ROUND(AVG(review_rating), 2) AS average_product_rating
FROM customer
GROUP BY item_purchased
ORDER BY average_product_rating DESC;

-- Shipping type spending behavior
SELECT 
    shipping_type,
    ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount
FROM customer
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;

-- Subscription status impact on revenue
SELECT 
    subscription_status,
    COUNT(customer_id) AS total_customers,
    ROUND(AVG(purchase_amount), 2) AS avg_spend,
    ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue DESC;

-- Discount usage rate by product
SELECT 
    item_purchased,
    ROUND(
        100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) 
        / COUNT(*), 2
    ) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC;


-- =====================================================
-- 2. CUSTOMER SEGMENTATION
-- =====================================================

-- Customer segmentation (New / Returning / Loyal)
WITH customer_type AS (
    SELECT 
        customer_id,
        previous_purchases,
        CASE 
            WHEN previous_purchases = 1 THEN 'New'
            WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
            ELSE 'Loyal'
        END AS customer_segment
    FROM customer
)
SELECT 
    customer_segment,
    COUNT(*) AS number_of_customers
FROM customer_type
GROUP BY customer_segment;


-- =====================================================
-- 3. PRODUCT & CATEGORY INSIGHTS
-- =====================================================

-- Top 3 items per category
WITH item_counts AS (
    SELECT 
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY category 
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT 
    item_rank,
    category,
    item_purchased,
    total_orders
FROM item_counts
WHERE item_rank <= 3;


-- =====================================================
-- 4. CUSTOMER LOYALTY & BEHAVIOR
-- =====================================================

-- Repeat buyers by subscription status
SELECT 
    subscription_status,
    COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;

-- Revenue by age group
SELECT 
    age_group,
    SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;
