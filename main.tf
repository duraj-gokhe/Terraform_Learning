data "archive_file" "lambda"{
    type = "zip"
    source_file = var.source_file_name
    output_path = var.output_path
}

# lambda creation
resource "aws_lambda_function" "Test" {
    filename = data.archive_file.lambda.output_path
    function_name = var.function_name
    role = var.role_name
    handler = var.handler_name
    description = var.lambda_description

    source_code_hash = data.archive_file.lambda.output_base64sha256
    runtime = "python3.12"
}

# s3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name
}

#  secret manager
resource "aws_secretsmanager_secret" "Terraform_Testing" {
  name = var.secret_manager_name
  description = var.secret_manager_description
}

resource "aws_secretsmanager_secret_version" "Terraform_Learning" {
  secret_id = aws_secretsmanager_secret.Terraform_Testing.name
  secret_string = jsonencode({
    username = var.secret_manager_name_username
    password = var.secret_manager_name_password
  })
}

# API gateway
resource "aws_api_gateway_rest_api" "api_endpoint" {
  name = "hello_world"
  description = "API for Test"
}

resource "aws_api_gateway_resource" "resource_name" {
  parent_id = aws_api_gateway_rest_api.api_endpoint.root_resource_id
  path_part = "demo"
  rest_api_id = aws_api_gateway_rest_api.api_endpoint.id
}

resource "aws_api_gateway_method" "GET" {
  authorization = "None"
  http_method = "GET"
  resource_id = aws_api_gateway_resource.resource_name.id
  rest_api_id = aws_api_gateway_rest_api.api_endpoint.id
}

# Integration with lambda
resource "aws_api_gateway_integration" "lambda_integration" {
  http_method = aws_api_gateway_method.GET.http_method
  resource_id = aws_api_gateway_resource.resource_name.id
  rest_api_id = aws_api_gateway_rest_api.api_endpoint.id
  type = "AWS"
  integration_http_method = "GET"
  uri = aws_lambda_function.Test.invoke_arn
}

#  API Deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_endpoint.id
  stage_name = "dev"

  triggers = {
    redeployment = sha1(jsonencode([
        aws_api_gateway_resource.resource_name.id,
        aws_api_gateway_method.GET.id,
        aws_api_gateway_integration.lambda_integration.id

    ]))
  }
}

resource "github_repository" "terraform" {
  name = var.github
  description = "This repo is created by terraform while learning"
  visibility = "public"
}