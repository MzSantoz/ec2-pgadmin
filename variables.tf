# ================ INFRA VARIABLES ================
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The region to create the network and deploy the applications"
}

# ================ DB VARIABLES ================
# NOTE: Rds database name needs to be alfanumeric only
variable "db_name" {
  type        = string
  default     = "postgres14sendcloud"
  description = "The custom database name"
}

# NOTE: Do NOT use 'user' as the value for 'username' as it throws:
# "Error creating DB Instance: InvalidParameterValue: MasterUsername
# user cannot be used as it is a reserved word used by the engine"
variable "db_user" {
  type        = string
  default     = "moises"
  description = "The custom username for the Database"
}

variable "db_sg_name" {
  type        = string
  default     = "postgres_sg"
  description = "The name of the security group for the Database"
}