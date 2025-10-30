
🔹 **Medallion layer mapping in repository structure**

| Layer (Medallion) | Folder | Description |
|------------------|---------|-------------|
| 🟤 Bronze         | `/sql/raw/`     | Raw ingestion (as-is) from operational systems |
| 🥈 Silver         | `/sql/staging/` | Standardization, regex cleaning, unifying columns, deduping |
| 🥇 Gold           | `/sql/master/`  | Master User Model (entity resolution + anonymization) |

---

## 🚀 Features

### ✅ Multi-source ingestion
Handles multiple unrelated datasets with different schemas and structure.

Examples of sources handled (names anonymized):
- Supermarket loyalty POS
- Banking core system (KYC)
- University student records
- Telco / clinic / other sources

### ✅ Master User Model logic (entity resolution)

Each data source may have:

| Field | Examples |
|--------|---------|
| `cedula_id`, `rif`, `document_id` | Personal or business identifiers |
| `email`, `phone`, `name` | Natural keys used for matching |
| `prefix_id` | Handling document types (V, E, J, G, P, etc.) |

Silver layer applies:
- Regex cleanup (`REGEXP_REPLACE`)
- Mapping values (`CASE`, `UPPER`, `TRIM`)
- Standardizing document ID formats
- Completing missing fields using priority rules

### ✅ Anonymization (Gold layer)
PII is removed or irreversibly transformed:

| Before | After |
|--------|-------|
| Full name | SHA256 hash |
| Document ID | Salted hash |
| Email / phone | Masked or removed |

📌 **Only business attributes remain**, e.g. segmentation, recency, frequency, monetary value.

---

```

gcp_data_architecture_project/
│
├── sql/
│ ├── raw/ # Bronze — raw source ingestion
│ ├── staging/ # Silver — cleaning, mapping, standardization
│ └── master/ # Gold — final anonymized Master User Model
│
└── docs/
├── data_dictionary/ # Field definitions (data type, category, nullability)
├── mapping_rules/ # Source-to-target column mapping
└── architecture/ # Diagrams of the medallion pipeline

```


---

## 🧠 Master User Model (Gold Layer)

Each user becomes **one unique record**:

| Column | Category | Description |
|--------|----------|-------------|
| `person_uid` | ID | SHA256 unique identifier (anonymous) |
| `gender` | Demographic | User gender |
| `birth_date` | Demographic | Normalized birth date |
| `is_retail_client` / `is_bank_client` / etc. | Indicator | Flags indicating presence across systems |
| `customer_segment` | Segmentation | Classification logic based on business rules |
| `rfm_score` | Analytics | Recency, frequency, monetary scoring |

---

## 🔐 Data Privacy & Security

This project enforces:

- ✅ No storage of PII in Gold layer
- ✅ Hashing + masking (irreversible)
- ✅ Separation of data domains (Bronze ≠ Silver ≠ Gold)

> Output dataset is safe to share with business stakeholders or used in future models without exposing personal data.

---

## 🛠️ Tools Used

| Component | Technology |
|----------|------------|
| Data ingestion | GCP Cloud Storage |
| Data warehouse | BigQuery |
| Modeling & SQL | Standard SQL + regex transformations |
| Architecture pattern | **Medallion (Bronze / Silver / Gold)** |
| Governance | Data dictionary + mapping sheet (Google Sheets) |

---

## 📈 Why this project matters

✅ Implements a **modern enterprise data architecture**  
✅ Scalable to new sources by just adding a Silver mapping  
✅ Removes compliance risks via **automated anonymization**  

> This solves the real-world problem of companies having fragmented data across multiple operational systems.

---

## 🧪 How to run (simplified)

1. Upload datasets to Cloud Storage  
2. Load into BigQuery Bronze layer (external table or ingestion job)
3. Run `/sql/staging/*.sql` (standardization + cleaning)
4. Run `/sql/master/master_user_model.sql` (anonymized dataset)

---

## 📬 Contact

If you're interested in the architecture or want to discuss improvements:

**Iván Rivas**  
Data Engineer / Analytics Engineer  
🔗 LinkedIn: https://www.linkedin.com/in/ivanrivasgr/

---

> ⭐ If this repo helped you, consider giving it a star.  
> It helps visibility and shows that real-world data architecture projects matter.



## 📂 Repository Structure

