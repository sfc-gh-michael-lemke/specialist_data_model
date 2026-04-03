select
    p.ACCOUNT_ID,
    p.USE_CASE_ID,
    p.USE_CASE_NAME,
    p.USE_CASE_STAGE,
    p.USE_CASE_EACV,
    p.HEALTH_STATUS,
    p.WORKLOADS,
    p.RISK_FACTORS,
    p.DAYS_IN_STAGE,
    p.USE_CASE_LEAD_SE_NAME,
    c.INDUSTRY_USE_CASE,
    c.PRIORITIZED_FEATURE

from {{ source('sales_reporting', 'active_use_case_pipeline') }} p
left join {{ source('sales_reporting', 'core_use_case') }} c
    on p.USE_CASE_ID = c.USE_CASE_ID
