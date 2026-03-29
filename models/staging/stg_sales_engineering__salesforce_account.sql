select
    salesforce_account_id,
    salesforce_account_name,
    growth_acv,
    overage_underage,
    total_number_of_warehouse,
    consumption_acv,
    total_consumption_by_warehouse,
    total_number_of_usecase,
    total_number_of_snowflake_account,
    total_number_of_role,
    total_consumption_by_role
from {{ source('sales_engineering', 'salesforce_account') }}
