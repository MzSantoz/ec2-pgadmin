# ================ RDS VARIABLES ================
# NOTE: Rds database name needs to be alfanumeric only
variable "rds_db_name" {
  type        = string
  default     = "postgres14sendcloud"
  description = "The custom database name"
}

variable "rds_db_user" {
  type        = string
  description = "The custom username for the Database - Don't use 'Admin' because is reserved"
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
  type = string
  description = "The type for the instance"
  default = "t3.micro"
}

variable "instance_key" {
  type = string
  description = "The key pair to be used in the instances - Generate one SSH key to use and put the .pub code here"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7yFjJP1CkgVWKeHa1EFWYsn1IOGehpH9Wtc2m8FslZrmwEft4HbLRA/BcB3aps4vjz22H9LD4LNyaOUYx54jHSg11xmcCq3Uv4iFiNbkjDB8FVL634/k+MiPSF5yeX2rukS4nMAsf3xFS5sQFxKWYSsufyInqYL35intG7UH0OCRC21LHuqIKjgCqjqcF/cx1rWJ5kHammKeIYCxOiawKVKjhvPQfJXQuejXeStZA/RAq9Nz9gxxx+7ixMDHwiCN5A6l7tyhdiJ4xiED0QmNCMN3s5RonhGx7GPPbUhg8Ug9SK+LGJBXsGF5aGezPSVY9rNGldxV0lRCfPRpNG4nFz9cB/CudNFUIxQ19uI2T7/P7MhZ7ewo7m8OYrR54XWq+7rSdcNzsBTvWI1m6WFeRcYv37ySmU3jaA4zZRJ6j4Xl3DxWBNb+m4QkiaXuScf7W1vIIc30LR7gNPzWe9JZQDHgqJS1MeLmV1ULLTLM6Nf3w734glcE0r6bIxOMP2rU= pgadmin-key"
}