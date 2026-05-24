resource "aws_sns_topic" "task_assignment" {
  name = "${local.project_name}-task-assignment"
}

resource "aws_sns_topic" "submission" {
  name = "${local.project_name}-submission"
}

resource "aws_sns_topic" "reminder" {
  name = "${local.project_name}-reminder"
}

