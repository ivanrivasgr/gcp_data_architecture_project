# 📚 Data Architecture Specification

## 🎯 Purpose

This project implements a modern data architecture in Google Cloud Platform (GCP) designed to:

- Integrate multiple data sources
- Standardize, clean, and unify datasets
- Remove and anonymize PII fields
- Build a final **Master User Model** for analytics

---

## 🏗️ Architecture Overview

```
GCS (RAW files)
↓
BigQuery — RAW Layer (Bronze)
↓ SQL transform + Mapping Rules (CSV-driven)
BigQuery — STAGING Layer (Silver)
↓ PII anonymization
BigQuery — MASTER Layer (Gold)
```

---


---

## 📦 Data Layers

| Layer | Name | Purpose | PII allowed |
|-------|------|----------|-------------|
| RAW   | Bronze | Stores data exactly as received from source systems | ✅ Yes |
| STAGING | Silver | Standardization, data cleaning, normalization | ⚠️ Limited |
| MASTER | Gold | Final unified model with anonymized data | 🚫 No |

---

## 🔐 PII Anonymization Strategy

| Original field | Transformation | Gold output |
|----------------|----------------|-------------|
| `customer_id`, `student_id` | Remove non-numeric characters, cast to INT | Standardized numeric ID |
| `email` | `SHA256(email)` | irreversible email hash |
| `phone` | Converted to boolean (`has_phone`) | true / false |
| `first_name + last_name` | `INITCAP(CONCAT(...))` | normalized full name |
| `gender` | Normalized to `M` / `F` | standard gender attribute |

---

## ✨ Master User Model (Gold Layer)

| Column | Type | Description |
|--------|------|-------------|
| `person_uid` | STRING | Unique irreversible SHA256 identifier |
| `email_hash` | STRING | Hash of email |
| `has_phone` | BOOLEAN | If a phone number exists (no number exposed) |
| `gender` | STRING | M or F |
| `birth_date` | DATE | Standardized date |
| `processed_at` | TIMESTAMP | Timestamp of data load |
| `customer_segment` *(optional)* | STRING | RFM or business segmentation |
| `rfm_score` *(optional)* | INT | Recency-frequency-monetary score |

---

## ♻️ Automated Pipeline (Cloud Composer / Airflow)

1. New file lands in GCS bucket
2. Airflow triggers BigQuery jobs
3. SQL loads RAW → STAGING → MASTER
4. Final table available for dashboards

---

## ✅ Final Output

- Unified dataset from multiple systems
- No phone, ID, or email exposed
- Ready for BI, dashboards, or ML models


