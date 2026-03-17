with

source as (
    select * from {{ ref('seed_crm__customers') }}
)

, renamed as (
    select
        cast(id as integer)              as customer_id
        , cast(name as varchar)          as customer_name
        , cast(signup_date as date)      as signup_date
    from source
)

select * from renamed
