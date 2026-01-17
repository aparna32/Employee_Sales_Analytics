USE employee_sales_analytics;

-- =========================================================
-- 06_time_trends.sql
-- Business Question:
--   How are sales trending over time (monthly)?
--   What is the Month-over-Month (MoM) change and a rolling 3-month average?
--
-- Why this matters:
--   Trend + MoM + rolling averages are core analytics patterns.
-- =========================================================

WITH monthly_sales AS (
  SELECT
    DATE_FORMAT(o.order_date, '%Y-%m-01') AS month_start,
    SUM(o.amount) AS month_sales
  FROM orders o
  GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
),
with_mom AS (
  SELECT
    month_start,
    month_sales,
    LAG(month_sales) OVER (ORDER BY month_start) AS prev_month_sales
  FROM monthly_sales
)
SELECT
  month_start,
  month_sales,
  prev_month_sales,
  ROUND(month_sales - prev_month_sales, 2) AS mom_change,
  ROUND((month_sales - prev_month_sales) / NULLIF(prev_month_sales, 0) * 100, 2) AS mom_change_pct,
  ROUND(AVG(month_sales) OVER (ORDER BY month_start ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS rolling_3m_avg
FROM with_mom
ORDER BY month_start ASC;
