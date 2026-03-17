with

fct_sales as (
    select * from {{ ref('fct_sales') }}
)

, dim_customers as (
    select * from {{ ref('dim_customers') }}
)

, sales_with_cohort as (
    select
        dim_customers.signup_month                      as cohort_month
        , date_trunc('month', fct_sales.order_date)    as order_month
        , fct_sales.customer_id
        , fct_sales.amount
    from fct_sales
    inner join dim_customers
        on fct_sales.customer_id = dim_customers.customer_id
)

, final as (
    select
        cohort_month
        , order_month
        , count(distinct customer_id)  as active_customers
        , count(*)                     as total_orders
        , sum(amount)                  as total_revenue
    from sales_with_cohort
    group by all
    order by cohort_month, order_month
)

select * from final
