# AWS ETL Pipeline: S3 to Redshift ETL

## Project Overview

This project implements a robust and automated Extract, Transform, Load (ETL) pipeline on AWS. It is designed to process new CSV files uploaded to an S3 bucket, transform them into a standardized Parquet format with selected columns, and then load the refined data into an Amazon Redshift data warehouse for analytical querying. The entire process is event-driven, ensuring efficient and timely data processing.

## Architecture

The pipeline leverages several AWS services orchestrated into a seamless workflow:

1.  **S3 Event Trigger:** An S3 bucket (`sales-data-etl-project`) is configured to emit an event via Amazon EventBridge rule (`start-lambda-rule`) whenever a new CSV file is uploaded to its `input/` prefix.
2.  **AWS Lambda Activation:** This S3 event triggers an AWS Lambda function (`start-workflow-function`).
3.  **Glue Workflow Initiation:** The Lambda function initiates an AWS Glue Workflow (`sales-data-workflow`).
4.  **Glue Workflow Steps:**
    * **Crawler 1 (Input CSV):** A Glue Crawler (`csv-data-reader`) crawls the `input/` folder of the S3 bucket to discover the schema of the newly added CSV file.
    * **Glue Job 1 (CSV to Parquet):** A Glue ETL Job (`csv-to-parquet-job`) reads the CSV data, checks null values, selects specific columns, and transforms the data into Parquet format. The processed data is then saved into an `output/` folder of the same S3 bucket (`sales-data-etl-project`).
    * **Crawler 2 (Output Parquet):** Another Glue Crawler (`parquet-data-reader`) crawls the `output/` folder to infer the schema of the newly generated Parquet files.
    * **Glue Job 2 (Parquet to Redshift):** A second Glue ETL Job (`redshift-loader-Job`) reads the Parquet data from the `output/` folder and loads it into a specified table in your Amazon Redshift cluster (`sales-data-workgroup`).
5.  **SNS Notifications:** Amazon SNS is integrated to provide notifications for the Lambda function execution status, as well as the success and failure states of both Glue Crawlers and Glue Jobs within the workflow.

### Architecture Diagram

![Architecture Diagram](files/sales-data-etl-flowchart.png)

## AWS Services Used

* **Amazon S3:** Input and output data storage.
* **Amazon EventBridge** Rules to envoke Lambda function and publish in SNS topics.
* **AWS Lambda:** Event-driven function to trigger the Glue workflow.
* **AWS Glue:**
    * **Crawlers:** Schema discovery for CSV and Parquet.
    * **Jobs:** Data transformation (CSV to Parquet) and loading (Parquet to Redshift).
    * **Workflow:** Orchestration of crawlers and jobs.
* **Amazon Redshift:** Data warehouse for final analytical data.
* **Amazon SNS:** Notification service for operational alerts.
* **AWS IAM:** For managing permissions between services.
* **Amazon CloudWatch:** For log management.

## Prerequisites

Before deploying this project, ensure you have the following:

* An AWS Account with administrative access or appropriate IAM permissions.
* Basic understanding of AWS S3, Lambda, Glue, SNS, EventBridge, IAM, VPC Endpoints, CLoudWatch and Redshift.

## Setup and Deployment

1.  **Create S3 Buckets:**
    * Project Bucket: `sales-data-etl-project`
    * Input folder: `sales-data-etl-project/input` 
    * Output folder: `sales-data-etl-project/output`
    * Glue Scripts Bucket: `aws-glue-assets/scripts`
2.  **Create IAM Roles:**
    * Create IAM Role for Lambda function (Glue and CloudWatch permissions).
    * Create IAM Role for Crawler (with S3 read/write, CloudWatch and specific Glue permissions).
    * Create IAM Role for Job 1 (with S3 read/write, CloudWatch and specific Glue permissions).
    * Create IAM Role for Job 2 (with S3 read/write, CloudWatch, SecretsManager, KMS, VPC, and specific Glue permissions).
    * Create IAM Role for Redshift (with S3 read/write and KMS permissions).
    * Create IAM Role for EventBridge rules (with Lambda and SNS permissions).
3.  **Configure Lambda Function:**
    * Create Lambda function (`start-workflow-function`).
    * Link it to the EventBridge rule (`start-lambda-rule`).
    * Set runtime, handler, and assign Lambda IAM Role.
4.  **Create Glue Crawlers:**
    * **Input CSV Crawler:** 
    * Create crawler (`csv-data-reader`).
    * Data source: `s3://sales-data-etl-project/input/`. Assign Crawler IAM Role (`role-for-crawler`).
    * Output and Scheduling: Target database (`db-01`) and On demand scheduling. 
    * **Output Parquet Crawler:** 
    * Create crawler (`parquet-data-reader`).
    * Data source: `s3://sales-data-etl-project/output/`. Assign Crawler IAM Role (`role-for-crawler`).
    * Output and Scheduling: Target database (`db-01`) and On demand scheduling.
5.  **Create Glue Jobs:**
    * **CSV to Parquet Job:** 
    * Create Job (`csv-to-parquet-job`). Assign Glue IAM Role. Configure arguments for input/output paths.
    * **Parquet to Redshift Job:** 
    * Create Job (`redshift-loader-job`). Assign Glue IAM Role. Configure arguments for Redshift connection, table name.
6.  **Create Glue Workflow:**
    * Define a workflow (`sales-data-workflow`) that orchestrates the crawlers and jobs in the correct sequence.
    * Include events/triggers between steps (e.g., Crawler 1 finishes -> Job 1 starts).
7.  **Configure SNS Notifications:**
    * Create SNS topic (`sales-data-topic`) for Lambda status, Glue crawler and job success/failure.
    * Configure Lambda, Glue jobs, and crawlers to publish to these SNS topics.
8.  **Create Eventbridge rules:**
    * Create EventBridge rule `start-lambda-rule`, `crawler01-rule`, `job01-rule`, `crawler02-rule` and `job02-rule` with appropriate
      pattern matching and assign respective IAM role.
9. **Set up Redshift:**
    * Ensure your Redshift cluster is running and accessible from Glue via glue connection (`sales-data-redshift-connection`).
    * Create the target table (`sales_data_table`) in Redshift that the `redshift-loader-job` will load data into.

## Usage

1.  **Prepare a CSV File:** Ensure your CSV file has the expected columns.
2.  **Upload to S3:** Upload your CSV file to the S3 input bucket's `input/` prefix:
    `s3://sales-data-etl-project-bucket/input/sample_sales_data.csv`
3.  **Monitor Progress:**
    * Check AWS CloudWatch Logs for your Lambda function.
    * Monitor the Glue Workflow execution in the AWS Glue console.
    * Check your subscribed SNS e-mails for notifications on job status.
4.  **Verify Data in Redshift:**
    Once the Glue workflow completes successfully, query your Redshift table to confirm the data has been loaded.

    ```sql
    SELECT * FROM sales_data_table LIMIT 10;
    ```

---

