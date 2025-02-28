{{ config(
    materialized="table", 
    tags=["vidya.bhagnani@aimpointdigital.com"],
    schema=add_model_to_schema_based_on_name('hub_stripe_refunds')  
   
) }}

-- Hub for Stripe Refunds
-- This table stores the business key (ID) for refunds.

with
    data_to_keep as (
        select *
        from {{ source("VIDYABHAGNANI", "FIVETRAN_STRIPE") }}
        where _file ilike '%stripe/refunds/refunds%'
    )

select 
    _data:id::string as refund_id, -- Hub's business key
    current_timestamp() as load_timestamp, -- Capture load time
    _fivetran_synced as record_source -- Source of the data
from data_to_keep

-- Keep only the latest version of the refund.
qualify row_number() over (partition by _data:id order by _fivetran_synced desc) = 1
