output "ecs_instance_ids" {
  description = "ECS实例ID列表"
  value       = alicloud_ecs_instance.lz_ecs.*.id
}

output "ecs_public_ips" {
  description = "ECS公网IP列表（仅测试环境）"
  value       = alicloud_ecs_instance.lz_ecs.*.public_ip_address
}

output "ecs_private_ips" {
  description = "ECS私有IP列表"
  value       = alicloud_ecs_instance.lz_ecs.*.private_ip_address
}

output "security_group_id" {
  description = "ECS安全组ID"
  value       = alicloud_security_group.lz_ecs_sg.id
}
