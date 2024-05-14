terraform {
  backend "s3" {
    bucket = "qnt-clouds-for-pe-tfstate"
    key    = "karim-akhmediyev/terraform.tfstate"
    region = "us-east-2"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name]
  }

  owners = ["099720109477"]
}



resource "aws_security_group" "karim_akhmediyev_sg" {
  name        = "karim_akhmediyev_sg"
  description = "Allow SSH and app traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_s3_bucket" "qnt_bucket" {
  bucket = var.bucket_name
}


resource "aws_iam_policy" "s3_full_access_policy" {
  name        = "s3-terraform-karim-akhmediyev"
  description = "Provides full access to S3 bucket"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::${var.bucket_name}/*",
          "arn:aws:s3:::${var.bucket_name}"
        ]
      }
    ]
  })
}


resource "aws_iam_role" "ec2_s3_full_access_role" {
  name = "ec2_s3_full_access_role_karim_akhmediyev"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "s3_full_access_attachment" {
  role       = aws_iam_role.ec2_s3_full_access_role.name
  policy_arn = aws_iam_policy.s3_full_access_policy.arn
}


resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile_karim_akhmediyev"
  role = aws_iam_role.ec2_s3_full_access_role.name
}


resource "aws_instance" "karim_akhmediyev_ec2_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3a.small"
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true

  security_groups = [aws_security_group.karim_akhmediyev_sg.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              # Install packages
              EOF

  tags = {
    Name    = "karim_akhmediyev_ec2_instance"
    env     = "dev"
    owner   = "karim.akhmediyev@quantori.com"
    project = "INFRA"
  }
}


resource "aws_ec2_instance_state" "karim_akhmediyev_ec2_instance" {
  instance_id = aws_instance.karim_akhmediyev_ec2_instance.id
  state       = "stopped"
}
