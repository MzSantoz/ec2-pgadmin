# ================ INFRA VARIABLES ================
variable "vpc_id" {
  type        = string
  description = "The main infrastructure vpc id"
}

variable "private_subnets" {
  type        = list(string)
  description = "The main infrastructure private subnets ids"
}

variable "public_subnets" {
  type        = list(string)
  description = "The main infrastructure public subnets ids"
}

variable "database_subnets" {
  type        = list(string)
  description = "The main infrastructure database subnets ids"
}

variable "database_subnet_group" {
  type        = string
  description = "The main infrastructure database subnet group id"
}

variable "private_subnets_cidr_blocks" {
  type        = list(string)
  description = "The main infrastructure private subnet cidr block list"
}

# ================ DB VARIABLES ================
variable "db_name" {
  type        = string
  default     = "postgres14sendcloud"
  description = "The custom database name"
}

variable "db_instance_type" {
  type        = string
  default     = "db.t3.small"
  description = "The custom database name"
}

# NOTE: Do NOT use 'user' as the value for 'username' as it throws:
# "Error creating DB Instance: InvalidParameterValue: MasterUsername
# user cannot be used as it is a reserved word used by the engine"
variable "db_user" {
  type        = string
  description = "The custom username for the Database"
}

variable "db_sg_name" {
  type        = string
  default     = "postgres_sg"
  description = "The name of the security group for the Database"
}