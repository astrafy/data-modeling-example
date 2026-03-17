with

source as (
    select * from {{ ref('seed_system1__sales') }}
)

, renamed as (
    select
        cast(id as integer)        as order_id
        , cast(cust_id as integer) as customer_id
        , cast(dt as date)         as order_date
        , cast(amt as numeric)     as amount
    from source
)

select * from renamed
