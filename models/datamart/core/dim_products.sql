with

stg_system1__products as (
    select * from {{ ref('stg_system1__products') }}
)

, final as (
    select
        product_id
        , product_name
        , category
        , unit_price
    from stg_system1__products
)

select * from final
