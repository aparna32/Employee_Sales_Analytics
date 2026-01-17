USE employee_sales_analytics;

-- =========================================================
-- 04_department_performance.sql
-- Business Question:
--   How is each department performing in terms of headcount, payroll, and sales?
--   What % of total company sales does each department contribute?
--
-- Why this matters:
--   This is the exec-style snapshot: size, cost, output, efficiency.
-- =========================================================

WITH emp_sales AS (
  -- Employee-level sales (keep employees with zero sales)
  SELECT
    e.emp_id,
    e.dept_id,
    COALESCE(SUM(o.amount), 0) AS total_sales
  FROM employees e
  LEFT JOIN orders o
    ON e.emp_id = o.emp_id
  GROUP BY e.emp_id, e.dept_id
),
dept_metrics AS (
  -- Department-level aggregation
  SELECT
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS headcount,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    SUM(e.salary) AS total_payroll,
    SUM(es.total_sales) AS dept_total_sales
  FROM departments d
  JOIN employees e
    ON e.dept_id = d.dept_id
  JOIN emp_sales es
    ON es.emp_id = e.emp_id
  GROUP BY d.dept_id, d.dept_name
)
SELECT
  dept_id,
  dept_name,
  headcount,
  avg_salary,
  total_payroll,
  dept_total_sales,
  ROUND(dept_total_sales / NULLIF(SUM(dept_total_sales) OVER (), 0) * 100, 2) AS pct_company_sales,
  ROUND(dept_total_sales / NULLIF(headcount, 0), 2) AS sales_per_employee
FROM dept_metrics
ORDER BY dept_total_sales DESC, headcount DESC, dept_name ASC;
