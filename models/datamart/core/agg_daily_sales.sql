with

fct_sales as (
    select * from {{ ref('fct_sales') }}
)

, final as (
    select
        order_date
        , source_system
        , count(*)        as order_count
        , sum(amount)     as total_revenue
        , avg(amount)     as avg_order_value
    from fct_sales
    group by all
)

select * from final
