
---

## How to Run (Execution Order)

Run the scripts in the following order using MySQL Workbench:

1. `schema/01_create_database.sql`
2. `schema/02_create_tables.sql`
3. `data/03_insert_seed_data.sql`
4. `data/04_data_quality_checks.sql`
5. `data/05_indexes.sql`
6. Run analysis queries in order:
   - `analysis/01_employee_directory.sql`
   - `analysis/02_employee_sales.sql`
   - `analysis/03_manager_hierarchy.sql`
   - `analysis/04_department_performance.sql`
   - `analysis/05_rankings.sql`
   - `analysis/06_time_trends.sql`
   - `analysis/07_advanced_insights.sql`

Each analysis file answers **one clear business question**.

---

## Data Volume
- Departments: 6  
- Employees: ~50  
- Orders: ~200  

The dataset is intentionally sized to be **realistic yet easy to reason about** for analytical queries.

---

## Data Quality Checks Implemented

Before analysis, the dataset is validated using a dedicated quality-check script to ensure integrity and realistic ranges:

- **Row count verification** across all tables to confirm expected data volumes.
- **Foreign key orphan detection** to ensure all employees map to valid departments and all orders map to valid employees.
- **NULL checks** on mandatory fields (employee name, salary, hire date, order amount).
- **Primary key duplicate detection** for `emp_id` and `order_id`.
- **Value range sanity checks**, including minimum and maximum salary and order amount validation.

These checks help ensure that analytical results are based on clean, trustworthy data.

---

## Index Rationale

To support efficient analytical queries and realistic performance considerations, the following indexes are created:

- **`employees(dept_id)`**  
  Optimizes joins and aggregations at the department level.

- **`employees(manager_id)`**  
  Improves performance of self-joins for manager–reportee hierarchy analysis.

- **`orders(emp_id)`**  
  Speeds up employee-level sales aggregation and joins.

- **`orders(order_date)`**  
  Optimizes time-based trend analysis and monthly aggregations.

- **`orders(emp_id, order_date)`**  
  Supports combined employee + time-based queries such as rolling trends.

Indexes are intentionally limited to analytical access patterns rather than transactional workloads.

---

## Analysis Covered

The analysis layer answers the following business questions:

- Employee directory with department and manager mapping  
- Total sales, order counts, and average order value per employee (including zero-sales cases)  
- Organizational hierarchy and manager reportee counts  
- Department-level headcount, payroll, total sales, and contribution %  
- Employee rankings (overall and within department) using window functions  
- Monthly sales trends with MoM change and rolling 3-month averages  
- Advanced insights:
  - Sales vs salary efficiency buckets
  - High-value / low-ROI employee identification
  - Top 5% order anomaly detection
  - Employees with zero sales (gap analysis)

---

## License
This project is licensed under the **MIT License**.  
It is intended for learning, demonstration, and portfolio use.
