-- Distinct account → product_category mapping (recent 3 months of actuals)
select distinct
    SALESFORCE_ACCOUNT_ID as ACCOUNT_ID,
    PRODUCT_CATEGORY

from {{ source('finance_customer', 'product_category_rev_actuals_w_forecast_sfdc') }}
where ACTUALS_FORECAST_TYPE = 'Actual'
  and USAGE_DATE >= dateadd(month, -3, current_date())
  and REVENUE > 0
