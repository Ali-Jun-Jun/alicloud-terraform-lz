resource "alicloud_ram_role" "this" {
  role_name   = "${var.environment}-ecs-role"
  document    = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": ["ecs.aliyuncs.com"]
      }
    }
  ],
  "Version": "1"
}
EOF
  description = "ECS 实例扮演的角色"
  force       = true
}

resource "alicloud_ram_policy" "oss_read" {
  policy_name = "${var.environment}-oss-read-policy"
  policy_document = <<EOF
{
  "Version": "1",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "oss:Get*",
        "oss:List*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
  description = "允许 OSS 读取"
}

resource "alicloud_ram_role_policy_attachment" "attach" {
  policy_name = alicloud_ram_policy.oss_read.policy_name
  policy_type = "Custom"
  role_name   = alicloud_ram_role.this.role_name
}
