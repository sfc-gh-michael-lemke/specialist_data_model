-- Full forecast pipeline: core use cases (stages 1–7) enriched with pipeline health,
-- overlay metadata, text sentiment, and specialist coverage flags.
select
    c.USE_CASE_ID,
    c.USE_CASE_NAME,
    c.ACCOUNT_NAME,
    c.ACCOUNT_ID,
    c.USE_CASE_STAGE,
    cast(left(c.USE_CASE_STAGE, 1) as int) as STAGE_NUMBER,
    c.USE_CASE_STATUS,
    c.USE_CASE_ACV                          as USE_CASE_EACV,
    m.PRODUCT_CATEGORY,
    coalesce(m.TECHNICAL_USE_CASE, c.WORKLOADS)             as TECHNICAL_USE_CASE,
    coalesce(m.PRIORITIZED_FEATURES, c.PRIORITIZED_FEATURE) as PRIORITIZED_FEATURES,
    c.DECISION_DATE,
    c.GO_LIVE_DATE,
    c.TECHNICAL_WIN_DATE,
    c.THEATER                               as THEATER_NAME,
    c.REGION                                as REGION_NAME,
    c.RVP,
    c.GVP,
    c.USE_CASE_RISK_LEVEL,
    m.PRODUCT_SPECIALISTS_INVOLVED,
    m.PRODUCT_SPECIALIST_MANAGERS_INVOLVED,
    c.NEXT_STEPS                            as SE_COMMENTS,
    p.HEALTH_SCORE,
    p.HEALTH_STATUS,
    p.GO_LIVE_PROBABILITY,
    coalesce(p.EXPECTED_VALUE, c.USE_CASE_ACV) as EXPECTED_VALUE,
    coalesce(p.GO_LIVE_FQ, 'FY' || c.GO_LIVE_FQ_SK) as GO_LIVE_FQ,
    p.IS_CURRENT_FQ_GO_LIVE,
    p.PROBABILITY_TIER,
    p.FORECAST_SOURCE,
    coalesce(p.IS_TECH_WON,
        case when cast(left(c.USE_CASE_STAGE, 1) as int) >= 7
             then true else null end
    ) as IS_TECH_WON,
    p.HAS_SPECIALIST_COVERAGE,
    p.SPECIALIST_COUNT,
    coalesce(p.USE_CASE_LEAD_SE_NAME, c.USE_CASE_LEAD_SE_NAME) as USE_CASE_LEAD_SE_NAME,
    p.ACCOUNT_SE_MANAGER,
    coalesce(p.REP_NAME, c.OWNER_NAME) as REP_NAME,
    coalesce(p.DM, c.DM)               as DM,
    t.SE_COMMENTS_PREVIEW,
    t.DAYS_SINCE_COMMENT_UPDATE,
    t.COMMENT_STALE_FLAG

from {{ source('sales_reporting', 'core_use_case') }} c
left join {{ source('sales_reporting', 'active_use_case_pipeline') }} p
    on c.USE_CASE_ID = p.USE_CASE_ID
left join {{ source('sales_reporting', 'overlay_use_case_master') }} m
    on c.USE_CASE_ID = m.USE_CASE_ID
left join {{ source('sales_reporting', 'fct_use_case_text_sentiment') }} t
    on c.USE_CASE_ID = t.USE_CASE_ID
where c.USE_CASE_STAGE in (
    '1 - Discovery',
    '2 - Scoping',
    '3 - Technical / Business Validation',
    '4 - Use Case Won / Migration Plan',
    '5 - Implementation In Progress',
    '6 - Implementation Complete',
    '7 - Deployed'
)
