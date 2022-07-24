# ================ RDS VARIABLES ================
# NOTE: Rds database name needs to be alfanumeric only
variable "rds_db_name" {
  type        = string
  default     = "postgres14sendcloud"
  description = "The custom database name"
}

variable "rds_db_user" {
  type        = string
  description = "The custom username for the Database - Don't use 'Admin' because it's reserved"
}

variable "rds_db_password" {
  type        = string
  description = "The password to use in the database - Min 8 Chars length"
}

# ================ PGADMIN VARIABLES ================
variable "admin_email" {
  type        = string
  description = "The admin email for PgAdmin4"
}
variable "admin_password" {
  type        = string
  description = "The admin password for PgAdmin4"
}

# ================ EC2 VARIABLES ================
variable "instance_type" {
  type        = string
  description = "The type for the instance"
  default     = "t3.micro"
}

variable "instance_key" {
  type        = string
  description = "The key pair to be used in the instances - Generate one SSH key to use and put the .pub code here"
}