select
    employee,
    employee_id,
    specialist_group,
    specialist_sub_group,
    specialist_theater,
    specialist_theater_market,
    trim(split_part(employee, '(', 1)) as employee_name_cleaned
from {{ source('sigma_writeback', 'dim_se_specialist_metadata') }}
