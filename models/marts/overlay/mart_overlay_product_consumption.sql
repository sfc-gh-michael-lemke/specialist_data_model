-- Product-category revenue with MoM daily-rate comparisons vs 1m, 3m, 6m ago.
-- Uses the most recent complete month (MAX(CONSUMPTION_MONTH)) as "current".
-- Refreshed each time dbt runs.
with monthly as (

    select
        SALESFORCE_ACCOUNT_ID           as ACCOUNT_ID,
        PRODUCT_CATEGORY,
        date_trunc('month', USAGE_DATE) as CONSUMPTION_MONTH,
        sum(REVENUE)                    as MONTHLY_REVENUE
    from {{ source('finance_customer', 'product_category_rev_actuals_w_forecast_sfdc') }}
    where ACTUALS_FORECAST_TYPE = 'Actual'
      and USAGE_DATE >= dateadd(month, -7, current_date())
    group by 1, 2, 3

),

latest as (

    select max(CONSUMPTION_MONTH) as MAX_MONTH from monthly

),

current_month as (

    select
        m.ACCOUNT_ID,
        m.PRODUCT_CATEGORY,
        m.MONTHLY_REVENUE,
        m.MONTHLY_REVENUE / nullif(day(current_date()), 0) as AVG_DAILY_REVENUE
    from monthly m, latest l
    where m.CONSUMPTION_MONTH = l.MAX_MONTH

),

prior_1m as (

    select
        m.ACCOUNT_ID,
        m.PRODUCT_CATEGORY,
        m.MONTHLY_REVENUE                                               as MONTHLY_REVENUE_1M_AGO,
        m.MONTHLY_REVENUE / nullif(day(last_day(m.CONSUMPTION_MONTH)), 0) as AVG_DAILY_REVENUE_1M_AGO
    from monthly m, latest l
    where m.CONSUMPTION_MONTH = dateadd(month, -1, l.MAX_MONTH)

),

prior_3m as (

    select
        m.ACCOUNT_ID,
        m.PRODUCT_CATEGORY,
        sum(m.MONTHLY_REVENUE) / nullif(sum(day(last_day(m.CONSUMPTION_MONTH))), 0) as AVG_DAILY_REVENUE_3M_AGO
    from monthly m, latest l
    where m.CONSUMPTION_MONTH between dateadd(month, -3, l.MAX_MONTH)
                                  and dateadd(month, -1, l.MAX_MONTH)
    group by 1, 2

),

prior_6m as (

    select
        m.ACCOUNT_ID,
        m.PRODUCT_CATEGORY,
        sum(m.MONTHLY_REVENUE) / nullif(sum(day(last_day(m.CONSUMPTION_MONTH))), 0) as AVG_DAILY_REVENUE_6M_AGO
    from monthly m, latest l
    where m.CONSUMPTION_MONTH between dateadd(month, -6, l.MAX_MONTH)
                                  and dateadd(month, -1, l.MAX_MONTH)
    group by 1, 2

)

select
    c.ACCOUNT_ID,
    c.PRODUCT_CATEGORY,
    c.MONTHLY_REVENUE,
    p1.MONTHLY_REVENUE_1M_AGO,
    c.AVG_DAILY_REVENUE,
    p1.AVG_DAILY_REVENUE_1M_AGO,
    p3.AVG_DAILY_REVENUE_3M_AGO,
    p6.AVG_DAILY_REVENUE_6M_AGO,

    case when p1.MONTHLY_REVENUE_1M_AGO > 0
         then (c.MONTHLY_REVENUE - p1.MONTHLY_REVENUE_1M_AGO) / p1.MONTHLY_REVENUE_1M_AGO
         else null
    end as MOM_GROWTH_RATE,

    case when p3.AVG_DAILY_REVENUE_3M_AGO > 0
         then (c.AVG_DAILY_REVENUE - p3.AVG_DAILY_REVENUE_3M_AGO) / p3.AVG_DAILY_REVENUE_3M_AGO
         else null
    end as MOM_GROWTH_RATE_VS_3M_AGO,

    case when p6.AVG_DAILY_REVENUE_6M_AGO > 0
         then (c.AVG_DAILY_REVENUE - p6.AVG_DAILY_REVENUE_6M_AGO) / p6.AVG_DAILY_REVENUE_6M_AGO
         else null
    end as MOM_GROWTH_RATE_VS_6M_AGO

from current_month c
left join prior_1m  p1 on c.ACCOUNT_ID = p1.ACCOUNT_ID and c.PRODUCT_CATEGORY = p1.PRODUCT_CATEGORY
left join prior_3m  p3 on c.ACCOUNT_ID = p3.ACCOUNT_ID and c.PRODUCT_CATEGORY = p3.PRODUCT_CATEGORY
left join prior_6m  p6 on c.ACCOUNT_ID = p6.ACCOUNT_ID and c.PRODUCT_CATEGORY = p6.PRODUCT_CATEGORY
