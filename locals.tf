locals {
  my_public_ip = jsondecode(data.http.public_ip.body).ip
  common_tags = {
    Owner           = "Luis Gerardo Hernandez"
    OwnerEmail      = "gerardo.hernandez@improving.com"
    CreationDate    = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    EnvironmentType = "Practice"
  }
}
