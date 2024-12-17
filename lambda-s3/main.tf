# S3 Bucket
resource "aws_s3_bucket" "s3_example" {
    bucket = var.bucket_name
}

# Lambda Execution Role
resource "aws_iam_role" "lambda_role" {
    name = "lambda_s3_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
}

# Custom IAM Policy for Read-Only Access to S3 Bucket
resource "aws_iam_policy" "lambda_policy" {
    name = "lambda_s3_policy"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "s3:GetObject",
                    "s3:ListBucket"
                ]
                Effect = "Allow"
                Resource = [
                    aws_s3_bucket.s3_example.arn,
                    "${aws_s3_bucket.s3_example.arn}/*"
                ]
            }
        ]
    })
}

# Attach the IAM Policy to the Lambda Execution Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.lambda_policy.arn
}

# Attach the AWS Managed Policy for Lambda Execution to the Lambda Execution Role 
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function 
resource "aws_lambda_function" "s3_trigger_lambda" {
    function_name    = "s3_trigger_lambda"
    role             = aws_iam_role.lambda_role.arn
    handler          = "lambda-function.lambda_handler"
    runtime          = "python3.12"

    #Zip file containing the Lambda function code
    filename         = "lambda-function.zip"
    source_code_hash = filebase64sha256("lambda-function.zip")
}

# Lambda Permission to Allow S3 to Invoke the Lambda Function
resource "aws_lambda_permission" "allow_s3_to_invoke" {
    statement_id  = "AllowExecutionFromS3"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.s3_trigger_lambda.function_name
    principal     = "s3.amazonaws.com"
    source_arn    = aws_s3_bucket.s3_example.arn
}

# S3 Bucket Notification Configuration
resource "aws_s3_bucket_notification" "bucket_notification" {
    bucket = aws_s3_bucket.s3_example.id

    lambda_function {
        lambda_function_arn = aws_lambda_function.s3_trigger_lambda.arn
        events              = ["s3:ObjectCreated:*"]
    }
}

output "lambda_function_name" {
  value = aws_lambda_function.s3_trigger_lambda.function_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.s3_example.bucket
}
