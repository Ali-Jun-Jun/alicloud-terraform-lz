# Terraform核心配置
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.200.0"
    }
  }
  # 配置HCP远程State后端
  backend "remote" {
    organization = var.hcp_org
    workspaces {
      name = var.hcp_workspace
    }
  }
}

# 阿里云Provider配置（凭证通过HCP环境变量注入）
provider "alicloud" {
  region = var.region
}

# 调用基础层VPC模块
module "foundation_vpc" {
  source = "./modules/foundation/vpc"
  env          = var.env
  vpc_cidr     = var.vpc_cidr
  zone_ids     = var.zone_ids
  business_unit = var.business_unit
  nat_spec     = var.nat_spec
}

# 调用基础层RAM模块
module "foundation_ram" {
  source = "./modules/foundation/ram"
  env          = var.env
  business_unit = var.business_unit
}

# 调用业务层ECS模块
module "business_ecs" {
  source = "./modules/business/ecs"
  env                = var.env
  business_unit      = var.business_unit
  instance_count     = var.instance_count
  instance_type      = var.instance_type
  image_id           = var.image_id
  allocate_public_ip = var.allocate_public_ip
  security_group_ids = var.security_group_ids
  system_disk_category = var.system_disk_category
  system_disk_size   = var.system_disk_size
  cost_center        = var.cost_center
  user_data          = var.user_data
  hcp_org            = var.hcp_org
  hcp_vpc_workspace  = var.hcp_vpc_workspace
  hcp_ram_workspace  = var.hcp_ram_workspace
}
