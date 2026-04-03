-- Per-account feature revenue share (last 3 months of actuals).
-- CREDIT_SHARE = feature revenue / account total revenue, so values sum to ~1 per account.
select
    SALESFORCE_ACCOUNT_ID as ACCOUNT_ID,
    PRODUCT_CATEGORY,
    FEATURE,
    sum(REVENUE) / nullif(
        sum(sum(REVENUE)) over (partition by SALESFORCE_ACCOUNT_ID), 0
    ) as CREDIT_SHARE

from {{ source('finance_customer', 'product_category_rev_actuals_w_forecast_sfdc') }}
where ACTUALS_FORECAST_TYPE = 'Actual'
  and USAGE_DATE >= dateadd(month, -3, current_date())
  and FEATURE is not null
  and REVENUE > 0
group by 1, 2, 3
