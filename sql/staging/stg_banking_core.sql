-- SILVER LAYER
-- Standardization + cleaning for banking core users

CREATE OR REPLACE TABLE `project.dataset.stg_banking_core` AS
SELECT
  -- Standardize document ID (prefix + digits only)
  CASE
    WHEN UPPER(document_type) IN ('V','E','J','G','P') THEN UPPER(document_type)
    ELSE NULL
  END AS prefix_id,

  SAFE_CAST(REGEXP_REPLACE(document_number, r'[^0-9]', '') AS INT64) AS document_id,

  -- Normalize name formats (First letter uppercase)
  INITCAP(TRIM(first_name)) AS first_name,
  INITCAP(TRIM(last_name)) AS last_name,

  -- Normalize gender (M/F)
  CASE
    WHEN UPPER(gender) IN ('MALE', 'M', 'HOMBRE') THEN 'M'
    WHEN UPPER(gender) IN ('FEMALE', 'F', 'MUJER') THEN 'F'
    ELSE NULL
  END AS gender,

  -- Standardize contact data
  LOWER(TRIM(email)) AS email,
  REGEXP_REPLACE(phone, r'^\+58', '0') AS phone,

  -- Business vs retail client
  CASE
    WHEN LOWER(customer_type) LIKE '%business%' THEN 'BUSINESS'
    ELSE 'RETAIL'
  END AS customer_type,

  -- KYC event date
  TIMESTAMP(kyc_completed_at) AS kyc_completed_at,

  CURRENT_TIMESTAMP() AS processed_at

FROM `project.dataset.raw_banking_core`
WHERE document_number IS NOT NULL;
