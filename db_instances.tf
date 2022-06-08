resource "aws_network_interface" "db_01_nic" {
  subnet_id       = aws_subnet.db_subnet.id
  private_ips     = ["192.168.3.4"]
  security_groups = [aws_security_group.db_security_group.id]

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} DB 01 NIC"
        }
      )
    )
  )
}

resource "aws_instance" "db_01_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  user_data     = file("./init_back.sh")

  network_interface {
    network_interface_id = aws_network_interface.db_01_nic.id
    device_index         = 0
  }

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} DB 01"
        }
      )
    )
  )
}

##############################################################

resource "aws_network_interface" "db_02_nic" {
  subnet_id       = aws_subnet.db_subnet.id
  private_ips     = ["192.168.3.5"]
  security_groups = [aws_security_group.db_security_group.id]

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} DB 02 NIC"
        }
      )
    )
  )
}

resource "aws_instance" "db_02_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  user_data     = file("./init_back.sh")

  network_interface {
    network_interface_id = aws_network_interface.db_02_nic.id
    device_index         = 0
  }

  tags = (
    merge(
      local.common_tags,
      tomap(
        {
          "Name" = "${var.project_name} DB 02"
        }
      )
    )
  )
}
