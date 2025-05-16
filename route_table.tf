########################
#     Public Routes 
########################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.org}-${var.app}-${var.env}-public-rt"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

########################
#     Private Routes 
########################

resource "aws_route_table" "private" {
  for_each = var.availability_zones
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = "${var.org}-${var.app}-${var.env}-private-rt-${each.key}"
  }
}

resource "aws_route" "private_nat" {
  for_each               = aws_route_table.private
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_route_table.private
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = each.value.id
}

########################
#     Database Routes 
########################
resource "aws_route_table" "database" {
  for_each = var.availability_zones
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = "${var.org}-${var.app}-${var.env}-database-rt-${each.key}"
  }
}

resource "aws_route" "database_nat" {
  for_each               = aws_route_table.database
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[each.key].id
}

resource "aws_route_table_association" "database" {
  for_each       = aws_route_table.database
  subnet_id      = aws_subnet.database[each.key].id
  route_table_id = each.value.id
}