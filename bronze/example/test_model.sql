select *
from {{ source('VIDYABHAGNANI', 'FIVETRAN_STRIPE') }}