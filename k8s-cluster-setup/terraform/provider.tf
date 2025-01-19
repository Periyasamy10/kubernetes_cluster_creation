provider "aws" {
  region = var.aws_region
}

provider "local" {}
provider "null" {}