## start-lambda-rule

This EventBridge rule will invoke `start-workflow-function` Lambda function when new objects are added in `sales-data-etl-project` S3 bucket.

**Event Pattern**

```json
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "detail": {
    "bucket": {
      "name": ["sales-data-etl-project"]
    }
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
                "lambda:InvokeFunction"
            ],
            "Resource": [
                "arn:aws:lambda:ap-south-1:183295412439:function:start-workflow-function"
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
                    "aws:SourceArn": "arn:aws:events:ap-south-1:183295412439:rule/start-lambda-rule"
                }
            }
        }
    ]
}
```

* While creating the rule select `Matched events` in configure target input.
