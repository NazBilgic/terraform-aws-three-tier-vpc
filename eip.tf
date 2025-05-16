 #Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  for_each = var.availability_zones
  domain   = "vpc"

  tags = {
    Name = "${var.org}-${var.app}-${var.env}-nat-eip-${each.key}"
  }
}


