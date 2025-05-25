variable "vpc_id" {
    type     = string
    default  = "vpc-0b16e539a6d9d52b8"
    description = "main VPC ID"
}

/// Vpc id data
data "aws_vpc" "Project1" {
  id                = var.vpc_id
}

resource "aws_security_group" "Project1_sg_jenkins_agent" {
  name        = "main-sg-jenkins-agent"
  description = "allow access to Jenkins agent"
  vpc_id      = data.aws_vpc.Project1.id

  ingress {
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

/// Aws Subnet Datasource
data "aws_subnet" "public_subnet_b" {

  vpc_id = data.aws_vpc.Project1.id
  tags = {
    Name = "main-public-b"
  }
  
  filter {
    name   = "state"
    values = ["available"]
  }
}

output "public_subnet_id" {
  value = data.aws_subnet.public_subnet_b.id
}


/// Aws Security Group Datasource
data "aws_security_group" "Project1_sg_jenkins" {
    name   = "main-sg-jenkins"
}

data "aws_security_group" "Project1_sg_ssh" {
    name   = "main-sg-ssh"
}

/// EC2 Instance
resource "aws_instance" "ansible_instance" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = "t2.medium"
  key_name      = "toche-key1"
  subnet_id     = data.aws_subnet.public_subnet_b.id
  vpc_security_group_ids = [data.aws_security_group.Project1_sg_ssh.id, data.aws_security_group.Project1_sg_jenkins.id, 
                            aws_security_group.Project1_sg_jenkins_agent.id]
  user_data = file("~/.vscode/AWS-Lamda-File-Processor/ansible.sh")

  tags = {
    Name = "jenkins-master-agent"
  }
}

resource "aws_s3_bucket" "Project3_bucket" {
  bucket = "aws-lambda-project3-s3-bucket11"
  force_destroy = true

  tags = {
    Name        = "project3-bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "Project3_bucket_pab" {
  bucket = aws_s3_bucket.Project3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role" "attach_role_to_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_role.json
}

resource "aws_iam_policy" "attach_policy_to_lambda" {
  name               = "aws_iam_pollicy_for_s3_bucket"
  path               = "/"
  description        = "IAM policy for Lambda to access S3 bucket"
  policy = data.aws_iam_policy_document.policy_for_lambda.json
}

# resource "aws_iam_policy_attachment" "attach_policy_to_iam_role" {
#   name               = "s3-policy-attachment"
#   roles               = [aws_iam_role.attach_role_to_lambda.name]
#   policy_arn         = aws_iam_policy.attach_policy_to_s3_bucket.arn
# }

resource "aws_iam_policy_attachment" "attach_policy_to_lambda_role" {
  name               = "lambda-policy-attachment"
  roles              = [aws_iam_role.attach_role_to_lambda.name]
  policy_arn         = aws_iam_policy.attach_policy_to_lambda.arn
}
resource "aws_lambda_function" "lambda_function" {
  function_name = "severless-lambda-function1"
  s3_bucket    = aws_s3_bucket.Project3_bucket.bucket
  s3_key       = aws_s3_object.lambda_function.key
  role          = aws_iam_role.attach_role_to_lambda.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  source_code_hash = data.archive_file.zip_lambda_function.output_base64sha256
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
  retention_in_days = 14
}

resource "aws_s3_object" "lambda_function" {
  bucket = aws_s3_bucket.Project3_bucket.id
  key    = "lambda_function.zip"
  source = data.archive_file.zip_lambda_function.output_path
  etag   = filemd5(data.archive_file.zip_lambda_function.output_path)
}
