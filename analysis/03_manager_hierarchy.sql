USE employee_sales_analytics;

-- =========================================================
-- 03_manager_hierarchy.sql
-- Business Question:
--   Who reports to whom, and how many reportees does each manager have?
--
-- Why this matters:
--   Enables manager effectiveness analysis and org structure reporting.
-- =========================================================

SELECT
  COALESCE(m.emp_id, 0) AS manager_id,
  COALESCE(m.emp_name, 'Top-level / No manager') AS manager_name,
  COUNT(e.emp_id) AS reportee_count
FROM employees e
LEFT JOIN employees m
  ON e.manager_id = m.emp_id
GROUP BY COALESCE(m.emp_id, 0), COALESCE(m.emp_name, 'Top-level / No manager')
ORDER BY reportee_count DESC, manager_name ASC;
