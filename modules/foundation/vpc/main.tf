variable "env" {
  description = "部署环境（dev/prod）"
  type        = string
}
variable "vpc_cidr" {
  description = "VPC网段"
  type        = string
  default     = "172.16.0.0/16"
}
# 创建企业级VPC
resource "alicloud_vpc" "lz_vpc" {
  vpc_name   = "lz-${var.env}-vpc"
  cidr_block = var.vpc_cidr
  tags = {
    Env       = var.env
    ManagedBy = "HCP-Terraform"
    Module    = "Landing-Zone"
  }
}
# 创建私有子网（业务资源部署在此）
resource "alicloud_vswitch" "private_subnet" {
  count      = 2
  vpc_id     = alicloud_vpc.lz_vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
  zone_id    = ["cn-shenzhen-b", "cn-shenzhen-c"][count.index]
  vswitch_name = "lz-${var.env}-private-subnet-${count.index}"
}
# 生产环境强制部署NAT网关（禁止ECS直连公网）
resource "alicloud_nat_gateway" "lz_nat" {
  count             = var.env == "prod" ? 1 : 0
  vpc_id            = alicloud_vpc.lz_vpc.id
  nat_gateway_name  = "lz-${var.env}-nat"
  specification     = "Standard"
}
