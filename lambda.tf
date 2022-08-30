module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "buildkite-user-audit-lambda"
  description   = "My awesome lambda function"
  create_package = false

  image_uri    = ".dkr.ecr.us-east-1.amazonaws.com/docker-lambda:latest"
  package_type = "Image"
  timeout                           = 240
  memory_size                       = 512
  architectures                     = ["x86_64"]  
  use_existing_cloudwatch_log_group = false
  cloudwatch_logs_retention_in_days = 7
  cloudwatch_logs_tags              = {
    Name = "buildkite-user-audit-lambda"
  }

  tags = {
    Name = "buildkite-user-audit-lambda"
  }
}