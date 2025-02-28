{{ config(
    materialized="table", 
    tags=["vidya.bhagnani@aimpointdigital.com"]
) }}

    /*

        This model contains Stripe refunds data created using our fake data generator in AWS.

    */

with
    data_to_keep as (
        select *
        from {{ source("VIDYABHAGNANI", "FIVETRAN_STRIPE") }}

        where _file ilike '%stripe/refunds/refunds%'
    )

select
    _data:id::string as id,
    _data:amount::number as amount,
    _data:balance_transaction::string as balance_transaction,
    _data:charge::string as charge,
    _data:created::timestamp as created,
    _data:currency::string as currency,
    _data:object::string as object,
    _data:payment_intent::string as payment_intent,
    _data:reason::string as reason,
    _data:receipt_number::string as receipt_number,
    _data:source_transfer_reversal::string as source_transfer_reversal,
    _data:status::string as status,
    _data:transfer_reversal::string as transfer_reversal,

    -- Destination Details
    _data:destination_details:card:reference::string as card_reference,
    _data:destination_details:card:reference_status::string as card_reference_status,
    _data:destination_details:card:reference_type::string as card_reference_type,
    _data:destination_details:card:type::string as card_type,
    _data:destination_details:type::string as type,


    _fivetran_synced as loaded_at_date, 

from data_to_keep

-- We keep the latest version of a refund in case it is loaded multiple times.
qualify row_number() over (partition by id order by loaded_at_date desc) = 1