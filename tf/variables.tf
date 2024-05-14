variable "vpc_id" {
  description = "The VPC ID where resources will be created."
  type        = string
  default = "vpc-024cf058980b63412"
}

variable "subnet_id" {
  description = "The Subnet ID where the EC2 instance will be created."
  type        = string
  default = "subnet-07549c87757e073ea"
}

variable "allowed_ssh_cidr" {
  description = "The CIDR block allowed for SSH access."
  type        = string
  default = "147.161.130.205/32"
}

variable "bucket_name" {
  description = "The name of the S3 bucket to create."
  type        = string
  default = "qnt-bucket-karim-akhmediyev"
}

variable "ami_name" {
  description = "The name pattern of the AMI to use."
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
}