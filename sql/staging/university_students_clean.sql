-- SILVER LAYER
-- Standardization + cleaning


CREATE OR REPLACE TABLE `project.dataset.stg_university_students` AS
SELECT
  -- Normalize document ID (keep only numeric characters)
  SAFE_CAST(REGEXP_REPLACE(student_id, r'[^0-9]', '') AS INT64) AS document_id,

  -- Normalize name fields (trim spaces and apply proper casing)
  INITCAP(TRIM(first_name)) AS first_name,
  INITCAP(TRIM(last_name)) AS last_name,

  -- Normalize gender to standard M/F format
  CASE
    WHEN UPPER(gender) IN ('MALE', 'M', 'HOMBRE') THEN 'M'
    WHEN UPPER(gender) IN ('FEMALE', 'F', 'MUJER') THEN 'F'
    ELSE NULL
  END AS gender,

  -- Convert birth date into DATE data type
  PARSE_DATE('%Y-%m-%d', birth_date) AS birth_date,

  -- Normalize academic major field
  INITCAP(TRIM(major)) AS major,

  -- Additional attributes, standardized if needed
  UPPER(email) AS email,                         -- Emails stored uppercase for matching consistency
  REGEXP_REPLACE(phone, r'^\+58', '0') AS phone  -- Replace international prefix with local format

FROM `project.dataset.raw_university_students`;
