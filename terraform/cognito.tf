resource "aws_cognito_user_pool" "this" {
  name = "${local.project_name}-users"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]
  mfa_configuration        = "OFF"
  deletion_protection      = "INACTIVE"

  tags = local.tags
}

resource "aws_cognito_user_pool_client" "this" {
  name         = "${local.project_name}-app-client"
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret                      = false
  explicit_auth_flows                  = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
  prevent_user_existence_errors        = "ENABLED"
  supported_identity_providers         = ["COGNITO"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  callback_urls                        = ["http://localhost:3000/callback"]
  logout_urls                          = ["http://localhost:3000/logout"]
}

resource "aws_cognito_user_group" "admin" {
  name         = "admin"
  user_pool_id = aws_cognito_user_pool.this.id
  description  = "System administrators"
}

resource "aws_cognito_user_group" "instructor" {
  name         = "instructor"
  user_pool_id = aws_cognito_user_pool.this.id
  description  = "Instructors who create and review tasks"
}

resource "aws_cognito_user_group" "intern" {
  name         = "intern"
  user_pool_id = aws_cognito_user_pool.this.id
  description  = "Interns who complete assigned tasks"
}

