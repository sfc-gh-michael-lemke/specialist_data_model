-- Monthly consumption by product category per account — last 6 months of actuals.
-- Refreshed each time dbt runs — run daily/weekly to keep the rolling window current.
select
    date_trunc('month', USAGE_DATE)     as CONSUMPTION_MONTH,
    PRODUCT_CATEGORY,
    SALESFORCE_ACCOUNT_ID               as ACCOUNT_ID,
    sum(REVENUE)                        as MONTHLY_REVENUE

from {{ source('finance_customer', 'product_category_rev_actuals_w_forecast_sfdc') }}
where ACTUALS_FORECAST_TYPE = 'Actual'
  and USAGE_DATE >= dateadd(month, -6, current_date())
group by 1, 2, 3
