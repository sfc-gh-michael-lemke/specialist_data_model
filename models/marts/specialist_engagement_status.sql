with hierarchy as (

    select * from {{ ref('stg_se_reporting__se_hierarchy') }}
    where active_status_latest = 1

),

specialist_metadata as (

    select * from {{ ref('stg_sigma__dim_se_specialist_metadata') }}
    where specialist_group in ('AFE', 'PSE', 'Architect')

),

comments as (

    select * from {{ ref('int_specialist_comments') }}

),

activities as (

    select * from {{ ref('int_specialist_activities') }}

),

excluded_names as (

    select column1 as preferred_name
    from (values
        ('Hartland Brown'),
        ('Brett Klein'),
        ('Arnab Bhattacharjee'),
        ('Maya Kamath'),
        ('Swadha Jain'),
        ('Prateek Anshul Srivastava'),
        ('Feba James'),
        ('Deepjyoti Dev'),
        ('Rahul Jain'),
        ('Shriya Rai'),
        ('Fred Meyler'),
        ('Emma de la Torre'),
        ('Danny Bryant'),
        ('Vanessa Valenzuela'),
        ('Betty Mesfin'),
        ('Marie Duran'),
        ('Tim Jones')
    )

)

select
    h.preferred_name,
    h.manager_name,
    h.is_people_manager,
    h.original_hire_date,
    h.tenure,
    h.hierarchy_3,
    h.hierarchy_4,
    h.hierarchy_5,
    h.sfdc_id,
    sm.specialist_group,

    coalesce(c.specialist_comments_14d, 0) as specialist_comments_14d,
    coalesce(c.specialist_comments_7d, 0) as specialist_comments_7d,

    coalesce(a.activities_14d, 0) as activities_14d,
    coalesce(a.w_uc_activity_14d, 0) as w_uc_activity_14d,
    coalesce(a.no_uc_activity_14d, 0) as no_uc_activity_14d,
    coalesce(a.activities_7d, 0) as activities_7d,
    coalesce(a.w_uc_activity_7d, 0) as w_uc_activity_7d,
    coalesce(a.no_uc_activity_7d, 0) as no_uc_activity_7d,

    case
        when coalesce(c.specialist_comments_14d, 0) > 0 then 'Active'
        when coalesce(c.specialist_comments_14d, 0) = 0
            and coalesce(a.activities_14d, 0) > 0 then 'Inactive with Activity'
        else 'Inactive'
    end as status

from hierarchy as h
inner join specialist_metadata as sm
    on h.preferred_name = sm.employee_name_cleaned
left join comments as c
    on h.sfdc_id = c.sfdc_user_id
left join activities as a
    on h.sfdc_id = a.sfdc_user_id
where h.preferred_name not in (select preferred_name from excluded_names)
