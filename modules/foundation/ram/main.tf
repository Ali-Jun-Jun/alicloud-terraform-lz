# 创建Landing Zone专用RAM角色（供ECS实例使用）
resource "alicloud_ram_role" "lz_ecs_role" {
  name        = "LZ-${var.env}-${var.business_unit}-ECS-Role"
  document    = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs.aliyuncs.com"
        }
      }
    ]
    Version = "1"
  })
  description = "Landing Zone ${var.env}环境${var.business_unit}业务ECS角色"
  tags = {
    Env        = var.env
    ManagedBy  = "HCP-Terraform"
    BusinessUnit = var.business_unit
  }
}

# 权限策略：限制ECS仅能访问指定资源
resource "alicloud_ram_policy" "lz_ecs_policy" {
  name        = "LZ-${var.env}-${var.business_unit}-ECS-Policy"
  document    = jsonencode({
    Statement = [
      {
        Action = [
          "oss:ListObjects",
          "oss:GetObject"
        ]
        Effect   = "Allow"
        Resource = ["acs:oss:*:*:lz-${var.env}-${var.business_unit}-bucket/*"]
      },
      {
        Action   = ["ecs:DescribeInstances"]
        Effect   = "Allow"
        Resource = ["*"]
      }
    ]
    Version   = "1"
  })
  description = "Landing Zone ECS最小权限策略"
}

# 绑定策略到角色
resource "alicloud_ram_role_policy_attachment" "ecs_policy_attach" {
  policy_name = alicloud_ram_policy.lz_ecs_policy.name
  policy_type = "Custom"
  role_name   = alicloud_ram_role.lz_ecs_role.name
}
