output "ram_role_name" {
  description = "Landing Zone ECS RAM角色名"
  value       = alicloud_ram_role.lz_ecs_role.name
}

output "ram_role_arn" {
  description = "Landing Zone ECS RAM角色ARN"
  value       = alicloud_ram_role.lz_ecs_role.arn
}
