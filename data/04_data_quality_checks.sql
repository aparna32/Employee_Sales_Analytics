USE employee_sales_analytics;

-- 1) Row counts (quick health check)
SELECT 'departments' AS table_name, COUNT(*) AS rows_count FROM departments
UNION ALL
SELECT 'employees', COUNT(*) FROM employees
UNION ALL
SELECT 'orders', COUNT(*) FROM orders;

-- 2) FK integrity check: employees missing a department
SELECT e.*
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE e.dept_id IS NOT NULL AND d.dept_id IS NULL;

-- 3) FK integrity check: orders missing an employee
SELECT o.*
FROM orders o
LEFT JOIN employees e ON o.emp_id = e.emp_id
WHERE e.emp_id IS NULL;

-- 4) NULL checks (should be 0 for NOT NULL columns)
SELECT
  SUM(emp_name IS NULL)  AS null_emp_name,
  SUM(salary IS NULL)    AS null_salary,
  SUM(hire_date IS NULL) AS null_hire_date
FROM employees;

-- 5) Range checks (spot weird data)
SELECT MIN(salary) AS min_salary, MAX(salary) AS max_salary FROM employees;
SELECT MIN(amount) AS min_order,  MAX(amount) AS max_order  FROM orders;

-- 6) Duplicate PK checks (should return 0 rows)
SELECT emp_id, COUNT(*) c FROM employees GROUP BY emp_id HAVING COUNT(*) > 1;
SELECT order_id, COUNT(*) c FROM orders GROUP BY order_id HAVING COUNT(*) > 1;
