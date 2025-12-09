variable "env" {
  type        = string
  description = "部署环境（dev/test/prod）"
  validation {
    condition     = contains(["dev", "test", "prod"], var.env)
    error_message = "环境必须为dev/test/prod之一"
  }
}

variable "business_unit" {
  type        = string
  description = "业务单元标识（如retail/finance）"
  default     = "retail"
}

variable "instance_count" {
  type        = number
  description = "ECS实例数量"
  default     = 2
}

variable "instance_type" {
  type        = string
  description = "ECS实例规格"
  default     = "ecs.g7.large"
}

variable "image_id" {
  type        = string
  description = "ECS镜像ID（CentOS 7/8）"
  default     = "centos_7_9_x64_20G_alibase_20250101.vhd"
}

variable "allocate_public_ip" {
  type        = bool
  description = "测试环境是否分配公网IP（生产环境强制false）"
  default     = true
}

variable "security_group_ids" {
  type        = list(string)
  description = "自定义安全组ID（若无则使用模块内创建的安全组）"
  default     = []
}

variable "system_disk_category" {
  type        = string
  description = "系统盘类型"
  default     = "cloud_essd"
}

variable "system_disk_size" {
  type        = number
  description = "系统盘大小（GB）"
  default     = 40
}

variable "cost_center" {
  type        = string
  description = "成本中心标签（必填）"
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
