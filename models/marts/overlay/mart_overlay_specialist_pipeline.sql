-- Per-specialist use case assignments for stages 1–7.
-- Filtered to active use cases via INNER JOIN with core_use_case.
select
    o.USE_CASE_ID,
    o.SPECIALIST_NAME,
    o.SPECIALIST_ROLE,
    o.SPECIALIST_MANAGER_NAME,
    o.SPECIALIST_INVOLVEMENT,
    o.IS_TEAM_MEMBER,
    o.VALIDATION_TASK_STATUS,
    o.NEXT_STEPS as SPECIALIST_COMMENTS

from {{ source('sales_reporting', 'overlay_use_case_pipeline') }} o
inner join {{ source('sales_reporting', 'core_use_case') }} c
    on o.USE_CASE_ID = c.USE_CASE_ID
where c.USE_CASE_STAGE in (
    '1 - Discovery',
    '2 - Scoping',
    '3 - Technical / Business Validation',
    '4 - Use Case Won / Migration Plan',
    '5 - Implementation In Progress',
    '6 - Implementation Complete',
    '7 - Deployed'
)
