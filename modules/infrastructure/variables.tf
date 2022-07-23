# ================ INFRA VARIABLES ================
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The region to create the network and deploy the applications"
}
