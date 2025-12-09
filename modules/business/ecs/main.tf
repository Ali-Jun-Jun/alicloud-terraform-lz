# 引用基础层VPC状态（通过HCP远程State）
data "terraform_remote_state" "foundation_vpc" {
  backend = "remote"
  config = {
    organization = var.hcp_org
    workspaces = {
      name = var.hcp_vpc_workspace
    }
  }
}

# 引用基础层RAM角色
data "terraform_remote_state" "foundation_ram" {
  backend = "remote"
  config = {
    organization = var.hcp_org
    workspaces = {
      name = var.hcp_ram_workspace
    }
  }
}

# 创建ECS实例（部署在Landing Zone私有子网）
resource "alicloud_ecs_instance" "lz_ecs" {
  count              = var.instance_count
  instance_name      = "lz-${var.env}-${var.business_unit}-ecs-${count.index}"
  image_id           = var.image_id
  instance_type      = var.instance_type
  vswitch_id         = data.terraform_remote_state.foundation_vpc.outputs.private_subnet_ids[count.index % length(data.terraform_remote_state.foundation_vpc.outputs.private_subnet_ids)]
  security_group_ids = var.security_group_ids
  # 生产环境禁止公网IP
  allocate_public_ip = var.env == "prod" ? false : var.allocate_public_ip
  # 绑定RAM角色
  ram_role_name      = data.terraform_remote_state.foundation_ram.outputs.ram_role_name
  # 系统盘配置
  system_disk_category = var.system_disk_category
  system_disk_size     = var.system_disk_size
  # 标签规范
  tags = {
    Env          = var.env
    ManagedBy    = "HCP-Terraform"
    BusinessUnit = var.business_unit
    CostCenter   = var.cost_center
  }
  # 启动脚本（初始化配置）
  user_data = base64encode(var.user_data)
}

# 安全组（基础网络策略）
resource "alicloud_security_group" "lz_ecs_sg" {
  name        = "lz-${var.env}-${var.business_unit}-ecs-sg"
  vpc_id      = data.terraform_remote_state.foundation_vpc.outputs.vpc_id
  description = "Landing Zone ECS安全组"
  tags = {
    Env        = var.env
    ManagedBy  = "HCP-Terraform"
  }
}

# 安全组规则：仅允许内网访问80/443
resource "alicloud_security_group_rule" "ecs_inbound" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "80/80,443/443"
  priority          = 1
  security_group_id = alicloud_security_group.lz_ecs_sg.id
  cidr_ip           = "172.16.0.0/16" # 仅允许VPC内网访问
}
