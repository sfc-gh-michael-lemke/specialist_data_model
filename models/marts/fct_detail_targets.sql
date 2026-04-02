select workload, target_name, target
from (
    values
    -- Use Case Creation FY27
    ('Data Engineering',             'Use Case Creation FY27',  12779),
    ('Analytics',                    'Use Case Creation FY27',  17237),
    ('Applications & Collaboration', 'Use Case Creation FY27',  11037),
    ('AI/ML',                        'Use Case Creation FY27',  20031),
    ('OLTP',                         'Use Case Creation FY27',   2039),
    ('Total',                        'Use Case Creation FY27',  63123),
    -- Use Case Creation Q1
    ('Data Engineering',             'Use Case Creation Q1',     2811),
    ('Analytics',                    'Use Case Creation Q1',     3965),
    ('Applications & Collaboration', 'Use Case Creation Q1',     2318),
    ('AI/ML',                        'Use Case Creation Q1',     3005),
    ('OLTP',                         'Use Case Creation Q1',      326),
    ('Total',                        'Use Case Creation Q1',    12425),
    -- Use Case Win FY27
    ('Data Engineering',             'Use Case Win FY27',   1059000000),
    ('Analytics',                    'Use Case Win FY27',   1140000000),
    ('Applications & Collaboration', 'Use Case Win FY27',    551000000),
    ('AI/ML',                        'Use Case Win FY27',   1378000000),
    ('OLTP',                         'Use Case Win FY27',     76000000),
    ('Total',                        'Use Case Win FY27',   4205000000),
    -- Use Case Win Q1
    ('Data Engineering',             'Use Case Win Q1',      232980000),
    ('Analytics',                    'Use Case Win Q1',      262200000),
    ('Applications & Collaboration', 'Use Case Win Q1',      115710000),
    ('AI/ML',                        'Use Case Win Q1',      206700000),
    ('OLTP',                         'Use Case Win Q1',       12160000),
    ('Total',                        'Use Case Win Q1',      829750000),
    -- Go Live Win FY27
    ('Data Engineering',             'Go Live Win FY27',     845000000),
    ('Analytics',                    'Go Live Win FY27',     840000000),
    ('Applications & Collaboration', 'Go Live Win FY27',     460000000),
    ('AI/ML',                        'Go Live Win FY27',     865000000),
    ('OLTP',                         'Go Live Win FY27',      65000000),
    ('Total',                        'Go Live Win FY27',    3075000000),
    -- Go Live Win Q1
    ('Data Engineering',             'Go Live Win Q1',       185900000),
    ('Analytics',                    'Go Live Win Q1',       193200000),
    ('Applications & Collaboration', 'Go Live Win Q1',        96600000),
    ('AI/ML',                        'Go Live Win Q1',       129750000),
    ('OLTP',                         'Go Live Win Q1',        10400000),
    ('Total',                        'Go Live Win Q1',       615850000),
    -- Consumption Q1
    ('Data Engineering',             'Consumption Q1',       651329091),
    ('Analytics',                    'Consumption Q1',       344370801),
    ('Applications & Collaboration', 'Consumption Q1',        71816500),
    ('AI/ML',                        'Consumption Q1',        29733887),
    ('OLTP',                         'Consumption Q1',         8425453),
    ('Total',                        'Consumption Q1',      1105675732)
) as t (workload, target_name, target)
