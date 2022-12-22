variable "subnet_definition" {
  default = {
    sub-1 = {
      az   = "eu-west-2a",
      cidr = "10.0.1.0/24",
      name = "private-2a"
    },
    # sub-2 = {
    #   az   = "eu-west-2b",
    #   cidr = "10.0.2.0/24",
    #   name = "private-2b"
    # },
    # sub-3 = {
    #   az   = "eu-west-2c",
    #   cidr = "10.0.3.0/24",
    #   name = "private-2c"
    # },
    sub-11 = {
      az   = "eu-west-2a",
      cidr = "10.0.11.0/24",
      name = "public-2a"
    }
    # sub-12 = {
    #   az   = "eu-west-2b",
    #   cidr = "10.0.12.0/24",
    #   name = "public-2b"
    # },
    # sub-13 = {
    #   az   = "eu-west-2c",
    #   cidr = "10.0.13.0/24",
    #   name = "public-2c"
    # }
  }
  type = map(any)
}
