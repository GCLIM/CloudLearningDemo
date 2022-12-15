output "vpc_id" {
    description = "VPC ID"
    value = module.cloudLearning9-vpc.vpc_id
}

output "public_subnet_id_01" {
    description = "Subnet ID of First Public Subnet"
    value = module.cloudLearning9-vpc.public_subnets[0]
}

output "public_subnet_id_02" {
    description = "Subnet ID of Second Public Subnet"
    value = module.cloudLearning9-vpc.public_subnets[1]
}

output "public_subnet_id_01_AZ" {
    description = "AZ of First Public Subnet"
    value = var.AZ_MAP[var.AWS_REGION][0]
}

output "public_subnet_id_02_AZ" {
    description = "AZ of Second Public Subnet"
    value = var.AZ_MAP[var.AWS_REGION][1]
}

