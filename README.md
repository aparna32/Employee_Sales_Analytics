# Employee Sales Analytics (SQL)

## Overview
This project is a MySQL-based analytics dataset and query suite that demonstrates:
- Relational modeling with PK/FK constraints
- Joins (inner, left, self, cross)
- Aggregations (GROUP BY / HAVING)
- CTEs (WITH)
- Window functions (RANK, NTILE, LAG, rolling averages)
- Time-based trend analysis
- Performance insights and anomaly detection

## Schema
Tables:
- `departments(dept_id, dept_name)`
- `employees(emp_id, emp_name, dept_id, salary, manager_id, hire_date)`
- `orders(order_id, emp_id, order_date, amount)`

Relationships:
- employees → departments (FK)
- orders → employees (FK)
- employees → employees (manager hierarchy)

## How to Run (in order)
1. `schema/01_create_database.sql`
2. `schema/02_create_tables.sql`
3. `data/03_insert_seed_data.sql`
4. `data/04_data_quality_checks.sql`
5. `data/05_indexes.sql`
6. Run any file under `analysis/` in order:
   - `01_employee_directory.sql`
   - `02_employee_sales.sql`
   - `03_manager_hierarchy.sql`
   - `04_department_performance.sql`
   - `05_rankings.sql`
   - `06_time_trends.sql`
   - `07_advanced_insights.sql`

## Analysis Questions Covered
- Employee directory with department + manager mapping
- Total sales per employee (including zero-sales employees)
- Org hierarchy & reportee counts per manager
- Department headcount, payroll, sales contribution %, sales/employee
- Employee rankings (overall + within department) and sales-to-salary ratio
- Monthly sales trend, MoM change, rolling 3-month average
- Efficiency buckets, top-5% order anomaly detection, zero-sales gap list
