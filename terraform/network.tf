data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az_count = length(data.aws_availability_zones.available.names)
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.project_name}"
  }
}

resource "aws_subnet" "private" {
  count             = local.az_count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-private"
  }
}


resource "aws_subnet" "public" {
  count                   = local.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + local.az_count)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public"
  }
}
