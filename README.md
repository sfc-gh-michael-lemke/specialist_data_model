# specialist_data_model

A dbt project that models specialist engagement data for the AMS AFE & Architect teams, with a Streamlit app for weekly activity monitoring.

## Overview

This project transforms raw data from Salesforce, Pigment, SE Reporting, and Sigma into clean mart tables tracking specialist comments, activities, org structure, and use case engagement. The primary consumer is a Streamlit dashboard deployed to Snowflake.

## Streamlit App

**AMS Specialist Engagement Weekly** — a 7-day snapshot of specialist comment and activity counts across the AMS AFE & Architect teams.

### Features
- KPI summary: total specialists, comment rate, Vivun usage
- Sidebar filters: group, sub-group, theater market, manager, third-line manager
- Two tabs: specialists without comments (needs attention) and specialists with comments
- Data cached for 10 minutes

### Run locally

```bash
streamlit run streamlit_app.py
```

### Deploy to Snowflake

```bash
snow streamlit deploy --replace
```

Deployed as `AFE.DBT_DEV_MARTS.SPECIALIST_ENGAGEMENT_WEEKLY_APP` on the `STREAMLIT_DEDICATED_POOL` compute pool using `SNOWADHOC` as the query warehouse.

## dbt Project Structure

```
models/
  staging/        # Views — raw source cleaning (sources.yml defines all upstream tables)
  intermediate/   # Ephemeral — reusable activity and comment aggregations
  marts/          # Tables — final output models, granted to AFE_MODELING_RL, DASHBOARD_SHARING_RL, SALES_ENGINEER
```

### Mart Models

| Model | Description |
|---|---|
| `specialist_engagement_weekly` | 7-day comment and activity rollup per specialist — primary app source |
| `specialist_engagement_status` | Current engagement status per specialist |
| `specialist_accounts` | Specialist-to-account mapping |
| `specialist_org` | Org hierarchy and reporting structure |
| `specialist_pigment` | Pigment roster data |
| `specialist_requests` | Specialist team member requests |
| `specialist_use_case` | Use case pipeline per specialist |

### Sources

| Source | Staging Models |
|---|---|
| Pigment | `stg_pigment__pigment_roster` |
| Salesforce | `stg_salesforce__user`, `stg_salesforce__vh_deliverable_history` |
| Sales Engineering (internal) | `stg_sales_engineering__salesforce_account`, `stg_sales_engineering__usecase` |
| SE Reporting | `stg_se_reporting__dim_se_activity`, `stg_se_reporting__se_hierarchy`, `stg_se_reporting__se_org_hierarchy_vw`, `stg_se_reporting__specialist_team_member_requests` |
| Sigma | `stg_sigma__dim_se_specialist_metadata` |

## Requirements

- dbt Core with Snowflake adapter
- Snowflake connection configured in `~/.dbt/profiles.yml` under `specialist_data_model`
- Snowflake CLI (`snow`) for Streamlit deployment

## Common Commands

```bash
dbt run          # Build all models
dbt test         # Run tests
dbt run --select marts  # Build mart layer only
dbt docs generate && dbt docs serve  # View lineage docs
```
