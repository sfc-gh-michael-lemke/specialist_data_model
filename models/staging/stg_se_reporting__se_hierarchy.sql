select
    preferred_name,
    manager_name,
    is_people_manager,
    original_hire_date,
    tenure,
    hierarchy_3,
    hierarchy_4,
    hierarchy_5,
    sfdc_id,
    active_status_latest
from {{ source('se_reporting', 'se_hierarchy') }}
