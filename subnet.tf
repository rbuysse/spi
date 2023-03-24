data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.66.0.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "foo"
  }
}
