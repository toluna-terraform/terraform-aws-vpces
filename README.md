# terraform-aws-vpces

Toluna terraform module for AWS VPC Endpoints

## Summary

This module can be called with required parameters to create / delete different VPC endpoints (vpces). 

## Parameters

`env_name`

`aws_vpc_id`

`private_subnet_ids`


`create_ecs_vpce = true | false` 
to create/delete ECS, ECS Agent, Telemetry vpces

`create_ecr_vpce = true | false`
to create/delete ECR API, and ECR Docker vpces

`create_logs_vpce = true | false`
to create/delete Logs vpce

`create_s3_vpce = true | false`
to create/delete S3 vpce

`create_ssm_vpce = true | false`
to creates/delete SSM vpce

`create_monitoring_vpce = true | false`
to create/delete Monitoring vpce
