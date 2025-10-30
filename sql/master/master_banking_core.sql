-- GOLD LAYER (MEDALLION)
-- Contribution to Master User Model with anonymization
-- No direct PII stored — only hashed identifiers + business indicators

CREATE OR REPLACE TABLE `project.dataset.master_banking_core` AS
SELECT
  -- Anonymized unique ID from document number
  TO_HEX(SHA256(CONCAT(prefix_id, CAST(document_id AS STRING)))) AS person_uid,

  -- Flags used for cross-system entity resolution
  TRUE AS is_bank_client,

  -- Non-sensitive attributes (safe for analysis)
  customer_type,
  kyc_completed_at,

  -- Operation metadata
  CURRENT_TIMESTAMP() AS processed_at

FROM `project.dataset.stg_banking_core`
WHERE document_id IS NOT NULL;
