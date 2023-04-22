# Terraform script used to provision ec2 on AWS and store the terraform.tfstate file remotely on S3

# Terraform block: This allows interaction with AWS api
terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~>4.0"
      }
    }

    # used to persist tfstate remotely in s# and possible collaboration i.e the tfstate in AWS S3

    backend "s3" {
      bucket = "terraformtfstate-buckets"         // bucket name to be stored
      key = "aws/ec2-deploy/terraform.tfstate"    //path the tfstate to be stored
      region = "us-east-1"                        //location of the bucket
    }
}

# default region to provision the infrastructure
provider "aws" {
  region = "us-east-1"
}


# EC2 launch script
resource "aws_instance" "node_instance" {
  ami              = data.aws_ssm_parameter.instance_ami.value
  instance_type    = "t2.micro"
  key_name         = aws_key_pair.deployer.key_name       //key pair referenced to enable ssh into the server
  vpc_security_group_ids = [aws_security_group.node_security_grp.id]
  iam_instance_profile = aws_iam_instance_profile.ec2-profiles.name
  connection  {
    type = "ssh"
    host = self.public_ip
    private = var.private_key
    user = "ubuntu"
    time_out = "4m"
  }
   
  tags = {
    "Name" = "task_node"      //tag name of the instance
  }
}

# Security group attached to the instance
resource "aws_security_group" "node_security_grp" {
  description        = "allow inbound traffic to instance"
egress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]

  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
     {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 8080
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 8080
    },
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    }
  ]

  tags = {
    Name = "NodeSG"
  }
}

# Create the key pair to ssh into the EC2
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.public_key
}

# Ec2 IAM role to have access to ECR
resource "aws_iam_instance_profile" "ec2-profiles" {
    name = "ec2-profiles"
    role = "EC2_ECR_Role_access"
}

//Prints out the IP after launch
output "instance_public_ip" {
  value     = aws_instance.node_instance.public_ip
  sensitive = true
}