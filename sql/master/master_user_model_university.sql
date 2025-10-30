-- GOLD LAYER
-- Master User Model with anonymization (irreversible hashing)

CREATE OR REPLACE TABLE `project.dataset.master_user_model` AS
SELECT
  -- Unique anonymized user ID (hash of document ID)
  TO_HEX(SHA256(CAST(document_id AS STRING))) AS person_uid,

  -- Anonymized attributes (irreversible hashing)
  CASE 
    WHEN email IS NOT NULL THEN TO_HEX(SHA256(email))   -- Email stored as SHA256 hash
    ELSE NULL 
  END AS email_hash,

  -- Phone number: stored only as presence indicator (true/false)
  CASE 
    WHEN phone IS NOT NULL THEN TRUE                     -- Phone exists for this user
    ELSE FALSE
  END AS has_phone,

  -- Non-sensitive fields (allowed to remain for analytics)
  gender,
  birth_date,
  major,

  -- Metadata for auditing and pipeline traceability
  CURRENT_TIMESTAMP() AS processed_at

FROM `project.dataset.stg_university_students`;
