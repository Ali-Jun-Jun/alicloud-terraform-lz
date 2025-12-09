variable "env" {
  type        = string
  description = "部署环境（dev/test/prod）"
  validation {
    condition     = contains(["dev", "test", "prod"], var.env)
    error_message = "环境必须为dev/test/prod之一"
  }
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
  description = "业务单元标识（如retail/finance）"
  default     = "retail"
}

variable "nat_spec" {
  type        = string
  description = "NAT网关规格（生产环境用Standard，测试用Small）"
  default     = "Standard"
  validation {
    condition     = contains(["Small", "Medium", "Large", "Standard"], var.nat_spec)
    error_message = "NAT规格必须为Small/Medium/Large/Standard之一"
  }
}
