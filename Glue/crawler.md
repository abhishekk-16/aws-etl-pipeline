## csv-data-reader-crawler

This crawler is created to crawl `sales-data-etl-project-bucket/input/` folder and discover the schema of newly added csv file and create/update table in glue data catalog.

## parquet-data-reader-crawler

This crawler is created to crawl `sales-data-etl-project-bucket/output/` folder and discover the schema of newly added parquet file and create/update table in glue data catalog.

## IAM Role

We are using a common IAM Role `role_for_crawler` for both the crawlers.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::sales-data-etl-project-bucket",
                "arn:aws:s3:::sales-data-etl-project-bucket/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "glue:CreateTable",
                "glue:UpdateTable",
                "glue:DeleteTable",
                "glue:GetTable",
                "glue:GetTables",
                "glue:BatchCreatePartition",
                "glue:CreatePartition",
                "glue:UpdatePartition",
                "glue:DeletePartition",
                "glue:GetPartition",
                "glue:GetPartitions",
                "glue:BatchDeletePartition",
                "glue:GetDatabase",
                "glue:GetDatabases",
                "glue:CreateDatabase",
                "glue:UpdateDatabase",
                "glue:DeleteDatabase"
            ],
            "Resource": [
                "arn:aws:glue:ap-south-1:183295412439:catalog",
                "arn:aws:glue:ap-south-1:183295412439:database/db-01",
                "arn:aws:glue:ap-south-1:183295412439:database/*",
                "arn:aws:glue:ap-south-1:183295412439:table/db-01/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:ap-south-1:183295412439:log-group:/aws/glue/crawlers/*"
        }
    ]
}
```

Trust Relationship

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "glue.amazonaws.com"
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                  "ArnEquals": {
                       "aws:SourceArn": [
                              "arn:aws:glue:ap-south-1:183295412439:crawler/csv_data_reader",
                              "arn:aws:glue:ap-south-1:183295412439:crawler/parquet_data_reader"
                        ]
                   },
                   "StringEquals": {
                        "aws:SourceAccount": "183295412439"
                   }
             }
        }
    ]
}
```

---
