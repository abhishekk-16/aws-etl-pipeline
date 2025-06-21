## sales-data-etl-project-bucket rule

**Event Pattern**

```json
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "detail": {
    "bucket": {
      "name": ["sales-data-etl-project-bucket"]
    }
  }
}
```
