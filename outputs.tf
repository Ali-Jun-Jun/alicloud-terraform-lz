# 基础层输出
output "vpc_id" {
  description = "Landing Zone VPC ID"
  value       = module.foundation_vpc.vpc_id
}

output "private_subnet_ids" {
  description = "私有子网ID列表"
  value       = module.foundation_vpc.private_subnet_ids
}

output "ram_role_name" {
  description = "ECS RAM角色名"
  value       = module.foundation_ram.ram_role_name
}

# 业务层输出
output "ecs_instance_ids" {
  description = "ECS实例ID列表"
  value       = module.business_ecs.ecs_instance_ids
}

output "ecs_private_ips" {
  description = "ECS私有IP列表"
  value       = module.business_ecs.ecs_private_ips
}

output "security_group_id" {
  description = "ECS安全组ID"
  value       = module.business_ecs.security_group_id
}
