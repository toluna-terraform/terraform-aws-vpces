data "aws_vpc" "selected" {
    id = var.aws_vpc_id
}

data "aws_region" "current" {}