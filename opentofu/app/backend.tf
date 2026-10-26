terraform {
  backend "s3" {
    bucket       = "***STATE-BUCKET***"
    key          = "app/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
