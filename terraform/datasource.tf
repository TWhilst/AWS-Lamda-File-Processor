data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners          = ["099720109477"]

  filter {
    name            = "name"
    values          = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

}

/// Aws Subnet Datasource
data "aws_subnet" "public_subnet" {

  vpc_id = var.vpc_id
  
  filter {
    name   = "subnet-id"
    values = ["${var.subnet_id}"]
  }
}

# // This is a Terraform data source to create an IAM policy document for the Lambda function
# data "aws_iam_policy_document" "lambda_role" {
#   version = "2012-10-17"
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }

  
# }

# data "aws_iam_policy_document" "policy_for_lambda" {
#   version   = "2012-10-17"
#   statement {
#     effect  ="Allow"

#     actions = [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents",
#     ]
#     resources  = ["*"]
#   }
#   # version = "2012-10-17"
#   # statement {
#   #     effect ="Allow"
#   #     actions = [
#   #         "s3:Get*",
#   #         "s3:List*",
#   #         "s3:Describe*",
#   #         "s3-object-lambda:Get*",
#   #         "s3-object-lambda:List*",
#   #     ]
#   #     resources = ["arn:aws:s3:::aws-lambda-project3-s3-bucket/*"]
#   # }
# }

// This is a Terraform data source to create a zip file for the Lambda function
data "archive_file" "zip_lambda_function" {
  type        = "zip"
  source_file = "../src/lambda_function.py"
  output_path = "../src/lambda_function.zip"
}


