terraform {
  backend "s3" {
    bucket       = "ug-enmedina-tfstate-783111403365-us-east-1-an"
    key          = "infra/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
