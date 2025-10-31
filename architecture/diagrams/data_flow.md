# Data Flow Diagram (GCP – Medallion Architecture)

```mermaid
flowchart TB
    %% ==== NODES ====
    A["External Data Sources"]
    B["GCS Bucket - RAW"]
    C["BigQuery - RAW Layer<br/>(Bronze)"]
    D["BigQuery - STAGING Layer<br/>(Silver)"]
    T["PII anonymization"]
    E["BigQuery - MASTER Layer<br/>(Gold)"]
    F["Cloud Composer / Airflow"]

    %% ==== MAIN DATA FLOW ====
    A --> B
    B --> C
    C --> D
    D --> E

    %% ==== PII FLOW ====
    D -.-> T -.-> E

    %% ==== AUTOMATION TRIGGERS ====
    F --> C
    F --> D
    F --> E
