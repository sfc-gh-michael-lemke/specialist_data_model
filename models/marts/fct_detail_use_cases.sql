with wins as (
    select
        use_case_id,
        forecast_type
    from {{ ref('stg_sales_reporting__forecast_use_cases') }}
    where use_case_forecast_type = 'Wins'
    qualify row_number() over (partition by use_case_id order by submitted_date desc) = 1
),

golive as (
    select
        use_case_id,
        forecast_type
    from {{ ref('stg_sales_reporting__forecast_use_cases') }}
    where use_case_forecast_type = 'Go Lives'
    qualify row_number() over (partition by use_case_id order by submitted_date desc) = 1
)

select
    u.*,
    case
        when u.stage_number in (0, 8)                                                             then 'Not in Pursuit/Lost'
        when u.is_won = true and u.stage_number not in (0, 8)                                     then 'Won'
        when wins.forecast_type in ('Commit', 'Most Likely') and u.stage_number not in (0, 8)     then 'Forecasted Win'
        else 'Not Likely'
    end as fct_uc_win_state,
    concat(
        'FY',
        right(cast(case when month(u.decision_date) >= 2 then year(u.decision_date) + 1 else year(u.decision_date) end as varchar), 2),
        '-Q',
        case
            when month(u.decision_date) in (2, 3, 4)   then '1'
            when month(u.decision_date) in (5, 6, 7)   then '2'
            when month(u.decision_date) in (8, 9, 10)  then '3'
            else '4'
        end
    ) as fct_uc_win_state_date,
    case
        when u.stage_number in (0, 8)                                                             then 'Not in Pursuit/Lost'
        when u.is_deployed = true and u.stage_number not in (0, 8)                               then 'Deployed'
        when golive.forecast_type in ('Commit', 'Most Likely') and u.stage_number not in (0, 8)  then 'Forecasted Deployment'
        else 'Not Likely'
    end as fct_uc_go_live_state,
    concat(
        'FY',
        right(cast(case when month(u.go_live_date) >= 2 then year(u.go_live_date) + 1 else year(u.go_live_date) end as varchar), 2),
        '-Q',
        case
            when month(u.go_live_date) in (2, 3, 4)   then '1'
            when month(u.go_live_date) in (5, 6, 7)   then '2'
            when month(u.go_live_date) in (8, 9, 10)  then '3'
            else '4'
        end
    ) as fct_uc_go_live_state_date
from {{ ref('stg_mdm__dim_use_case') }} u
left join wins on wins.use_case_id = u.use_case_id
left join golive on golive.use_case_id = u.use_case_id
