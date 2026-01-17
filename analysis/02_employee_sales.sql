USE employee_sales_analytics;

-- =========================================================
-- 02_employee_sales.sql
-- Business Question:
--   How much total sales has each employee generated (including zero sales)?
--
-- Why this matters:
--   Identifies top performers and employees with no activity.
-- =========================================================

SELECT
  e.emp_id,
  e.emp_name,
  d.dept_name,
  COALESCE(COUNT(o.order_id), 0) AS order_count,
  COALESCE(SUM(o.amount), 0) AS total_sales,
  COALESCE(ROUND(AVG(o.amount), 2), 0) AS avg_order_value
FROM employees e
JOIN departments d
  ON e.dept_id = d.dept_id
LEFT JOIN orders o
  ON e.emp_id = o.emp_id
GROUP BY e.emp_id, e.emp_name, d.dept_name
ORDER BY total_sales DESC, order_count DESC, e.emp_name ASC;
