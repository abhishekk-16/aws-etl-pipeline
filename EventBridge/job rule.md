## job rule

These rules are made for Glue ETL jobs, on job state change ("SUCCEEDED", "FAILED") they publish in SNS topic.

### job01-rule

**Event Pattern**

```json
{
  "source": ["aws.glue"],
  "detail-type": ["Glue Job State Change"],
  "detail": {
    "state": ["SUCCEEDED", "FAILED"],
    "jobName": ["csv-to-parquet-job"]
  }
}
```

**IAM Role**

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": [
                "arn:aws:sns:ap-south-1:183295412439:ETL-Notification"
            ]
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
                "Service": "events.amazonaws.com"
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals":{
                    "aws:SourceAccount": "183295412439"
                },
                "ArnEquals": {
                    "aws:SourceArn": "arn:aws:events:ap-south-1:183295412439:rule/job01_rule"
                }
            }
        }
    ]
}
```

## job02-rule

**Event Pattern**

```json
{
  "source": ["aws.glue"],
  "detail-type": ["Glue Job State Change"],
  "detail": {
    "state": ["SUCCEEDED", "FAILED"],
    "jobName": ["redshift-loader-job"]
  }
}
```

**IAM Role**

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": [
                "arn:aws:sns:ap-south-1:183295412439:ETL-Notification"
            ]
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
                "Service": "events.amazonaws.com"
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals":{
                    "aws:SourceAccount": "183295412439"
                },
                "ArnEquals": {
                    "aws:SourceArn": "arn:aws:events:ap-south-1:183295412439:rule/job02_rule"
                }
            }
        }
    ]
}
```


* While creating both the rule select `Input transformer` in configure target input.
* Configure Input Transformer with following:

**Input Path**

```json
{
  "jobName": "$.detail.jobName",
  "message": "$.detail.message",
  "status": "$.detail.state",
  "time": "$.time"
}
```

**Template**

```json
{
  "Glue Job Notification":
  {
    "Job Name": "<jobName>",
    "Status": "<status>",
    "Time": "<time>",
    "Message": "<message>"
    }
}
```
