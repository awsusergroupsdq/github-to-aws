terraform {
  backend "s3" {
    bucket       = "***STATE-BUCKET***"
    key          = "infra/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
