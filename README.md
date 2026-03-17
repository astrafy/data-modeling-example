# data-modeling-example

A dbt project demonstrating multi-layered data modeling for a fictional e-commerce sales analytics platform.

## Overview

This project shows how to build a production-style analytics stack with dbt, from raw seed data through staging, intermediate, and datamart layers. It covers common real-world challenges: ingesting sales data from two heterogeneous source systems, consolidating them into a unified fact table, enriching with CRM customer data, and exposing clean dimensional models and aggregates for BI consumption.

It is intentionally self-contained — all source data is provided as seed CSVs — making it easy to clone and run without any external database or warehouse credentials.

## Tech stack

| Tool | Version |
|------|---------|
| Python | 3.13+ |
| dbt-core | latest |
| dbt-duckdb | latest |
| dbt-utils | >=1.0.0, <2.0.0 |

DuckDB is used as the warehouse, so no external infrastructure is required.

## Project structure

```
models/
├── staging/          # Light cleaning of raw seed data; one model per source table
│   ├── system1/      # Sales, order items, products from System 1
│   ├── system2/      # Sales from System 2
│   └── crm/          # Customer records from the CRM
├── intermediate/     # Business logic: joins and cross-system consolidation
│   └── sales/
├── datamart/         # Dimensions, facts, aggregates, and reports (materialized as tables)
│   └── core/
└── utilities/        # Shared helper models (e.g. date spine)
```

| Layer | Materialization | Purpose |
|-------|----------------|---------|
| `staging` | view | Rename, cast, and lightly clean raw source tables |
| `intermediate` | view | Join related staging models; union multi-system sources |
| `datamart` | table | Dimensional models, facts, aggregates, and reports for analytics |
| `utilities` | table | Reusable support models (date spine, etc.) |

## Data sources

All source data is loaded via dbt seeds:

| Seed file | Source system | Description |
|-----------|--------------|-------------|
| `seed_system1__sales.csv` | System 1 | Sales header records |
| `seed_system1__sales_info.csv` | System 1 | Additional sale metadata |
| `seed_system1__order_items.csv` | System 1 | Line-item detail per sale |
| `seed_system1__products.csv` | System 1 | Product catalogue |
| `seed_system2__sales.csv` | System 2 | Sales records in a different schema |
| `seed_crm__customers.csv` | CRM | Customer master data |

System 1 and System 2 simulate two independently operated sales platforms whose records are unified downstream.

## Data lineage

```
seeds
  ├── seed_system1__sales          ─┐
  ├── seed_system1__sales_info      ├─► stg_system1__* ─► int_system1__sales_joined ─┐
  ├── seed_system1__order_items     │                                                  ├─► int_sales__unioned ─► fct_sales
  ├── seed_system1__products       ─┘                                                  │                    ─► fct_order_items
  ├── seed_system2__sales          ────► stg_system2__sales ────────────────────────────┘
  └── seed_crm__customers          ────► stg_crm__customers ─► dim_customers

datamart (tables exposed to BI)
  ├── dim_customers
  ├── dim_products
  ├── fct_sales
  ├── fct_order_items
  ├── agg_daily_sales
  ├── mart_customer_spend
  └── rpt_cohort_analysis

utilities
  └── util_date_spine
```

## Getting started

**1. Install dependencies**

```bash
pip install dbt-core dbt-duckdb
```

**2. Install dbt packages**

```bash
dbt deps
```

**3. Load seed data**

```bash
dbt seed --profile data_modeling_example
```

**4. Run all models**

```bash
dbt run --profile data_modeling_example
```

**5. Run tests**

```bash
dbt test --profile data_modeling_example
```

> The DuckDB database file will be created locally in the `target/` directory. No external warehouse setup is needed.

## Key modeling patterns

- **Surrogate keys** — `dbt_utils.generate_surrogate_key` is used across dimension and fact models to produce stable, hash-based primary keys independent of source system IDs.
- **Multi-system consolidation** — `int_sales__unioned` unions System 1 and System 2 sales into a single, normalised grain before feeding downstream facts, keeping source-system differences isolated to the staging and intermediate layers.
- **Incremental strategy** — fact tables are designed with incremental materialisation patterns in mind, allowing large tables to be updated efficiently in production.
- **Date spine** — `util_date_spine` generates a continuous calendar table used for time-series aggregations and gap-filling in reports like `agg_daily_sales` and `rpt_cohort_analysis`.
