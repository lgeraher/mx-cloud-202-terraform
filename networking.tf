resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/16"

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} VPC"
        }
      )
    )
  )
}


resource "aws_subnet" "front_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.1.0/28"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} Front-End Subnet"
        }
      )
    )
  )
}

resource "aws_subnet" "back_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.2.0/28"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = false

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} Back-End Subnet"
        }
      )
    )
  )
}

resource "aws_subnet" "db_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.3.0/28"
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = false

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} Database Subnet"
        }
      )
    )
  )
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} Internet Gateway"
        }
      )
    )
  )
}

resource "aws_eip" "nat_eip" {
  vpc = true
  depends_on = [
    aws_internet_gateway.internet_gateway
  ]

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} NAT EIP"
        }
      )
    )
  )
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.front_subnet.id

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} NAT"
        }
      )
    )
  )
}

resource "aws_security_group" "front_security_group" {
  vpc_id = aws_vpc.vpc.id

  ingress = [
    {
      name              = "SSH"
      description       = "SSH"
      from_port         = 22
      to_port           = 22
      protocol          = "tcp"
      cidr_blocks       = ["${local.my_public_ip}/32"]
      ipv6_cidr_blocks  = null
      "prefix_list_ids" = null
      "security_groups" = null
      "self"            = null
    },
    {
      name              = "HTTPS"
      description       = "HTTPS"
      from_port         = 443
      to_port           = 443
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = null
      "prefix_list_ids" = null
      "security_groups" = null
      "self"            = null
    },
    {
      name              = "HTTP"
      description       = "HTTP"
      from_port         = 80
      to_port           = 80
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = null
      "prefix_list_ids" = null
      "security_groups" = null
      "self"            = null
    }
  ]

  egress = [
    {
      name              = "Internet"
      description       = "Internet"
      from_port         = 0
      to_port           = 0
      protocol          = "-1"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = null
      "prefix_list_ids" = null
      "security_groups" = null
      "self"            = null
    }
  ]

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} Front-End Security Group"
        }
      )
    )
  )
}

resource "aws_security_group" "back_security_group" {
  vpc_id = aws_vpc.vpc.id

  ingress = [
    {
      name              = "SSH"
      description       = "SSH"
      from_port         = 22
      to_port           = 22
      protocol          = "tcp"
      cidr_blocks       = ["192.168.1.0/28"]
      ipv6_cidr_blocks  = null
      "prefix_list_ids" = null
      "security_groups" = null
      "self"            = null
    },
    {
      name              = "HTTPS"
      description       = "HTTPS"
      from_port         = 443
      to_port           = 443
      protocol          = "tcp"
      cidr_blocks       = ["192.168.1.0/28"]
      ipv6_cidr_blocks  = null
      "prefix_list_ids" = null
      "security_groups" = null
      "self"            = null
    },
    {
      name              = "HTTP"
      description       = "HTTP"
      from_port         = 80
      to_port           = 80
      protocol          = "tcp"
      cidr_blocks       = ["192.168.1.0/28"]
      ipv6_cidr_blocks  = null
      "prefix_list_ids" = null
      "security_groups" = null
      "self"            = null
    }
  ]

  egress = [
    {
      name              = "Internet"
      description       = "Internet"
      from_port         = 0
      to_port           = 0
      protocol          = "-1"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = null
      "prefix_list_ids" = null
      "security_groups" = null
      "self"            = null
    }
  ]

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} Back-End Security Group"
        }
      )
    )
  )
}

resource "aws_security_group" "db_security_group" {
  vpc_id = aws_vpc.vpc.id

  ingress = [
    {
      name              = "SSH"
      description       = "SSH"
      from_port         = 22
      to_port           = 22
      protocol          = "tcp"
      cidr_blocks       = ["192.168.2.0/28"]
      ipv6_cidr_blocks  = null
      "prefix_list_ids" = null
      "security_groups" = null
      "self"            = null
    },
    {
      name              = "PostgreSQL"
      description       = "PostgreSQL"
      from_port         = 5432
      to_port           = 5432
      protocol          = "tcp"
      cidr_blocks       = ["192.168.2.0/28"]
      ipv6_cidr_blocks  = null
      "prefix_list_ids" = null
      "security_groups" = null
      "self"            = null
    }
  ]

  egress = [
    {
      name              = "Internet"
      description       = "Internet"
      from_port         = 0
      to_port           = 0
      protocol          = "-1"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = null
      "prefix_list_ids" = null
      "security_groups" = null
      "self"            = null
    }
  ]

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} DB Security Group"
        }
      )
    )
  )
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      gateway_id                 = aws_internet_gateway.internet_gateway.id
      carrier_gateway_id         = null
      destination_prefix_list_id = null
      egress_only_gateway_id     = null
      instance_id                = null
      ipv6_cidr_block            = null
      local_gateway_id           = null
      nat_gateway_id             = null
      network_interface_id       = null
      transit_gateway_id         = null
      vpc_endpoint_id            = null
      vpc_peering_connection_id  = null
      core_network_arn           = null
    }
  ]

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} Public Route Table"
        }
      )
    )
  )

}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      gateway_id                 = aws_nat_gateway.nat_gateway.id
      carrier_gateway_id         = null
      destination_prefix_list_id = null
      egress_only_gateway_id     = null
      instance_id                = null
      ipv6_cidr_block            = null
      local_gateway_id           = null
      nat_gateway_id             = null
      network_interface_id       = null
      transit_gateway_id         = null
      vpc_endpoint_id            = null
      vpc_peering_connection_id  = null
      core_network_arn           = null
    }
  ]

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} Private Route Table"
        }
      )
    )
  )

}

resource "aws_route_table_association" "front_subnet_association" {
  subnet_id      = aws_subnet.front_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "back_subnet_association" {
  subnet_id      = aws_subnet.back_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "db_subnet_association" {
  subnet_id      = aws_subnet.db_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

