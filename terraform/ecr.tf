resource "aws_ecr_repository" "fargatetest" {
  name = "${var.project_name}"
}
