terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "test-aliyun"  # ← 替换成你的 HCP Terraform 组织名

    workspaces {
      name = "landingzone-dev"
    }
  }
}
