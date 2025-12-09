# 基础层VPC配置
env = "dev"
vpc_cidr = "172.17.0.0/16"
zone_ids = ["cn-shenzhen-b", "cn-shenzhen-c"]
business_unit = "retail"
nat_spec = "Small"

# 业务层ECS配置
instance_count = 1
instance_type = "ecs.g7.large"
allocate_public_ip = true
cost_center = "retail-dev-001"
