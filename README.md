# Modern Data Architecture on Google Cloud Platform (GCP)

This project demonstrates how to build a fully automated **PII-safe data pipeline** using:

- Google Cloud Storage (GCS)
- BigQuery (Bronze → Silver → Gold data modeling)
- Cloud Composer / Airflow
- GitHub + SQL versioning
- CSV-driven transformation rules (dynamic mapping)

---

## 🚀 Objective

The goal of this architecture is to:

- Integrate multiple heterogeneous data sources
- Standardize schemas and transform data via SQL + mapping rules
- Remove and anonymize PII to comply with privacy regulations
- Produce a **Master User Model (Gold dataset)** ready for BI or ML

---

## 🏗️ High-Level Architecture

```
┌─────────────┐
│ External │ CSV, JSON, API, DB extracts
│ Data Source │
└──────┬───────┘
|
▼
┌───────────────────────────┐
│ Google Cloud Storage │ → RAW files (Bronze)
└──────┬────────────────────┘
|
▼
┌───────────────────────────┐
│ BigQuery STAGING (Silver) │ Standardization + cleaning
└──────┬────────────────────┘
|
▼
┌───────────────────────────┐
│ BigQuery MASTER (Gold) │ PII removed / anonymized
└───────────────────────────┘
```

---

## 📄 Datasets

| Folder | Description |
|--------|-------------|
| `datasets/raw_samples` | Example raw input files (as ingested from source) |
| `datasets/anonymized_samples` | Output of the Gold anonymized dataset |
| `datasets/mapping_rules.csv` | CSV that defines dynamic transformations |
| `datasets/data_dictionary.csv` | Metadata + PII layer classification |

---

## ✨ Master User Model

| Column | Type | Description |
|--------|------|-------------|
| `person_uid` | STRING | SHA256 irreversible anonymized identifier |
| `email_hash` | STRING | SHA256 hash of email |
| `has_phone` | BOOLEAN | True/False, without exposing the number |
| `gender` | STRING | M / F normalized |
| `birth_date` | DATE | Standardized format |
| `processed_at` | TIMESTAMP | Time the record was processed |

---

## 🔐 PII Anonymization Strategy

| Original Field | Transformation | Output |
|----------------|----------------|--------|
| `customer_id` / `student_id` | Remove non-numeric + cast to INT | Unified numeric ID |
| `email` | SHA256 hashing | Irreversible hash |
| `phone` | Converted to boolean (`has_phone`) | true / false |
| `first + last name` | INITCAP(CONCAT(...)) | Normalized full name |
| `gender` | Normalize | M / F |

---

## ⚙️ Automation (Cloud Composer / Airflow)

1. File arrives in GCS
2. Airflow detects the file
3. SQL pipelines execute: **RAW → STAGING → MASTER**
4. Final dataset available for BI / ML

---

## ✅ Final Output

- Unified dataset across multiple systems
- No exposure of phone, ID, or email
- Ready for dashboards and machine learning

---

## 📦 Repository Structure

```
gcp_data_architecture_project/
│
├── datasets/
│ ├── raw_samples/
│ ├── anonymized_samples/
│ ├── mapping_rules.csv
│ └── data_dictionary.csv
│
├── sql/
│ ├── raw
│ ├── staging
│ └── master
│
└── architecture/
├── diagrams/
└── documentation/
└── data_architecture.md
```

---

## 👤 Author

**Iván Rivas**  
Data Engineer | Cloud & Automation  
