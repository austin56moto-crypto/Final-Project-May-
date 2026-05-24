locals {
  lambda_functions = {
    create_task        = "create_task"
    generate_task_ai   = "generate_task_ai"
    list_tasks         = "list_tasks"
    update_task_status = "update_task_status"
    submit_proof       = "submit_proof"
    send_notification  = "send_notification"
    get_current_user   = "get_current_user"
  }
}

resource "aws_lambda_function" "this" {
  for_each = local.lambda_functions

  function_name = "${local.project_name}-${each.key}"
  role          = aws_iam_role.lambda.arn
  handler       = "app.handler"
  runtime       = "python3.12"
  filename      = "${path.module}/../backend-lambda/${each.value}/function.zip"
  timeout       = 30

  source_code_hash = filebase64sha256("${path.module}/../backend-lambda/${each.value}/function.zip")

  environment {
    variables = {
      PROJECT_NAME = local.project_name
      AWS_REGION   = var.aws_region
    }
  }
}

