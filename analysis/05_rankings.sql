USE employee_sales_analytics;

-- =========================================================
-- 05_rankings.sql
-- Business Question:
--   Who are the top performers by sales overall and within each department?
--   Also, how does performance compare to salary (sales-to-salary ratio)?
--
-- Why this matters:
--   Rankings + efficiency metrics are common in real dashboards and interviews.
-- =========================================================

WITH emp_perf AS (
  SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name,
    e.salary,
    COALESCE(SUM(o.amount), 0) AS total_sales,
    COALESCE(COUNT(o.order_id), 0) AS order_count
  FROM employees e
  JOIN departments d
    ON e.dept_id = d.dept_id
  LEFT JOIN orders o
    ON e.emp_id = o.emp_id
  GROUP BY e.emp_id, e.emp_name, d.dept_name, e.salary
)
SELECT
  emp_id,
  emp_name,
  dept_name,
  salary,
  order_count,
  total_sales,
  ROUND(total_sales / NULLIF(salary, 0), 4) AS sales_to_salary_ratio,

  -- Rank employees overall by total sales
  RANK() OVER (ORDER BY total_sales DESC) AS overall_sales_rank,

  -- Rank employees within their department by total sales
  RANK() OVER (PARTITION BY dept_name ORDER BY total_sales DESC) AS dept_sales_rank
FROM emp_perf
ORDER BY overall_sales_rank ASC, dept_sales_rank ASC, emp_name ASC;
