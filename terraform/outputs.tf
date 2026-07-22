output "repo_ecr" {
  value = aws_ecr_repository.ecr.repository_url
}
output "arn_iam" {
  value = aws_iam_role.ecr_github_role.arn
}