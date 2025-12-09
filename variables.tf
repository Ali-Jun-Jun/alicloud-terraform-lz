# 全局变量（覆盖所有模块）
variable "env" {
  type        = string
  description = "部署环境（dev/test/prod）"
  default     = "prod"
  validation {
    condition     = contains(["dev", "test", "prod"], var.env)
    error_message = "环境必须为dev/test/prod之一"
  }
}

variable "region" {
  type        = string
  description = "阿里云地域"
  default     = "cn-shenzhen"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC主网段"
  default     = "172.16.0.0/16"
}

variable "zone_ids" {
  type        = list(string)
  description = "可用区列表"
  default     = ["cn-shenzhen-b", "cn-shenzhen-c"]
}

variable "business_unit" {
  type        = string
  description = "业务单元标识"
  default     = "retail"
}

variable "nat_spec" {
  type        = string
  description = "NAT网关规格"
  default     = "Standard"
}

variable "instance_count" {
  type        = number
  description = "ECS实例数量"
  default     = 2
}

variable "instance_type" {
  type        = string
  description = "ECS实例规格"
  default     = "ecs.g7.xlarge"
}

variable "image_id" {
  type        = string
  description = "ECS镜像ID"
  default     = "centos_7_9_x64_20G_alibase_20250101.vhd"
}

variable "allocate_public_ip" {
  type        = bool
  description = "是否分配公网IP（生产环境强制false）"
  default     = false
}

variable "security_group_ids" {
  type        = list(string)
  description = "ECS安全组ID列表"
  default     = []
}

variable "system_disk_category" {
  type        = string
  description = "ECS系统盘类型"
  default     = "cloud_essd"
}

variable "system_disk_size" {
  type        = number
  description = "ECS系统盘大小（GB）"
  default     = 40
}

variable "cost_center" {
  type        = string
  description = "成本中心标签"
  default     = "retail-prod-001"
}

variable "user_data" {
  type        = string
  description = "ECS启动脚本"
  default     = "#!/bin/bash\nyum update -y"
}

variable "hcp_org" {
  type        = string
  description = "HCP Terraform组织名"
  default     = "alicloud-lz-org"
}

variable "hcp_workspace" {
  type        = string
  description = "HCP当前工作空间名"
  default     = "retail-prod"
}

variable "hcp_vpc_workspace" {
  type        = string
  description = "HCP VPC基础层工作空间名"
  default     = "global-vpc"
}

variable "hcp_ram_workspace" {
  type        = string
  description = "HCP RAM基础层工作空间名"
  default     = "global-ram"
}
