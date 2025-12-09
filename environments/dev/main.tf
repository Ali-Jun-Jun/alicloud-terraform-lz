terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
    }
  }
}

provider "alicloud" {
  region = "cn-beijing"
}

module "vpc" {
  source = "../../modules/vpc"

  environment = "dev"
  vpc_cidr    = "10.1.0.0/16"
  subnet_cidr = "10.1.1.0/24"
  zone        = "cn-beijing-e"
}

module "ram_role" {
  source = "../../modules/ram-role"
  environment = "dev"
}

module "ecs" {
  source = "../../modules/ecs"

  environment         = "dev"
  image_id            = "ubuntu_22_04_x64_20G_alibase_20251103.vhd"
  instance_type       = "ecs.e-c1m2.large"
  security_group_id   = module.vpc.security_group_id
  vswitch_id          = module.vpc.vswitch_id
  key_name            = "llj"  # ← 替换为你在阿里云创建的密钥对名称
}
