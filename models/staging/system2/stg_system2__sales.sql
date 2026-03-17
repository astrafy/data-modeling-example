with

source as (
    select * from {{ ref('seed_system2__sales') }}
)

, renamed as (
    select
        cast(order_id as varchar)      as order_id
        , cast(client_ref as integer)  as customer_id
        , cast(sale_date as date)      as order_date
        , cast(total as numeric)       as amount
    from source
)

select * from renamed
