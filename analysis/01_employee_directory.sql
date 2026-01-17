USE employee_sales_analytics;

-- =========================================================
-- 01_employee_directory.sql
-- Business Question:
--   What does the employee directory look like with department and manager info?
--
-- Why this matters:
--   This is the base “master list” used in reporting and joins.
-- =========================================================

SELECT
  e.emp_id,
  e.emp_name,
  d.dept_name,
  e.salary,
  e.hire_date,
  COALESCE(m.emp_name, 'Top-level') AS manager_name
FROM employees e
JOIN departments d
  ON e.dept_id = d.dept_id
LEFT JOIN employees m
  ON e.manager_id = m.emp_id
ORDER BY d.dept_name ASC, e.emp_name ASC;
