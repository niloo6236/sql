-- =====================================================
-- RETAIL DATA MODEL (MIAMI PROJECT)
-- Author: Niloofar
-- Purpose: Create unified view combining sales, survey, and weather data
-- =====================================================

-- Create or replace analytical view
CREATE OR REPLACE VIEW retail.table_joined AS

SELECT 
    s.date,
    
    -- Day of week extraction
    DAYNAME(s.date) AS day_of_week,

    -- Weekend vs weekday classification
    CASE 
        WHEN WEEKDAY(s.date) IN (5,6) THEN 'weekend'
        ELSE 'weekday'
    END AS is_weekend,

    -- Sales data
    s.shop_id,
    s.shop_name,
    s.customers,
    s.sales_usd,

    -- Revenue per customer (key KPI)
    s.sales_usd / s.customers AS sales_per_customer,

    -- Customer demographics
    su.pct_male,
    su.pct_female,
    su.pct_family,
    su.pct_single,

    -- Weather conditions
    w.avg_temp_f,
    w.precip_in,
    w.is_rain,
    w.humidity_pct

FROM retail.sales s

-- Join customer survey data
LEFT JOIN retail.survey su 
    USING (date)

-- Join weather data
LEFT JOIN retail.weather w 
    USING (date);
