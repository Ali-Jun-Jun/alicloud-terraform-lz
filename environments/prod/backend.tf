erraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "test-aliyun"  # ← 改成你的组织名

    workspaces {
      name = "landingzone-prod"
    }
  }
}
