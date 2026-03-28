select
    id,
    created_by_id,
    field,
    created_date
from {{ source('salesforce', 'vh_deliverable_history') }}
