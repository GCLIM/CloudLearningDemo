variable "AWS_REGION" {
  default = "ap-northeast-1"
}

#AZs map
variable "AZ_MAP" {
  type = map
  default = {
    "ap-northeast-1" = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  }
}

#VPC CIDR Block
variable "VPC_CIDR_BLOCK" {
  default = ["10.2.0.0/16"]
}

#VPC Public Subnets
variable "VPC_PUBLIC_SUBNETS" {
  default = ["10.2.1.0/24", "10.2.2.0/24"]
}

#CloudLearningGroup tag
variable "CLOUD_LEARNING_GROUP" {
  default = "9"
}