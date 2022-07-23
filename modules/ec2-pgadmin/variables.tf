# ================ INFRA VARIABLES ================
variable "vpc_id" {
  type        = string
  description = "The name of the ECS cluster for PgAdmin4"
}

variable "private_subnets" {
  type        = list(string)
  description = "The name of the ECS cluster for PgAdmin4"
}

variable "public_subnets" {
  type        = list(string)
  description = "The name of the ECS cluster for PgAdmin4"
}

variable "private_subnets_cidr_blocks" {
  type        = list(string)
  description = "The name of the ECS cluster for PgAdmin4"
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