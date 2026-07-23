variable "project_name" {
  type    = string
  default = "ecr-ci-pipeline"
}
variable "region" {
  type    = string
  default = "us-east-1"
}
variable "ecr_repository" {
  type    = string
  default = "ecr-ci-pipeline"
}
variable "github_repository" {
  type    = string
  default = "ecr-ci-pipeline"
}
variable "user_github" {
  type    = string
  default = "beuren33"
}

