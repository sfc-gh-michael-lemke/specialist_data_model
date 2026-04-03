-- Per-account, per-month functional area credit share from weekly WLC snapshots.
-- Months are derived by truncating the weekly DS_W timestamp.
select
    SALESFORCE_ACCOUNT_ID                   as ACCOUNT_ID,
    date_trunc('month', DS_W)               as SHARE_MONTH,
    LEVEL1                                  as FUNCTIONAL_AREA,
    avg(PCT_JOB_CREDITS)                    as CREDIT_SHARE

from {{ source('snowscience_product', 'wlc_cluster_label_v3') }}
where DS_W >= dateadd(month, -6, current_date())
  and LEVEL1 is not null
  and LEVEL1 not in ('Other', 'Untracked')
group by 1, 2, 3
