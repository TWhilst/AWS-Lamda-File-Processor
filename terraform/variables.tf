#Create Variables
variable "function_name" {
  default = ""
}
variable "handler_name" {
  default = ""
}
variable "runtime" {
  default = ""
}
variable "timeout" {
  default = ""
}
variable "sender_email" {
  default = ""
}
variable "receiver_email" {
  default = ""
}

variable "lambda_role_name" {
  default = ""
}

variable "lambda_s3_iam_policy_name" {
  default = ""
}

variable "lambda_api_iam_policy_name" {
  default = ""
}

variable "bucket_name" {
  default = ""
}

variable "environment" {
  default = "dev"
}

variable "vpc_id" {
  default = ""
}

variable "subnet_id" {
  default = ""
}

variable "key_name" {
  default = ""
}

variable "public_key" {
  default = ""
}

variable "jenkins_sh" {
  default = ""
}

variable "slave_sh" {
  default = ""
}