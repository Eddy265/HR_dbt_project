{{config(
  materialized='table',
  schema='Finance'
)}}

WITH depts AS (
    SELECT 
        department_name,
        department_id
        FROM {{ref ("stg_departments")}}
),

salary as (
    SELECT 
        *
        FROM {{ref ("stg_salaries")}}
),

emp as (
    SELECT 
        *
    FROM {{ref ("stg_employees")}}
),

output as (
    SELECT 
    department_name,
    SUM(salary_amount) total_salary
    FROM depts d
    JOIN emp e on d.department_id = e.department_id
    JOIN salary s on e.employee_id = s.employee_id
    GROUP BY 1
    ORDER BY 2 DESC
)

select * from output