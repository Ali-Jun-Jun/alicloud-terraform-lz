# 基础层VPC配置
env = "prod"
vpc_cidr = "172.16.0.0/16"
zone_ids = ["cn-shenzhen-b", "cn-shenzhen-c"]
business_unit = "retail"
nat_spec = "Standard"

# 业务层ECS配置
instance_count = 2
instance_type = "ecs.g7.xlarge"
allocate_public_ip = false # 生产环境强制关闭
cost_center = "retail-prod-001"
