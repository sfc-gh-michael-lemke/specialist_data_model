select
    activity_se_id,
    activity_id,
    activity_date,
    account_id,
    use_case_id,
    source
from {{ source('se_reporting', 'dim_se_activity') }}
