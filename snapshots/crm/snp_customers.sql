{% snapshot snp_customers %}

{{
    config(
        target_schema='snapshots'
        , unique_key='customer_id'
        , strategy='check'
        , check_cols=['customer_name']
    )
}}

select
    cast(id as integer)         as customer_id
    , cast(name as varchar)     as customer_name
    , cast(signup_date as date) as signup_date
from {{ ref('seed_crm__customers') }}

{% endsnapshot %}
