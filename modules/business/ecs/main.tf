data "terraform_remote_state" "foundation" {
  backend = "remote"
  config = {
    organization = "alicloud-lz-org"
    workspaces = {
      name = "global-vpc"
    }
  }
}
resource "alicloud_ecs_instance" "retail_server" {
  instance_name   = "lz-prod-retail-ecs"
  image_id        = "centos_7_9_x64_20G_alibase_20250101.vhd"
  instance_type   = "ecs.g7.large"
  vswitch_id      = data.terraform_remote_state.foundation.outputs.subnet_ids[0]
  tags = {
    Env = "prod"
  }
}
