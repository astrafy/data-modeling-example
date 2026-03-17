with

fct_sales as (
    select * from {{ ref('fct_sales') }}
)

, dim_customers as (
    select * from {{ ref('dim_customers') }}
)

, customer_aggregates as (
    select
        customer_id
        , count(*)            as total_orders
        , sum(amount)         as lifetime_revenue
        , avg(amount)         as avg_order_value
        , min(order_date)     as first_order_date
        , max(order_date)     as last_order_date
        , date_diff('day', min(order_date), max(order_date)) as days_as_customer
    from fct_sales
    group by all
)

, final as (
    select
        dim_customers.customer_id
        , dim_customers.customer_name
        , dim_customers.signup_date
        , dim_customers.signup_month
        , customer_aggregates.total_orders
        , customer_aggregates.lifetime_revenue
        , customer_aggregates.avg_order_value
        , customer_aggregates.first_order_date
        , customer_aggregates.last_order_date
        , customer_aggregates.days_as_customer
    from dim_customers
    left join customer_aggregates
        on dim_customers.customer_id = customer_aggregates.customer_id
)

select * from final
