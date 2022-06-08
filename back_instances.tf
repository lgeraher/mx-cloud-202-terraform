resource "aws_network_interface" "back_01_nic" {
  subnet_id       = aws_subnet.back_subnet.id
  private_ips     = ["192.168.2.4"]
  security_groups = [aws_security_group.back_security_group.id]

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} Back 01 NIC"
        }
      )
    )
  )
}

resource "aws_instance" "back_01_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  user_data     = file("./init_back.sh")

  network_interface {
    network_interface_id = aws_network_interface.back_01_nic.id
    device_index         = 0
  }

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} Back 01"
        }
      )
    )
  )
}

##############################################################

resource "aws_network_interface" "back_02_nic" {
  subnet_id       = aws_subnet.back_subnet.id
  private_ips     = ["192.168.2.5"]
  security_groups = [aws_security_group.back_security_group.id]

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} Back 02 NIC"
        }
      )
    )
  )
}

resource "aws_instance" "back_02_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  user_data     = file("./init_back.sh")

  network_interface {
    network_interface_id = aws_network_interface.back_02_nic.id
    device_index         = 0
  }

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} Back 02"
        }
      )
    )
  )
}
