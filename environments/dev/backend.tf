terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "your-org-name"  # ← 替换成你的 HCP Terraform 组织名

    workspaces {
      name = "landingzone-dev"
    }
  }
}
