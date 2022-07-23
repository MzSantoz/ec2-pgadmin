provider "aws" {
  alias  = "principal"
  region = "us-east-1"
}

provider "aws" {
  alias  = "backup_region"
  region = "us-west-1"
}