select
    activity_se_id,
    activity_date,
    use_case_id
from {{ source('se_reporting', 'dim_se_activity') }}
