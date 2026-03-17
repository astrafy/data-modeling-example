{{
    config(
        materialized='table'
    )
}}

with

date_spine as (
    {{
        dbt_utils.date_spine(
            datepart="day"
            , start_date="cast('2024-01-01' as date)"
            , end_date="cast('2024-12-31' as date)"
        )
    }}
)

, final as (
    select
        cast(date_day as date)                          as date_day
        , date_trunc('week', date_day)                 as week_start
        , date_trunc('month', date_day)                as month_start
        , date_trunc('quarter', date_day)              as quarter_start
        , date_trunc('year', date_day)                 as year_start
        , extract('year' from date_day)                as year_number
        , extract('month' from date_day)               as month_number
        , extract('quarter' from date_day)             as quarter_number
        , extract('dow' from date_day) in (0, 6)      as is_weekend
    from date_spine
)

select * from final
