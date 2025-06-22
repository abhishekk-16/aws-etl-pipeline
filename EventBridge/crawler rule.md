## crawler rule

These rules are made for crawlers , on crawler state change
("Succeeded", "Failed") they publish in SNS topic.

### crawler-01-rule

**Event Pattern**

```json
{
  "source": ["aws.glue"],
  "detail-type": ["Glue Crawler State Change"],
  "detail": {
    "state": ["Succeeded", "Failed"],
    "crawlerName": ["csv-data-reader"]
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
                "arn:aws:sns:ap-south-1:183295412439:sales-data-topic"
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
                    "aws:SourceArn": "arn:aws:events:ap-south-1:183295412439:rule/crawler-01-rule"
                }
            }
        }
    ]
}
```


### crawler-02-rule

**Event Pattern**

```json
{
  "source": ["aws.glue"],
  "detail-type": ["Glue Crawler State Change"],
  "detail": {
    "state": ["Succeeded", "Failed"],
    "crawlerName": ["parquet-data-reader"]
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
                "arn:aws:sns:ap-south-1:183295412439:sales-data-topic"
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
                    "aws:SourceArn": "arn:aws:events:ap-south-1:183295412439:rule/crawler-02-rule"
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
  "Message": "$.detail.message",
  "compeletion": "$.detail.completionDate",
  "crawlerName": "$.detail.crawlerName",
  "status": "$.detail.state",
  "warningMessage": "$.detail.warningMessage"
}
```

**Template**

```json
{
  "Crawler Notification":
  {
    "Crawler-Name":"<crawlerName>",
    "Status":"<status>",
    "Warning":"<warningMessage>",
    "Message":"<Message>",
    "Completion":"<compeletion>"
  }
}
```
