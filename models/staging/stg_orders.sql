{{config(materialized = 'table')}}

SELECT o_id AS order_id,
    cust_id AS customer_id, 
    status 
FROM {{ source('raw', 'orders') }}

