output "project_name" {
  value = local.project_name
}

output "user_pool_id" {
  value = aws_cognito_user_pool.this.id
}

output "api_base_url" {
  value = "https://${aws_api_gateway_rest_api.this.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.this.stage_name}"
}
