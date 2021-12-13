
resource "aws_security_group" "vpce_sg" {
    name = "ecs-vpce-${var.env_name}"
    description = "Access control for ECS and ECR VPCEs."
    vpc_id = var.aws_vpc_id
    tags = tomap({
        Name             = "sg-ecs-vpce-${var.env_name}",
        environment      = "${var.env_name}",
        application_role = "network",
        created_by       = "terraform"
    })
}

resource "aws_security_group_rule" "vpce_https_from_vpc" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ data.aws_vpc.selected.cidr_block ]
    description = "HTTPS access from entire VPC"
    security_group_id = aws_security_group.vpce_sg.id
}

resource "aws_security_group_rule" "vpce_outbound" {
    type = "egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_group_id = aws_security_group.vpce_sg.id
}

// VPCEs for ECS:
resource "aws_vpc_endpoint" "ecs_agent" {
  vpc_id            = var.aws_vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ecs-agent"
  vpc_endpoint_type = "Interface"
  subnet_ids = var.private_subnets_ids
  security_group_ids = [
    aws_security_group.vpce_sg.id,
  ]

  private_dns_enabled = true
  count               = (var.create_ecs_vpce ? 1 : 0)
}


resource "aws_vpc_endpoint" "ecs_telemetry" {
  vpc_id            = var.aws_vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ecs-telemetry"
  vpc_endpoint_type = "Interface"
  subnet_ids = var.private_subnets_ids
  security_group_ids = [
    aws_security_group.vpce_sg.id,
  ]
  
  private_dns_enabled = true
  count               = (var.create_ecs_vpce ? 1 : 0)
}

resource "aws_vpc_endpoint" "ecs" {
  vpc_id            = var.aws_vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ecs"
  vpc_endpoint_type = "Interface"
  subnet_ids = var.private_subnets_ids
  security_group_ids = [
    aws_security_group.vpce_sg.id,
  ]

  private_dns_enabled = true
  count               = (var.create_ecs_vpce ? 1 : 0)
}


// VPCEs for ECR:
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = var.aws_vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids = var.private_subnets_ids
  security_group_ids = [
    aws_security_group.vpce_sg.id,
  ]
  private_dns_enabled = true
  count               = (var.create_ecr_vpce ? 1 : 0)
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = var.aws_vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids = var.private_subnets_ids
  security_group_ids = [
    aws_security_group.vpce_sg.id,
  ]
  private_dns_enabled = true
  count               = (var.create_ecr_vpce ? 1 : 0)
  
}

// VPCE for Logs
resource "aws_vpc_endpoint" "logs" {
  vpc_id            = var.aws_vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids = var.private_subnets_ids
  security_group_ids = [
    aws_security_group.vpce_sg.id,
  ]
  private_dns_enabled = true
  count               = (var.create_logs_vpce ? 1 : 0)
}

// VPCE for S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.aws_vpc_id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
  count        = (var.create_s3_vpce ? 1 : 0)
}
