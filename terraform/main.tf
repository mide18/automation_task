# configurations
terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~>4.0"
      }
    }
    # used to persist vault data i.e the tfstate
    backend "s3" {
      bucket = "terraformtfstate-buckets"
      key = "aws/ec2-deploy/terraform.tfstate"
      region = "us-east-1"

      # Replace this with your DynamoDB table name!
    # dynamodb_table = "oaterraform-bucket-test-locks"
    # encrypt        = true
    }
}

provider "aws" {
  region = "us-east-1"
}


# ec2 launch script
resource "aws_instance" "node_instance" {
  ami              = data.aws_ssm_parameter.instance_ami.value
  instance_type    = "t2.micro"
  key_name         = aws_key_pair.deployer.key_name
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
    "Name" = "node_instance"
  }
}

# ec2 SG
resource "aws_security_group" "node_security_grp" {
  description        = "allow inbound traffic to instance"

   ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

   ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "NodeSG"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.public_key
}

# Ec2 IAM role
resource "aws_iam_instance_profile" "ec2-profiles" {
    name = "ec2-profiles"
    role = "EC2_ECR_Role_access"
}
