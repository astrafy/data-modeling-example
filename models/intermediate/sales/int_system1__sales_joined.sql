with

stg_system1__sales as (
    select * from {{ ref('stg_system1__sales') }}
)

, stg_system1__sales_info as (
    select * from {{ ref('stg_system1__sales_info') }}
)

, joined as (
    select
        stg_system1__sales.order_id
        , stg_system1__sales.customer_id
        , stg_system1__sales.order_date
        , stg_system1__sales.amount
        , stg_system1__sales_info.referral_code
        , stg_system1__sales_info.device_type
    from stg_system1__sales
    left join stg_system1__sales_info
        on stg_system1__sales.order_id = stg_system1__sales_info.order_id
)

select * from joined
