-- GOLD LAYER (MEDALLION)
-- Contribution to Master User Model with anonymization
-- This dataset does NOT store PII, only analytics-ready attributes

CREATE OR REPLACE TABLE `project.dataset.master_supermarket_pos` AS
SELECT
  -- Unique deterministic UID (anonymized)
  TO_HEX(SHA256(CAST(document_id AS STRING))) AS person_uid,

  -- Flags indicating presence in this operational source
  TRUE AS is_supermarket_client,

  -- Non-sensitive attributes (can be shared)
  rfm_score_clean AS rfm_score,

  -- Metadata
  CURRENT_TIMESTAMP() AS processed_at

FROM `project.dataset.stg_supermarket_pos`
WHERE document_id IS NOT NULL;  -- Remove bad records
