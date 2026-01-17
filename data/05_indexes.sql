USE employee_sales_analytics;

-- Purpose: speed up joins and time-based analysis
CREATE INDEX idx_employees_dept   ON employees(dept_id);
CREATE INDEX idx_employees_mgr    ON employees(manager_id);
CREATE INDEX idx_orders_emp       ON orders(emp_id);
CREATE INDEX idx_orders_date      ON orders(order_date);
CREATE INDEX idx_orders_emp_date  ON orders(emp_id, order_date);
