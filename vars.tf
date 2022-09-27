

variable "AWS_REGION" {
  default = "us-west-2"
}



variable "INSTANCE_USERNAME" {
  default = "ubuntu"  # username which will be used while doing remote-execution with the launched instance.
}



variable "custom_vpc" {
  description = "VPC for testing environment"
  type        = string
  default     = "10.0.0.0/16"
}