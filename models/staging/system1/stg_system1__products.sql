with

source as (
    select * from {{ ref('seed_system1__products') }}
)

, renamed as (
    select
        cast(id as integer)              as product_id
        , cast(product_name as varchar)  as product_name
        , cast(category as varchar)      as category
        , cast(unit_price as numeric)    as unit_price
    from source
)

select * from renamed
