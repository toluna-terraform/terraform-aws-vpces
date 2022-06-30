data "aws_vpc" "selected" {
    id = var.aws_vpc_id
}

data "aws_region" "current" {}

data "aws_route_tables" "private_rts" {
    vpc_id = var.aws_vpc_id 

    filter  {
        name = "tag:Name"
        values = [ "*private*" ]
    }
}


