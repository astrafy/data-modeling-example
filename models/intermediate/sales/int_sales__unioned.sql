with

int_system1__sales_joined as (
    select * from {{ ref('int_system1__sales_joined') }}
)

, stg_system2__sales as (
    select * from {{ ref('stg_system2__sales') }}
)

, system1_prepared as (
    select
        cast(order_id as varchar)  as order_id
        , customer_id
        , order_date
        , amount
        , coalesce(referral_code, 'none') as referral_code
        , device_type
        , 'system1'                as source_system
    from int_system1__sales_joined
)

, system2_prepared as (
    select
        order_id
        , customer_id
        , order_date
        , amount
        , 'none'                   as referral_code
        , cast(null as varchar)    as device_type
        , 'system2'                as source_system
    from stg_system2__sales
)

, unioned as (
    select * from system1_prepared
    union all
    select * from system2_prepared
)

select * from unioned
