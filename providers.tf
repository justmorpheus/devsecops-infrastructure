provider "aws" {
  profile = "default"
  region  = var.AWS_REGION # value will be taken form vars.tf file.
}
