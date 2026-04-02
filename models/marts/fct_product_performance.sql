with forecast_deduped as (
    select
        use_case_id,
        use_case_forecast_type,
        forecast_type,
        submitted_date,
        row_number() over (
            partition by use_case_id, use_case_forecast_type
            order by submitted_date desc
        ) as rn
    from {{ ref('stg_sales_reporting__forecast_use_cases') }}
),

use_cases_expanded as (
    select
        uc.use_case_id,
        uc.use_case_name,
        uc.use_case_eacv,
        uc.stage_number,
        uc.decision_date,
        uc.go_live_date,
        uc.theater_name,
        uc.region_name,
        uc.sub_region_name,
        uc.district_name,
        uc.account_id,
        uc.account_name,
        cat.value::varchar as product_category
    from {{ ref('stg_mdm__dim_use_case') }} uc,
        lateral flatten(input => uc.product_category_array) cat
    where uc.stage_number not in (0, 8)
      and cat.value::varchar in (
          'Data Engineering',
          'Applications & Collaboration',
          'Analytics',
          'AI'
      )
)

select
    uc.use_case_id,
    uc.use_case_name,
    uc.use_case_eacv,
    uc.stage_number,
    uc.decision_date,
    uc.go_live_date,
    uc.theater_name,
    uc.region_name,
    uc.sub_region_name,
    uc.district_name,
    uc.account_id,
    uc.account_name,
    uc.product_category,
    f.use_case_forecast_type,
    f.forecast_type,
    f.submitted_date
from use_cases_expanded uc
inner join forecast_deduped f
    on f.use_case_id = uc.use_case_id
    and f.rn = 1
where (
    (
        f.use_case_forecast_type = 'Wins'
        and uc.decision_date between '2026-02-01' and '2027-01-31'
    )
    or (
        f.use_case_forecast_type = 'Go Lives'
        and uc.go_live_date between '2026-02-01' and '2027-01-31'
    )
)
