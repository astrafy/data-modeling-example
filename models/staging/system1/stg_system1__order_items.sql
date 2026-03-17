with

source as (
    select * from {{ ref('seed_system1__order_items') }}
)

, renamed as (
    select
        cast(id as integer)           as order_item_id
        , cast(order_id as integer)   as order_id
        , cast(product_id as integer) as product_id
        , cast(quantity as integer)   as quantity
        , cast(line_total as numeric) as line_total
    from source
)

select * from renamed
