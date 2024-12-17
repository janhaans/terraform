# Trigger a Lambda Function by a S3 event

This terraform configuration:

- Create a S3 Bucket
- Create a Lambda Function
- Feature is:

```
When a new object has been uploaded in the S3 Bucket
Then the S3 Bucket invokes the Lambda Function
And the Lambda Function prints the name of the S3 Bucket
And the Lambda Function print the name of the uploaded object
```
