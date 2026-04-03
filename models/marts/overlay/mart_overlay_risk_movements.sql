-- Current-state risk movements only (DBT_VALID_TO IS NULL = active snapshot row)
select
    ACCOUNT_ID,
    CONSUMPTION_RISK_C,
    ACCOUNT_COMMENTS_C,
    ACCOUNT_STRATEGY_C,
    CONSUMPTION_RISK_MITIGATION_STEPS_C,
    SALES_ENGINEER,
    DBT_VALID_FROM

from {{ source('sales_engineering', 'consumption_risk_movements') }}
where DBT_VALID_TO is null
