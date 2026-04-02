select
    use_case_eacv,
    use_case_id,
    use_case_name,
    account_name,
    account_gvp
from {{ ref('stg_mdm__dim_use_case') }}
where created_date > '2025-01-01'
