variable "vpc_id" {
  type        = string
  description = "ID of the VPC where EKS will be deployed"
}

variable "subnets" {
  type        = list(string)
  description = "List of private subnet IDs for EKS nodes"
}
