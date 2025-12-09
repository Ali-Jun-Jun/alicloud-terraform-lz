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
