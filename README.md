# aws-etl-pipeline
A automated serverless ETL pipeline built on AWS. In this project transformation of CSV data ingested into S3 is done , using AWS Lambda to trigger a AWS Glue Workflow containing crawlers and Spark ETL jobs. The processed data is then loaded into Amazon Redshift, with real time notifications delivered via Amazon SNS through EventBridge.
