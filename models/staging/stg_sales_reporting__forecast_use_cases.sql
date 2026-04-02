select
    use_case_id,
    forecast_type,
    use_case_forecast_type,
    submitted_date
from {{ source('sales_reporting', 'core_sales_forecast_use_cases_call') }}
where forecast_type in ('Most Likely', 'Commit')
