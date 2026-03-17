with

source as (
    select * from {{ ref('seed_system1__sales_info') }}
)

, renamed as (
    select
        cast(id as integer)                as order_id
        , cast(referral_code as varchar)   as referral_code
        , cast(device_type as varchar)     as device_type
    from source
)

select * from renamed
