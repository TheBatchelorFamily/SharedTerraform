# Get VPC details to use its CIDR block
data "aws_vpc" "webserver" {
  id = var.vpc
}

# Get available AZs in the region
data "aws_availability_zones" "available" {
  state = "available"
}

# Create subnets in multiple AZs for high availability and capacity flexibility
resource "aws_subnet" "webserver" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = var.vpc
  cidr_block        = cidrsubnet(data.aws_vpc.webserver.cidr_block, 8, 10 + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "webserver-subnet-${data.aws_availability_zones.available.names[count.index]}"
    }
  )
}
