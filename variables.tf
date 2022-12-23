
variable "account_id" {
  default = "406883836544"
}

variable "region" {
  default = "eu-west-2"
}

variable "app_name" {
  default = "openstor"
}

variable "app_container_port" {
  default = 80
}

variable "app_host_port" {
  default = 80
}

variable "subnet_definition" {
  default = {
    sub-1 = {
      az   = "eu-west-2a",
      cidr = "10.0.1.0/24",
      name = "private-a"
    },
    # sub-2 = {
    #   az   = "eu-west-2b",
    #   cidr = "10.0.2.0/24",
    #   name = "private-b"
    # },
    # sub-3 = {
    #   az   = "eu-west-2c",
    #   cidr = "10.0.3.0/24",
    #   name = "private-c"
    # },
    sub-11 = {
      az   = "eu-west-2a",
      cidr = "10.0.11.0/24",
      name = "public-a"
    }
    # sub-12 = {
    #   az   = "eu-west-2b",
    #   cidr = "10.0.12.0/24",
    #   name = "public-b"
    # },
    # sub-13 = {
    #   az   = "eu-west-2c",
    #   cidr = "10.0.13.0/24",
    #   name = "public-c"
    # }
  }
  type = map(any)
}
