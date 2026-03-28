with comment_events as (

    select
        u.id as sfdc_user_id,
        h.id as history_id,
        h.created_date
    from {{ ref('stg_salesforce__vh_deliverable_history') }} as h
    join {{ ref('stg_salesforce__user') }} as u
        on h.created_by_id = u.id
    where h.field = 'Specialist_Comments__c'

)

select
    sfdc_user_id,
    count(distinct case
        when created_date >= dateadd(day, -14, current_date())
        then history_id
    end) as specialist_comments_14d,
    count(distinct case
        when created_date >= dateadd(day, -7, current_date())
        then history_id
    end) as specialist_comments_7d
from comment_events
where created_date >= dateadd(day, -14, current_date())
group by sfdc_user_id
