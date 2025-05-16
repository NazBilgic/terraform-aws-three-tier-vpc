# NAT Gateways
resource "aws_nat_gateway" "main" {
  for_each      = aws_eip.nat
  allocation_id = each.value.id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name = "${var.org}-${var.app}-${var.env}-nat-gateway-${each.key}"
  }

  depends_on = [aws_internet_gateway.main]
}