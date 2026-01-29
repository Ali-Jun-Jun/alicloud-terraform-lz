resource "alicloud_instance" "this" {
  instance_name             = "${var.environment}-web-server"
  image_id                  = var.image_id
  instance_type             = var.instance_type
  security_groups           = [var.security_group_id]
  vswitch_id                = var.vswitch_id
  internet_max_bandwidth_out = 5
  system_disk_category      = "cloud_ssd"
  system_disk_size          = 40
  key_name                  = var.key_name
  tags = {
    Project     = "LandingZone"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
