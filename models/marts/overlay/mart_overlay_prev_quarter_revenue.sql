-- Single-row scalar: total revenue for the 2nd-previous fiscal quarter.
-- Used by the Overlay Dashboard quarterly trend chart.
-- Refreshed each time dbt runs.
with fq_list as (

    select distinct FISCAL_YEAR, FISCAL_QUARTER
    from {{ source('sales_reporting', 'consumption_daily') }}
    where FISCAL_QUARTER is not null

),

ordered as (

    select
        FISCAL_YEAR,
        FISCAL_QUARTER,
        row_number() over (order by FISCAL_YEAR desc, FISCAL_QUARTER desc) as rn
    from fq_list

)

select
    sum(d.TOTAL_REVENUE) as PREV2_FQ_REVENUE

from {{ source('sales_reporting', 'consumption_daily') }} d
join ordered o
    on d.FISCAL_YEAR = o.FISCAL_YEAR
    and d.FISCAL_QUARTER = o.FISCAL_QUARTER
where o.rn = 3
