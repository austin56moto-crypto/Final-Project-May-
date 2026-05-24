resource "aws_cloudwatch_log_group" "lambda" {
  for_each          = local.lambda_functions
  name              = "/aws/lambda/${local.project_name}-${each.key}"
  retention_in_days = 14
}

