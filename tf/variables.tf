variable "vpc_id" {
  description = "The VPC ID where resources will be created."
  type        = string
}

variable "subnet_id" {
  description = "The Subnet ID where the EC2 instance will be created."
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "The CIDR block allowed for SSH access."
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket to create."
  type        = string
}

variable "ami_name" {
  description = "The name pattern of the AMI to use."
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
}