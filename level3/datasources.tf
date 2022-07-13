#This remote data source is for main vpc and main-public0 id
data "terraform_remote_state" "level1-main-vpc" {
  backend = "s3"

  config = {
    bucket = "main-backend-state-bucket"
    key    = "level1/terraform.tfstate"
    region = "us-east-1"
  }
}
