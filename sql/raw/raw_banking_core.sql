-- BRONZE LAYER
-- Raw ingestion from banking core (KYC / onboarding data)

CREATE OR REPLACE TABLE `project.dataset.raw_banking_core` AS
SELECT
  document_type,        -- Example: V, E, J, G, P
  document_number,      -- Raw document ID (can include dashes or spaces)
  first_name,
  last_name,
  gender,
  phone,
  email,
  customer_type,        -- Retail / Business
  kyc_completed_at,     -- Timestamp when KYC was completed
  CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM `project.dataset.external_banking_core_source`;  -- External table or GCS import
