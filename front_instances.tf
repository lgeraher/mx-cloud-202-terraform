resource "aws_network_interface" "front_01_nic" {
  subnet_id       = aws_subnet.front_subnet.id
  private_ips     = ["192.168.1.4"]
  security_groups = [aws_security_group.front_security_group.id]

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} Front 01 NIC"
        }
      )
    )
  )
}

resource "aws_instance" "front_01_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  user_data = templatefile("./init_front.sh", {
    "dns" = var.front_01_dns
  })

  network_interface {
    network_interface_id = aws_network_interface.front_01_nic.id
    device_index         = 0
  }

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} Front 01"
        }
      )
    )
  )
}

resource "aws_route53_record" "front_01_dns_record" {
  zone_id = data.aws_route53_zone.selected.id
  name    = "front-01"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.front_01_instance.public_ip]
  depends_on = [
    aws_instance.front_01_instance
  ]
}

##############################################################

resource "aws_network_interface" "front_02_nic" {
  subnet_id       = aws_subnet.front_subnet.id
  private_ips     = ["192.168.1.5"]
  security_groups = [aws_security_group.front_security_group.id]

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} Front 02 NIC"
        }
      )
    )
  )
}

resource "aws_instance" "front_02_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  user_data = templatefile("./init_front.sh", {
    "dns" = var.front_02_dns
  })

  network_interface {
    network_interface_id = aws_network_interface.front_02_nic.id
    device_index         = 0
  }

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} Front 02"
        }
      )
    )
  )
}

resource "aws_route53_record" "front_02_dns_record" {
  zone_id = data.aws_route53_zone.selected.id
  name    = "front-02"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.front_02_instance.public_ip]
  depends_on = [
    aws_instance.front_02_instance
  ]
}
