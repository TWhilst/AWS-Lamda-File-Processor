# Creating s3 resource for invoking to lambda function
# resource "aws_s3_bucket" "bucket" {
#   bucket = var.bucket_name

#   tags = {
#     Environment = var.environment
#   }
# }

resource "aws_s3_bucket_public_access_block" "bucket_pab" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Adding S3 bucket as trigger to my lambda and giving the permissions
resource "aws_s3_bucket_notification" "aws_lambda_trigger" {
  bucket = aws_s3_bucket.bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.serverless_lambda_function.arn
    events              = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]

  }
  depends_on            = [aws_lambda_permission.allow_s3_invoke]
} 
