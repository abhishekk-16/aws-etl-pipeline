## crawler rule

These rules are made for crawlers , on crawler state change
("Succeeded", "Failed") they publish in SNS topic.

### crawler01-rule

**Event Pattern**

```json
{
  "source": ["aws.glue"],
  "detail-type": ["Glue Crawler State Change"],
  "detail": {
    "state": ["Succeeded", "Failed"],
    "crawlerName": ["csv_data_reader"]
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
                "arn:aws:sns:ap-south-1:183295412439:OrderNotifiction"
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
                    "aws:SourceArn": "arn:aws:events:ap-south-1:183295412439:rule/crawler01_rule"
                }
            }
        }
    ]
}
```


### crawler02-rule

**Event Pattern**

```json
{
  "source": ["aws.glue"],
  "detail-type": ["Glue Crawler State Change"],
  "detail": {
    "state": ["Succeeded", "Failed"],
    "crawlerName": ["parquet_data_reader"]
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
                "arn:aws:sns:ap-south-1:183295412439:OrderNotifiction"
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
                    "aws:SourceArn": "arn:aws:events:ap-south-1:183295412439:rule/crawler02_rule"
                }
            }
        }
    ]
}
```
