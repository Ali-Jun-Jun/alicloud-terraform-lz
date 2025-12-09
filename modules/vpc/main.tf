resource "alicloud_vpc" "this" {
  vpc_name   = "${var.environment}-vpc"
  cidr_block = var.vpc_cidr
}

resource "alicloud_vswitch" "this" {
  vswitch_name = "${var.environment}-vswitch"
  cidr_block   = var.subnet_cidr
  zone_id      = var.zone
  vpc_id       = alicloud_vpc.this.id
}

resource "alicloud_security_group" "this" {
  name   = "${var.environment}-sg"
  vpc_id = alicloud_vpc.this.id

  security_group_rule {
    type        = "ingress"
    ip_protocol = "tcp"
    port_range  = "22/22"
    cidr_ip     = "0.0.0.0/0"
    policy      = "accept"
  }

  security_group_rule {
    type        = "ingress"
    ip_protocol = "tcp"
    port_range  = "80/80"
    cidr_ip     = "0.0.0.0/0"
    policy      = "accept"
  }
}
