# ec2-pgadmin - AWS PgAdmin fast example.

Developer: Moisés Santos

This solution creates the requested resources with resilience and some security to enable PgAdmin4 running in containers from EC2 pair of instances to connect into RDS database.

This resource uses:
- Specific VPC and subnets
- RDS
- EC2
- ALB
- EFS
- And others.

The main objective was to deploy everything with some aws cloud best practices like instances without public ip in private subnets, traffic control and AZ fail-over strategy, container persistence shared in the subnet...

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.63 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_general_infrastructure"></a> [general\_infrastructure](#module\_general\_infrastructure) | ./modules/infrastructure | n/a |
| <a name="module_pgadmin"></a> [pgadmin](#module\_pgadmin) | ./modules/ec2-pgadmin | n/a |
| <a name="module_rds_database"></a> [rds\_database](#module\_rds\_database) | ./modules/database | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_email"></a> [admin\_email](#input\_admin\_email) | The admin email for PgAdmin4 | `string` | n/a | yes |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | The admin password for PgAdmin4 | `string` | n/a | yes |
| <a name="input_instance_key"></a> [instance\_key](#input\_instance\_key) | The key pair to be used in the instances - Generate one SSH key to use and put the .pub code here | `string` | `"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7yFjJP1CkgVWKeHa1EFWYsn1IOGehpH9Wtc2m8FslZrmwEft4HbLRA/BcB3aps4vjz22H9LD4LNyaOUYx54jHSg11xmcCq3Uv4iFiNbkjDB8FVL634/k+MiPSF5yeX2rukS4nMAsf3xFS5sQFxKWYSsufyInqYL35intG7UH0OCRC21LHuqIKjgCqjqcF/cx1rWJ5kHammKeIYCxOiawKVKjhvPQfJXQuejXeStZA/RAq9Nz9gxxx+7ixMDHwiCN5A6l7tyhdiJ4xiED0QmNCMN3s5RonhGx7GPPbUhg8Ug9SK+LGJBXsGF5aGezPSVY9rNGldxV0lRCfPRpNG4nFz9cB/CudNFUIxQ19uI2T7/P7MhZ7ewo7m8OYrR54XWq+7rSdcNzsBTvWI1m6WFeRcYv37ySmU3jaA4zZRJ6j4Xl3DxWBNb+m4QkiaXuScf7W1vIIc30LR7gNPzWe9JZQDHgqJS1MeLmV1ULLTLM6Nf3w734glcE0r6bIxOMP2rU= pgadmin-key"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type for the instance | `string` | `"t3.micro"` | no |
| <a name="input_rds_db_name"></a> [rds\_db\_name](#input\_rds\_db\_name) | The custom database name | `string` | `"postgres14sendcloud"` | no |
| <a name="input_rds_db_password"></a> [rds\_db\_password](#input\_rds\_db\_password) | The password to use in the database - Min 8 Chars length | `string` | n/a | yes |
| <a name="input_rds_db_user"></a> [rds\_db\_user](#input\_rds\_db\_user) | The custom username for the Database - Don't use 'Admin' because is reserved | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
