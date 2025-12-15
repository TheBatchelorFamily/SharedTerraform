# Get available AZs in the region
data "aws_availability_zones" "available" {
  state  = "available"
  region = var.region
}

# Create subnets in multiple AZs for high availability and capacity flexibility
resource "aws_subnet" "webserver" {
  count             = min(length(data.aws_availability_zones.available.names), 3)
  vpc_id            = var.vpc
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "webserver-subnet-${data.aws_availability_zones.available.names[count.index]}"
    }
  )
}
