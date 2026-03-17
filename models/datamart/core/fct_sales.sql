{{
    config(
        materialized='incremental'
        , unique_key='sales_key'
        , incremental_strategy='delete+insert'
    )
}}

with

int_sales__unioned as (
    select * from {{ ref('int_sales__unioned') }}
)

, final as (
    select
        {{ dbt_utils.generate_surrogate_key(['order_id', 'source_system']) }} as sales_key
        , order_id
        , customer_id
        , order_date
        , amount
        , referral_code
        , device_type
        , source_system
    from int_sales__unioned

    {% if is_incremental() %}
        where order_date >= (select max(order_date) from {{ this }})
    {% endif %}
)

select * from final
