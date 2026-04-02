select
    use_case_id,
    use_case_name,
    use_case_eacv,
    stage_number,
    decision_date,
    go_live_date,
    theater_name,
    region_name,
    sub_region_name,
    district_name,
    account_id,
    account_name,
    account_gvp,
    created_date,
    product_category_array
from {{ source('mdm', 'dim_use_case') }}
