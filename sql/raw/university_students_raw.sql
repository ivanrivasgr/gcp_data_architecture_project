-- BRONZE LAYER
-- Raw ingestion of University Student dataset


CREATE OR REPLACE EXTERNAL TABLE `project.dataset.raw_university_students`
OPTIONS (
  format = 'CSV',
  uris = ['gs://bucket/raw/university_students/*.csv'],
  skip_leading_rows = 1,
  field_delimiter = ','
);
