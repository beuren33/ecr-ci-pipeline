variable "project_name" {
  type    = string
  default = "ecr-ci-pipeline"
}
variable "region" {
  type    = string
  default = "us-west-1"
}
variable "ecr_repository" {
  type    = string
  default = "ecr-ci-pipeline-ECR-REPO"
}
variable "github_repository" {
  type    = string
  default = "ecr-ci-pipeline"
}
variable "user_github" {
  type    = string
  default = "beuren33"
}

