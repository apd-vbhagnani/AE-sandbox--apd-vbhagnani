{{ config(
    materialized="table", 
    tags=["vidya.bhagnani@aimpointdigital.com"]
) }}

    /*

        This model contains Stripe Customers data created using our fake data generator in AWS.

    */

with
    data_to_keep as (
        select *
        from {{ source("VIDYABHAGNANI","FIVETRAN_STRIPE") }}

        where _file ilike '%stripe/customers/customers%'
    )

select
    _data:id::string as id,
    _data:name::string as name,
    _data:email::string as email,
    _data:balance::string as balance,
    _data:delinquent::boolean as delinquent,
    
    
    _data:next_invoice_sequence::string as next_invoice_sequence,
    _data:object::string as object,
    _data:tax_exempt::string as tax_exempt,
    _data:created::timestamp as created,
    _data:updated::timestamp as updated,
    _data,

    _fivetran_synced as loaded_at_date, 

from data_to_keep

-- We keep the latest version of a customer in case it is loaded multiple times.
qualify row_number() over (partition by id order by loaded_at_date desc) = 1