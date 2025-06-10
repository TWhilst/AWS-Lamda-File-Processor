# Creating Lambda IAM resource role for lambda
resource "aws_iam_role" "lambda_iam" {
  name = var.lambda_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attaching lambda iam role to s3 policy
resource "aws_iam_role_policy" "attach_lambda_role_to_s3_policy" {
  name = var.lambda_s3_iam_policy_name
  role = aws_iam_role.lambda_iam.id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}

# Attaching lambda iam role to cloudwatch policy
resource "aws_iam_role_policy" "attach_lambda_role_to_api_gateway_policy" {
  name = var.lambda_api_iam_policy_name
  role = aws_iam_role.lambda_iam.id

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}

# Creating Lambda resource
resource "aws_lambda_function" "serverless_lambda_function" {
  function_name    = var.function_name
  role             = aws_iam_role.lambda_iam.arn
  handler          = "${var.handler_name}.lambda_handler"
  runtime          = var.runtime
  timeout          = var.timeout
  filename         = "../src/lambda_function.zip"
  source_code_hash = data.archive_file.zip_lambda_function.output_base64sha256
  environment {
    variables = {
      env            = var.environment
    }
  }
}

resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.serverless_lambda_function.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket.arn
}