with

stg_system1__order_items as (
    select * from {{ ref('stg_system1__order_items') }}
)

, stg_system1__sales as (
    select * from {{ ref('stg_system1__sales') }}
)

, dim_products as (
    select * from {{ ref('dim_products') }}
)

, final as (
    select
        stg_system1__order_items.order_item_id
        , stg_system1__order_items.order_id
        , stg_system1__sales.customer_id
        , stg_system1__order_items.product_id
        , dim_products.product_name
        , dim_products.category
        , stg_system1__order_items.quantity
        , stg_system1__order_items.line_total
        , stg_system1__sales.order_date
    from stg_system1__order_items
    inner join stg_system1__sales
        on stg_system1__order_items.order_id = stg_system1__sales.order_id
    inner join dim_products
        on stg_system1__order_items.product_id = dim_products.product_id
)

select * from final
