# pn-IaC-terraform

Terraform modules for creating AWS S3 static website and backend server using AWS ECS fargate.

# ACM module

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.pn-server-record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_acm_certificate.issued](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_route53_zone.pn-zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_dns_name"></a> [alb\_dns\_name](#input\_alb\_dns\_name) | application load balancer dns name | `any` | n/a | yes |
| <a name="input_alb_zone_id"></a> [alb\_zone\_id](#input\_alb\_zone\_id) | application load balancer zone id | `any` | n/a | yes |
| <a name="input_env_prefix"></a> [env\_prefix](#input\_env\_prefix) | environment prefix | `any` | n/a | yes |
| <a name="input_root_domain"></a> [root\_domain](#input\_root\_domain) | root domain name | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate"></a> [certificate](#output\_certificate) | n/a |

# ALB module

## Resources

| Name | Type |
|------|------|
| [aws_alb_listener.https-alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_lb.pn-server-alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http-https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.pn-server-alb-tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_sg_id"></a> [alb\_sg\_id](#input\_alb\_sg\_id) | application load balancer security group id | `any` | n/a | yes |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | certificate arn for the root domian wildcard | `any` | n/a | yes |
| <a name="input_env_prefix"></a> [env\_prefix](#input\_env\_prefix) | environment prefix | `any` | n/a | yes |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | backend server health check path | `any` | n/a | yes |
| <a name="input_public_subnet_id"></a> [public\_subnet\_id](#input\_public\_subnet\_id) | public subnet id/s | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | vpc id | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb"></a> [alb](#output\_alb) | n/a |
| <a name="output_alb_listener_https_alb"></a> [alb\_listener\_https\_alb](#output\_alb\_listener\_https\_alb) | n/a |
| <a name="output_alb_target_group"></a> [alb\_target\_group](#output\_alb\_target\_group) | n/a |

# CloudFront resource

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |


## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.s3_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_acm_certificate.issued_ssl_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env_prefix"></a> [env\_prefix](#input\_env\_prefix) | environment prefix | `any` | n/a | yes |
| <a name="input_frontend_bucket_name"></a> [frontend\_bucket\_name](#input\_frontend\_bucket\_name) | bucket name for the static website - website domain name | `any` | n/a | yes |
| <a name="input_root_domain"></a> [root\_domain](#input\_root\_domain) | root domain name | `any` | n/a | yes |
| <a name="input_s3_bucket_regional_domain_name"></a> [s3\_bucket\_regional\_domain\_name](#input\_s3\_bucket\_regional\_domain\_name) | frontend bucket regional domain name | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_s3_distribution"></a> [cloudfront\_s3\_distribution](#output\_cloudfront\_s3\_distribution) | n/a |

# ECS module

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.pn-server-cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.pn-server-service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.pn-server-task-definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.ecs_task_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_target_group_arn"></a> [alb\_target\_group\_arn](#input\_alb\_target\_group\_arn) | applicaiton load balancer target group arn | `any` | n/a | yes |
| <a name="input_container_count"></a> [container\_count](#input\_container\_count) | container count | `any` | n/a | yes |
| <a name="input_container_cpu"></a> [container\_cpu](#input\_container\_cpu) | container cpu | `any` | n/a | yes |
| <a name="input_container_memory"></a> [container\_memory](#input\_container\_memory) | container memory | `any` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | container port | `any` | n/a | yes |
| <a name="input_ecs_cluster_sg_id"></a> [ecs\_cluster\_sg\_id](#input\_ecs\_cluster\_sg\_id) | ecs cluster security group id | `any` | n/a | yes |
| <a name="input_ecs_dependends_on_list"></a> [ecs\_dependends\_on\_list](#input\_ecs\_dependends\_on\_list) | dependency list before creating ecs | `any` | n/a | yes |
| <a name="input_env_prefix"></a> [env\_prefix](#input\_env\_prefix) | n/a | `any` | n/a | yes |
| <a name="input_fargate_cpu"></a> [fargate\_cpu](#input\_fargate\_cpu) | n/a | `any` | n/a | yes |
| <a name="input_fargate_memory"></a> [fargate\_memory](#input\_fargate\_memory) | n/a | `any` | n/a | yes |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | image tag for task definition | `any` | n/a | yes |
| <a name="input_pn-server-port"></a> [pn-server-port](#input\_pn-server-port) | container port for load balancer | `any` | n/a | yes |
| <a name="input_private_subnet_id"></a> [private\_subnet\_id](#input\_private\_subnet\_id) | private subnet id for ecs network | `any` | n/a | yes |
| <a name="input_repo_url"></a> [repo\_url](#input\_repo\_url) | ecr repo url | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `any` | n/a | yes |

# Route53 module

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.frontend_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudfront_s3_distribution_domian_name"></a> [cloudfront\_s3\_distribution\_domian\_name](#input\_cloudfront\_s3\_distribution\_domian\_name) | cloudfront distribution.s3 distribution domain name | `any` | n/a | yes |
| <a name="input_cloudfront_s3_distribution_hosted_zone_id"></a> [cloudfront\_s3\_distribution\_hosted\_zone\_id](#input\_cloudfront\_s3\_distribution\_hosted\_zone\_id) | cloudfront distribution.s3 distribution hosted zone id | `any` | n/a | yes |
| <a name="input_frontend_bucket_name"></a> [frontend\_bucket\_name](#input\_frontend\_bucket\_name) | bucket name for the static website - website domain name | `any` | n/a | yes |
| <a name="input_root_domain"></a> [root\_domain](#input\_root\_domain) | root domain name | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_frontend_record_name"></a> [frontend\_record\_name](#output\_frontend\_record\_name) | n/a |

#s3 module

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.pn-app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.pn-app-bucket-acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_policy.pn-app-bucket-poloicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_website_configuration.pn-app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env_prefix"></a> [env\_prefix](#input\_env\_prefix) | environment prefix | `any` | n/a | yes |
| <a name="input_frontend_bucket_name"></a> [frontend\_bucket\_name](#input\_frontend\_bucket\_name) | bucket name for the static website - website domain name | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | n/a |
| <a name="output_website_domain"></a> [website\_domain](#output\_website\_domain) | n/a |
| <a name="output_website_endpoint"></a> [website\_endpoint](#output\_website\_endpoint) | n/a |

# Security Group (sg) module

## Resources

| Name | Type |
|------|------|
| [aws_security_group.ecs-cluster-sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.pn-server-alb-sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env_prefix"></a> [env\_prefix](#input\_env\_prefix) | environment prefix | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | vpc id | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb-sg"></a> [alb-sg](#output\_alb-sg) | n/a |
| <a name="output_ecs-cluster-sg-id"></a> [ecs-cluster-sg-id](#output\_ecs-cluster-sg-id) | n/a |

# Subnet module

## Resources

| Name | Type |
|------|------|
| [aws_eip.pn-server-ngw-eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.pn-server-igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.pn-server-ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.pn-server-private-rtb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.pn-server-public-rtb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.a-private-rtb-subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.a-public-rtb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.pn-server-private-subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.pn-server-public-subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | n/a | `any` | n/a | yes |
| <a name="input_env_prefix"></a> [env\_prefix](#input\_env\_prefix) | n/a | `any` | n/a | yes |
| <a name="input_private_subnet_cidr_blocks"></a> [private\_subnet\_cidr\_blocks](#input\_private\_subnet\_cidr\_blocks) | n/a | `any` | n/a | yes |
| <a name="input_public_subnet_cidr_blocks"></a> [public\_subnet\_cidr\_blocks](#input\_public\_subnet\_cidr\_blocks) | n/a | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private-subnet"></a> [private-subnet](#output\_private-subnet) | n/a |
| <a name="output_public-subnet"></a> [public-subnet](#output\_public-subnet) | n/a |
