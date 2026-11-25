{{config(materialized = 'view')}}

with source as (
    SELECT * FROM {{ ref('stg_orders') }}
)

SELECT oder_id,
       customer_id, 
       status 
FROM source
