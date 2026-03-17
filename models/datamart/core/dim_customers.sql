with

stg_crm__customers as (
    select * from {{ ref('stg_crm__customers') }}
)

, final as (
    select
        customer_id
        , customer_name
        , signup_date
        , date_trunc('month', signup_date) as signup_month
    from stg_crm__customers
)

select * from final
