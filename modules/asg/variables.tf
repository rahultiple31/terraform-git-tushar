variable "asg_name" {}
variable "lt_name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "subnets" { type = list(string) }
variable "security_groups" { type = list(string) }
variable "min_size" {}
variable "max_size" {}
variable "desired_capacity" {}
variable "target_group_arn" {}
variable "user_data" { default = "" }
