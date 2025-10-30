-- SILVER LAYER
-- Standardization + cleaning

CREATE OR REPLACE TABLE `project.dataset.stg_supermarket_pos` AS
SELECT
  -- Normalize document ID (strip non-numeric characters)
  SAFE_CAST(REGEXP_REPLACE(customer_doc, r'[^0-9]', '') AS INT64) AS document_id,

  -- Split full_name into first/last (simple heuristic)
  INITCAP(TRIM(SPLIT(full_name, ' ')[OFFSET(0)])) AS first_name,
  INITCAP(TRIM(SPLIT(full_name, ' ')[SAFE_OFFSET(1)])) AS last_name,

  -- Normalize gender (M/F)
  CASE
    WHEN UPPER(gender) IN ('MALE', 'M', 'HOMBRE') THEN 'M'
    WHEN UPPER(gender) IN ('FEMALE', 'F', 'MUJER') THEN 'F'
    ELSE NULL
  END AS gender,

  -- Cleanup email and phone
  LOWER(TRIM(email)) AS email,
  REGEXP_REPLACE(phone, r'^\+58', '0') AS phone,

  -- Pass through RFM score (used for analytics)
  SAFE_CAST(rfm_score AS INT64) AS rfm_score_clean,

  CURRENT_TIMESTAMP() AS processed_at

FROM `project.dataset.raw_supermarket_pos`;
