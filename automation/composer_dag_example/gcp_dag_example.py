from airflow import DAG
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
from datetime import datetime

with DAG(
    dag_id="gcp_data_medallion_pipeline",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@daily",
    catchup=False,
    tags=["gcp", "bigquery", "medallion"],
):

    raw_to_staging = BigQueryInsertJobOperator(
        task_id="load_raw_to_staging",
        configuration={
            "query": {
                "query": "CALL dataset.raw_to_staging();",
                "useLegacySql": False,
            }
        },
    )

    staging_to_master = BigQueryInsertJobOperator(
        task_id="load_staging_to_master",
        configuration={
            "query": {
                "query": "CALL dataset.staging_to_master();",
                "useLegacySql": False,
            }
        },
    )

    raw_to_staging >> staging_to_master
