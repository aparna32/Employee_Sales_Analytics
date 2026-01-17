USE employee_sales_analytics;

-- =========================================================
-- 07_advanced_insights.sql
-- Business Questions:
--   A) Who are "high value" employees (top sales) relative to salary?
--   B) Which orders are unusually large (possible anomalies)?
--   C) Which employees have zero sales (data / performance gap)?
--
-- Why this matters:
--   This looks like real business analytics: efficiency + anomaly detection.
-- =========================================================

-- ---------------------------------------------------------
-- A) Employee efficiency buckets (sales vs salary)
-- ---------------------------------------------------------
WITH emp_sales AS (
  SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name,
    e.salary,
    COALESCE(SUM(o.amount), 0) AS total_sales
  FROM employees e
  JOIN departments d ON d.dept_id = e.dept_id
  LEFT JOIN orders o ON o.emp_id = e.emp_id
  GROUP BY e.emp_id, e.emp_name, d.dept_name, e.salary
),
scored AS (
  SELECT
    emp_id,
    emp_name,
    dept_name,
    salary,
    total_sales,
    ROUND(total_sales / NULLIF(salary, 0), 4) AS sales_to_salary_ratio,

    -- quartiles by total_sales (relative performance buckets)
    NTILE(4) OVER (ORDER BY total_sales DESC) AS sales_quartile
  FROM emp_sales
)
SELECT
  emp_id,
  emp_name,
  dept_name,
  salary,
  total_sales,
  sales_to_salary_ratio,
  sales_quartile,
  CASE
    WHEN sales_quartile = 1 AND sales_to_salary_ratio >= 0.08 THEN 'Star Performer'
    WHEN sales_quartile = 1 THEN 'High Sales'
    WHEN sales_quartile = 4 AND sales_to_salary_ratio < 0.03 THEN 'Low ROI / Watch'
    ELSE 'Normal'
  END AS performance_bucket
FROM scored
ORDER BY sales_quartile ASC, sales_to_salary_ratio DESC, total_sales DESC;


-- ---------------------------------------------------------
-- B) Order anomaly detection (top 5% by amount)
--     Uses percentile-like logic via NTILE(20): top tile ~= top 5%
-- ---------------------------------------------------------
WITH ranked_orders AS (
  SELECT
    o.order_id,
    o.emp_id,
    o.order_date,
    o.amount,
    NTILE(20) OVER (ORDER BY o.amount) AS amount_tile
  FROM orders o
)
SELECT
  order_id,
  emp_id,
  order_date,
  amount
FROM ranked_orders
WHERE amount_tile = 20
ORDER BY amount DESC, order_date ASC;


-- ---------------------------------------------------------
-- C) Employees with zero sales (gap analysis)
-- ---------------------------------------------------------
SELECT
  e.emp_id,
  e.emp_name,
  d.dept_name
FROM employees e
JOIN departments d ON d.dept_id = e.dept_id
LEFT JOIN orders o ON o.emp_id = e.emp_id
GROUP BY e.emp_id, e.emp_name, d.dept_name
HAVING COALESCE(SUM(o.amount), 0) = 0
ORDER BY d.dept_name, e.emp_name;
