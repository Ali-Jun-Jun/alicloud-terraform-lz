# 阿里云VPC基础模块 - Landing Zone核心网络资源
resource "alicloud_vpc" "lz_vpc" {
  vpc_name   = "lz-${var.env}-vpc"
  cidr_block = var.vpc_cidr
  description = "Landing Zone ${var.env}环境VPC（Terraform管理）"
  tags = {
    Env        = var.env
    ManagedBy  = "HCP-Terraform"
    LandingZone = "Standard"
    BusinessUnit = var.business_unit
  }
}

# 私有子网（业务资源部署，无公网IP）
resource "alicloud_vswitch" "private_subnet" {
  count         = length(var.zone_ids)
  vpc_id        = alicloud_vpc.lz_vpc.id
  cidr_block    = cidrsubnet(var.vpc_cidr, 8, count.index) # 子网网段自动划分
  zone_id       = var.zone_ids[count.index]
  vswitch_name  = "lz-${var.env}-private-subnet-${count.index}"
  tags = {
    Env        = var.env
    ManagedBy  = "HCP-Terraform"
    SubnetType = "Private"
  }
}

# 公网子网（仅用于NAT网关，无业务资源）
resource "alicloud_vswitch" "public_subnet" {
  count         = 1
  vpc_id        = alicloud_vpc.lz_vpc.id
  cidr_block    = cidrsubnet(var.vpc_cidr, 8, length(var.zone_ids)) # 独立网段
  zone_id       = var.zone_ids[0]
  vswitch_name  = "lz-${var.env}-public-subnet-nat"
  tags = {
    Env        = var.env
    ManagedBy  = "HCP-Terraform"
    SubnetType = "Public"
  }
}

# 生产环境强制部署NAT网关（禁止ECS直连公网）
resource "alicloud_nat_gateway" "lz_nat" {
  count             = var.env == "prod" ? 1 : 0
  vpc_id            = alicloud_vpc.lz_vpc.id
  nat_gateway_name  = "lz-${var.env}-nat-gateway"
  specification     = var.nat_spec
  vswitch_id        = alicloud_vswitch.public_subnet[0].id
  tags = {
    Env        = var.env
    ManagedBy  = "HCP-Terraform"
  }
}

# 弹性IP（绑定NAT网关）
resource "alicloud_eip" "nat_eip" {
  count        = var.env == "prod" ? 1 : 0
  name         = "lz-${var.env}-nat-eip"
  internet_charge_type = "PayByTraffic"
  tags = {
    Env        = var.env
    ManagedBy  = "HCP-Terraform"
  }
}

# 绑定EIP到NAT网关
resource "alicloud_nat_gateway_associate_eip_address" "nat_eip_assoc" {
  count           = var.env == "prod" ? 1 : 0
  nat_gateway_id  = alicloud_nat_gateway.lz_nat[0].id
  eip_address_id  = alicloud_eip.nat_eip[0].id
}

# 路由表（私有子网指向NAT网关）
resource "alicloud_route_table" "private_route" {
  vpc_id = alicloud_vpc.lz_vpc.id
  name   = "lz-${var.env}-private-route-table"
  tags = {
    Env        = var.env
    ManagedBy  = "HCP-Terraform"
  }
}

# 路由规则：私有子网访问公网走NAT网关
resource "alicloud_route_entry" "nat_route" {
  count                  = var.env == "prod" ? 1 : 0
  route_table_id         = alicloud_route_table.private_route.id
  destination_cidrblock  = "0.0.0.0/0"
  next_hop_type          = "NatGateway"
  next_hop_id            = alicloud_nat_gateway.lz_nat[0].id
}

# 绑定私有子网到路由表
resource "alicloud_route_table_association" "subnet_route_assoc" {
  count           = length(var.zone_ids)
  route_table_id  = alicloud_route_table.private_route.id
  vswitch_id      = alicloud_vswitch.private_subnet[count.index].id
}
