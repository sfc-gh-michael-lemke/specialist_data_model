-- Daily account-level consumption for the current fiscal quarter.
-- Refreshed each time dbt runs — run daily to keep current.
select
    GENERAL_DATE,
    SALESFORCE_ACCOUNT_ID as ACCOUNT_ID,
    THEATER,
    REGION,
    TOTAL_REVENUE,
    RUNNING_ACTUAL_REVENUE,
    RUNNING_PREDICTED_REVENUE

from {{ source('sales_reporting', 'consumption_daily') }}
where GENERAL_DATE >= date_trunc('quarter', current_date())
  and GENERAL_DATE <= current_date()
