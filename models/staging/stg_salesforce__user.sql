select
    id
from {{ source('salesforce', 'user') }}
