# Employee Dashboard (Power BI)

This repository contains a Power BI dashboard for employee data analysis, designed to help visualize workforce KPIs such as headcount, payroll costs, average salary, department breakdowns, and more.

![SQL Table Structure and Relationships](SQL_table_structure_and_relationship.jpg)

---

## 📊 Dashboard Features

- Total Employee Count
- Active vs. Terminated Employees
- Average Salary and Bonus
- Total Payroll Cost
- Headcount by Department
- Average Age of Employees
- Departmental KPIs

---

## ⚙️ Contents

- `Employee_dashboard.pbix` — Main Power BI file containing the interactive dashboard.
- `powerbi_measures.txt` — DAX Measures and Calculated Columns used in the report.
- `SQL_table_structure_and_relationship.jpg` — Image showing the SQL table structure and relationships used as data source.

---

## 🗄️ Data Model

The data model is based on a simple relational structure, typically including:

- Employees Table
  - employee_id (Primary Key)
  - first_name
  - last_name
  - date_of_birth
  - hire_date
  - department_id
  - salary
  - bonus
  - employment_status

- Departments Table
  - department_id (Primary Key)
  - department_name

✅ The relationships are designed for a star-schema approach in Power BI.

---

## 📌 Measures and Calculated Columns

Sample DAX measures included:

```DAX
Total Employees = COUNTROWS(employees)

Active Employees = CALCULATE(
    COUNTROWS(employees),
    employees[employment_status] = "Active"
)

Average Salary = AVERAGE(employees[salary])

Total Payroll = SUM(employees[salary])
