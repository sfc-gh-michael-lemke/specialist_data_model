# specialist_data_model

dbt project for specialist engagement tracking and status reporting. Combines SE hierarchy, Salesforce activity, and specialist metadata to classify specialists as Active, Inactive with Activity, or Inactive.

## Model Layers

### Staging (`models/staging/`)
Thin wrappers over source tables with column selection.

| Model | Source |
|-------|--------|
| `stg_salesforce__vh_deliverable_history` | `FIVETRAN.SALESFORCE.VH_DELIVERABLE_HISTORY` |
| `stg_salesforce__user` | `FIVETRAN.SALESFORCE.USER` |
| `stg_se_reporting__dim_se_activity` | `SALES.SE_REPORTING.DIM_SE_ACTIVITY` |
| `stg_se_reporting__se_hierarchy` | `SALES.SE_REPORTING.SE_HIERARCHY` |
| `stg_sigma__dim_se_specialist_metadata` | `SIGMA_WRITEBACK.SALES.DIM_SE_SPECIALIST_METADATA` |

### Intermediate (`models/intermediate/`)
Aggregation logic for rolling activity windows.

| Model | Description |
|-------|-------------|
| `int_specialist_comments` | 7-day and 14-day specialist comment counts per user |
| `int_specialist_activities` | 7-day and 14-day SE activity counts (with/without use case) per user |

### Marts (`models/marts/`)
Final business-facing model, materialized as a table.

| Model | Description |
|-------|-------------|
| `specialist_engagement_status` | Specialist engagement status with hierarchy, metadata, comment/activity metrics, and status classification |

#### Status Logic
- **Active** — specialist comments in the last 14 days
- **Inactive with Activity** — no comments but has SE activities in the last 14 days
- **Inactive** — neither comments nor activities

## Setup

### Prerequisites
- Python 3.9+
- `dbt-snowflake` (`pip install dbt-snowflake`)

### Profile
The project expects a `specialist_data_model` profile in `~/.dbt/profiles.yml` targeting:
- **Database:** `COCO`
- **Schema:** `ADHOC`
- **Warehouse:** `SNOWHOUSE`
- **Auth:** `externalbrowser` (SSO)

### Commands
```bash
dbt parse     # Validate project structure (no connection needed)
dbt run       # Build all models (requires SSO auth)
dbt test      # Run tests
```
