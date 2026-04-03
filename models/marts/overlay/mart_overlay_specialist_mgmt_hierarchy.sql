-- Maps each specialist in the overlay pipeline to their Workday first-line manager.
-- Uses the most recent employee hierarchy snapshot.
select distinct
    o.SPECIALIST_NAME,
    h.MANAGER_NAME as WORKDAY_MANAGER

from {{ source('sales_reporting', 'overlay_use_case_pipeline') }} o
inner join {{ source('sales_reporting', 'int_employee_management_hierarchy') }} h
    on h.EMPLOYEE_NAME = o.SPECIALIST_NAME
    and h.IS_EMPLOYEE_ACTIVE = true
    and h.SNAPSHOT_AT = (
        select max(SNAPSHOT_AT)
        from {{ source('sales_reporting', 'int_employee_management_hierarchy') }}
    )
where o.SPECIALIST_MANAGER_NAME is not null
