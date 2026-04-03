-- Distinct account → functional area mapping using the latest weekly WLC snapshot.
select distinct
    SALESFORCE_ACCOUNT_ID as ACCOUNT_ID,
    LEVEL1                as FUNCTIONAL_AREA

from {{ source('snowscience_product', 'wlc_cluster_label_v3') }}
where DS_W = (select max(DS_W) from {{ source('snowscience_product', 'wlc_cluster_label_v3') }})
  and LEVEL1 is not null
  and LEVEL1 not in ('Other', 'Untracked')
