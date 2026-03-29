select
    use_case_id,
    use_case_name,
    use_case_description,
    new_stage,
    account_id,
    ds
from {{ source('sales_engineering', 'usecase') }}
