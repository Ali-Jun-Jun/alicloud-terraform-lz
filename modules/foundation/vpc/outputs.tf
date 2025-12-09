output "vpc_id" {
  description = "Landing Zone VPC ID"
  value       = alicloud_vpc.lz_vpc.id
}

output "private_subnet_ids" {
  description = "私有子网ID列表"
  value       = alicloud_vswitch.private_subnet.*.id
}

output "public_subnet_id" {
  description = "公网子网ID（NAT网关用）"
  value       = alicloud_vswitch.public_subnet.*.id[0]
}

output "route_table_id" {
  description = "私有子网路由表ID"
  value       = alicloud_route_table.private_route.id
}

output "nat_gateway_id" {
  description = "NAT网关ID（仅生产环境）"
  value       = var.env == "prod" ? alicloud_nat_gateway.lz_nat[0].id : ""
}
