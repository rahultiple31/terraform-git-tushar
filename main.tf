provider "aws" {
  region = var.region
}

# --------------------------- VPC MODULE ---------------------------

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  azs                  = var.azs
}

# --------------------------- SECURITY GROUPS ---------------------------

resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

# --------------------------- EC2 MODULE ---------------------------

module "ec2" {
  source          = "./modules/ec2"
  ami_id          = var.ami_id
  instance_type   = "t3.micro"
  subnet_id       = module.vpc.public_subnets[0]
  security_groups = [aws_security_group.app_sg.id]
  user_data       = file("user_data.sh")
}

# --------------------------- ALB MODULE ---------------------------

module "alb" {
  source          = "./modules/alb"
  alb_name        = "demo-alb"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.app_sg.id]
  target_group_port = 80
}

# --------------------------- ASG MODULE ---------------------------

module "asg" {
  source            = "./modules/asg"
  asg_name          = "demo-asg"
  lt_name           = "demo-lt"
  ami_id            = var.ami_id
  instance_type     = "t3.micro"
  subnets           = module.vpc.public_subnets
  security_groups   = [aws_security_group.app_sg.id]
  min_size          = 2
  max_size          = 4
  desired_capacity  = 2
  target_group_arn  = module.alb.target_group_arn
  user_data         = file("user_data.sh")
}