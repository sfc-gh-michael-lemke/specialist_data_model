select
    employee,
    specialist_group,
    trim(split_part(employee, '(', 1)) as employee_name_cleaned
from {{ source('sigma_writeback', 'dim_se_specialist_metadata') }}
