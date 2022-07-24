# ================ INFRA VARIABLES ================
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "private_subnets" {
  type        = list(string)
  description = "The private subnets list from the VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "The public subnet list from the VPC"
}

variable "private_subnets_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks of IP from the private subnet"
}

variable "public_subnets_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks of IP from the public subnet"
}

# ================ PGADMIN VARIABLES ================
variable "pgadmin_admin_email" {
  type        = string
  description = "The admin email for PgAdmin4"
}
variable "pgadmin_admin_password" {
  type        = string
  description = "The admin password for PgAdmin4"
}

# ================ EC2 Variables ================

variable "instance_type" {
  type        = string
  description = "The type for the instance"
}

variable "instance_key" {
  type        = string
  description = "The key pair to be used in the instances - Generate one SSH key to use and put the .pub code here"
}

# ================ EC2 Variables ================

variable "rds_user" {
  type        = string
  description = "The user for fill pgadmin pre-config file"
}
variable "rds_endpoint" {
  type        = string
  description = "The endpoint to connect into db"
}