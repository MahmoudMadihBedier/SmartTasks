provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "smarttasks_bucket" {
  bucket = "smarttasks-bucket"
  acl    = "private"
}

resource "aws_dynamodb_table" "tasks_table" {
  name         = "Tasks"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "id"
    type = "S"
  }
  attribute {
    name = "project_id"
    type = "S"
  }
  global_secondary_index {
    name               = "ProjectIndex"
    hash_key           = "project_id"
    projection_type    = "ALL"
  }
}

resource "aws_lambda_function" "tasks_lambda" {
  function_name = "tasks_function"
  handler       = "app.handler"
  runtime       = "python3.8"
  s3_bucket     = aws_s3_bucket.smarttasks_bucket.bucket
  s3_key        = "lambda_function.zip"
}

resource "aws_api_gateway_rest_api" "smarttasks_api" {
  name        = "SmartTasks API"
  description = "API for SmartTasks application"
}

resource "aws_api_gateway_resource" "tasks" {
  rest_api_id = aws_api_gateway_rest_api.smarttasks_api.id
  parent_id   = aws_api_gateway_rest_api.smarttasks_api.root_resource_id
  path_part   = "tasks"
}

resource "aws_api_gateway_method" "get_tasks" {
  rest_api_id   = aws_api_gateway_rest_api.smarttasks_api.id
  resource_id   = aws_api_gateway_resource.tasks.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "tasks_integration" {
  rest_api_id             = aws_api_gateway_rest_api.smarttasks_api.id
  resource_id             = aws_api_gateway_resource.tasks.id
  http_method             = aws_api_gateway_method.get_tasks.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.tasks_lambda.invoke_arn
}

output "api_endpoint" {
  value = "${aws_api_gateway_rest_api.smarttasks_api.execution_arn}/tasks"
}