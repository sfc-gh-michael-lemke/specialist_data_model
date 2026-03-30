with activities as (

    select
        activity_se_id as sfdc_user_id,
        activity_id,
        activity_date,
        use_case_id,
        source
    from {{ ref('stg_se_reporting__dim_se_activity') }}
    where activity_date >= dateadd(day, -14, current_date())

)

select
    sfdc_user_id,

    -- 14-day window
    count(*) as activities_14d,
    count(case when use_case_id is not null then 1 end) as w_uc_activity_14d,
    count(case when use_case_id is null then 1 end) as no_uc_activity_14d,

    -- 7-day window
    count(case when activity_date >= dateadd(day, -7, current_date()) then 1 end) as activities_7d,
    count(case
        when activity_date >= dateadd(day, -7, current_date()) and use_case_id is not null
        then 1
    end) as w_uc_activity_7d,
    count(case
        when activity_date >= dateadd(day, -7, current_date()) and use_case_id is null
        then 1
    end) as no_uc_activity_7d,

    -- 7-day by source
    count(distinct case
        when activity_date >= dateadd(day, -7, current_date()) and source = 'Setsail'
        then activity_id
    end) as activities_7d_setsail,
    count(distinct case
        when activity_date >= dateadd(day, -7, current_date()) and source = 'Vivun'
        then activity_id
    end) as activities_7d_vivun

from activities
group by sfdc_user_id
