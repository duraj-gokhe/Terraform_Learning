variable "function_name" {
  type = string
  default = "Terraform_Testing"
}

variable "role_name" {
  type = string
  default = "arn:aws:iam::932651600498:role/service-role/document_upload-role-36txp8cb"
}

variable "source_file_name" {
  type = string
  default = "Testing.py"
}

variable "output_path" {
  type = string
  default = "lambda_function.zip"
}

variable "handler_name" {
  type = string
  default = "Testing.lambda_function"
}

variable "lambda_description" {
  type = string
  default = "This is testing lambda for terraform pipeline"
}

variable "s3_bucket_name" {
  type = string
  default = "terraform-testingduraj"
}

variable "secret_manager_name" {
  type = string
  default = "Terraform_Testing_secret_mnager"
}

variable "secret_manager_description" {
  type = string
  default = "terraform testing secrets"
}

variable "secret_manager_name_username" {
  type = string
  default = "Testing"
}

variable "secret_manager_name_password" {
  type = string
  default = "Testing@1234"
}

variable "github" {
  type = string
  default = "Terraform_Learning"
}