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
  name   = "web-sg"
  vpc_id = alicloud_vpc.this.id
}

resource "alicloud_security_group_rule" "allow_http" {
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "80/80"
  cidr_ip           = "0.0.0.0/0"
  security_group_id = alicloud_security_group.this.id
  policy            = "accept"
  priority          = 1
}

resource "alicloud_security_group_rule" "allow_all_egress" {
  type              = "egress"
  ip_protocol       = "all"
  port_range        = "-1/-1"
  cidr_ip           = "0.0.0.0/0"
  security_group_id = alicloud_security_group.this.id
  policy            = "accept"
}
