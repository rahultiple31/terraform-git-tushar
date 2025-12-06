variable "alb_name" {}
variable "security_groups" { type = list(string) }
variable "subnets" { type = list(string) }
variable "vpc_id" {}
variable "target_group_port" { default = 80 }
