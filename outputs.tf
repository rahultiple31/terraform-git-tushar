output "alb_dns" { value = module.alb.alb_dns_name }
output "ec2_id" { value = module.ec2.instance_id }
output "vpc_id" { value = module.vpc.vpc_id }