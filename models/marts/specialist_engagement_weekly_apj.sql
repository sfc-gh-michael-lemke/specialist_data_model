with org as (

    select * from {{ ref('stg_se_reporting__se_org_hierarchy_vw') }}
    where is_active = true

),

specialist_metadata as (

    select * from {{ ref('stg_sigma__dim_se_specialist_metadata') }}
    where specialist_group in ('AFE', 'Architect')

),

comments as (

    select * from {{ ref('int_specialist_comments') }}

),

activities as (

    select * from {{ ref('int_specialist_activities') }}

)

select
    o.employee_name,
    coalesce(c.specialist_comments_7d, 0) as specialist_comments_7d,
    coalesce(a.activities_7d, 0) as activities_7d,
    coalesce(a.activities_7d_setsail, 0) as activities_7d_setsail,
    coalesce(a.activities_7d_vivun, 0) as activities_7d_vivun,
    o.manager_name,
    o.third_line_manager,
    sm.specialist_group,
    sm.specialist_sub_group,
    sm.specialist_theater,
    sm.specialist_theater_market,
    o.is_manager

from org as o
inner join specialist_metadata as sm
    on o.employee_id = sm.employee_id
left join comments as c
    on o.se_id = c.sfdc_user_id
left join activities as a
    on o.se_id = a.sfdc_user_id
where sm.specialist_theater = 'APJ'
