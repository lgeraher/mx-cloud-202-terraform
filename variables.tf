variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "project_name" {
  type = string
}

variable "key_name" {
  type = string
}

variable "front_01_dns" {
  type    = string
  default = "front-01.aws.itexico.com"
}

variable "front_02_dns" {
  type    = string
  default = "front-02.aws.itexico.com"
}
