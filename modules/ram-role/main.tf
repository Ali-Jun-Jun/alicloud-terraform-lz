# RAM Role: Allows ECS instances to assume this role
resource "alicloud_ram_role" "this" {
  name = "example-role"

  assume_role_policy_document = jsonencode({
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = ["ecs.aliyuncs.com"]
        }
      }
    ]
    Version = "1"
  })

  # ✅ Optional: Max session duration (3600–43200 seconds), default is 3600
  max_session_duration = 3600
}

# RAM Policy: Allow read access to OSS
resource "alicloud_ram_policy" "oss_read" {
  policy_name = "${var.environment}-oss-read-policy"

  policy_document = jsonencode({
    Version = "1"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "oss:Get*",
          "oss:List*"
        ],
        Resource = "*"
      }
    ]
  })

  description = "允许 OSS 读取"
}

# Attach the policy to the role
resource "alicloud_ram_role_policy_attachment" "attach" {
  policy_name = alicloud_ram_policy.oss_read.policy_name
  policy_type = "Custom"
  role_name   = alicloud_ram_role.this.name  # Use .name (not .role_name)
}
