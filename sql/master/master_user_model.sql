-- MASTER USER MODEL (GLOBAL GOLD LAYER)
-- Merge of anonymized outputs from all operational sources
-- One user = one record (entity resolution based on hashed UID)

CREATE OR REPLACE TABLE `project.dataset.master_user_model` AS
WITH university AS (
  SELECT
    person_uid,
    gender,
    birth_date,
    major,
    -- Indicator: present in university dataset
    TRUE AS is_university_student
  FROM `project.dataset.master_user_model_university`
),

supermarket AS (
  SELECT
    person_uid,
    total_spent,
    last_purchase_at,
    purchase_frequency,
    TRUE AS is_retail_client
  FROM `project.dataset.master_supermarket_pos`
),

banking AS (
  SELECT
    person_uid,
    kyc_completed_at,
    customer_type,
    TRUE AS is_bank_client
  FROM `project.dataset.master_banking_core`
)

-- Merge using FULL OUTER JOIN to preserve users even if they appear only in 1 dataset
SELECT
  COALESCE(u.person_uid, s.person_uid, b.person_uid) AS person_uid,

  -- Demographics from university
  u.gender,
  u.birth_date,
  u.major,

  -- Business indicators from POS & Banking
  s.total_spent,
  s.purchase_frequency,
  s.last_purchase_at,
  b.customer_type,
  b.kyc_completed_at,

  -- Flags per source system
  IFNULL(u.is_university_student, FALSE) AS is_university_student,
  IFNULL(s.is_retail_client, FALSE) AS is_retail_client,
  IFNULL(b.is_bank_client, FALSE) AS is_bank_client,

  CURRENT_TIMESTAMP() AS processed_at

FROM university u
FULL OUTER JOIN supermarket s ON u.person_uid = s.person_uid
FULL OUTER JOIN banking b ON COALESCE(u.person_uid, s.person_uid) = b.person_uid;
