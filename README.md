## 🧱 Medallion Architecture (Bronze → Silver → Gold)

This project follows the **Medallion Data Architecture** pattern, implemented in BigQuery:

| Layer | Folder | Purpose |
|-------|--------|----------|
| **Bronze** | `/sql/raw/` | Raw ingestion of multiple source systems (no transformations). |
| **Silver** | `/sql/staging/` | Standardization + cleaning + data quality rules. |
| **Gold** | `/sql/master/` | Final business logic + entity unification + anonymization (Master User Model). |

> ✅ This structure is modular and scalable — new sources only require adding a new silver mapping.
