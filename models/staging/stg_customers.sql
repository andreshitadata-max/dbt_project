{{
    config(
        materialized='table'
    )
}}

with cte as (
    select * from {{ source('raw', 'customers') }}

)

SELECT customer_id,
       city,
       country,
       created_at,
       first_name,
       last_name,
       email,
       phone 
FROM cte