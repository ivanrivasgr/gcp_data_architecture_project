-- BRONZE LAYER
-- Raw ingestion (as-is) from operational systems

CREATE OR REPLACE TABLE `project.dataset.raw_supermarket_pos` AS
SELECT
  customer_doc,              -- Document ID (RIF, national ID, etc.)
  full_name,                 -- Customer full name (free text)
  gender,                    -- Raw gender values e.g. M / F / Male / Female
  email,
  phone,
  rfm_score,                 -- RFM scoring (recency / frequency / monetary)
  CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM `project.dataset.external_supermarket_pos_source`;  -- Could be GCS external table
