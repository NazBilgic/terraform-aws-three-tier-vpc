# Public NACL
resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.org}-${var.app}-${var.env}-public-nacl"
  }
}

resource "aws_network_acl_rule" "public_inbound_http" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "public_inbound_https" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "public_inbound_ssh" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "public_inbound_ephemeral" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 130
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "public_outbound_all" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_association" "public" {
  for_each       = var.public_subnet_cidrs
  subnet_id      = aws_subnet.public[each.key].id
  network_acl_id = aws_network_acl.public.id
}

# Private NACL
resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.org}-${var.app}-${var.env}-private-nacl"
  }
}

resource "aws_network_acl_rule" "private_inbound_from_public" {
  for_each       = var.public_subnet_cidrs
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100 + index(keys(var.public_subnet_cidrs), each.key) * 10
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.value
  from_port      = 0
  to_port        = 65535
}

resource "aws_network_acl_rule" "private_inbound_ephemeral" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "private_outbound_all" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_association" "private" {
  for_each       = var.private_subnet_cidrs
  subnet_id      = aws_subnet.private[each.key].id
  network_acl_id = aws_network_acl.private.id
}

# Database NACL
resource "aws_network_acl" "database" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.org}-${var.app}-${var.env}-database-nacl"
  }
}

resource "aws_network_acl_rule" "database_inbound_from_private" {
  for_each       = var.private_subnet_cidrs
  network_acl_id = aws_network_acl.database.id
  rule_number    = 100 + index(keys(var.private_subnet_cidrs), each.key) * 10
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.value
  from_port      = 3306
  to_port        = 3306
}

resource "aws_network_acl_rule" "database_inbound_ephemeral" {
  network_acl_id = aws_network_acl.database.id
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "database_outbound_to_private" {
  for_each       = var.private_subnet_cidrs
  network_acl_id = aws_network_acl.database.id
  rule_number    = 100 + index(keys(var.private_subnet_cidrs), each.key) * 10
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = each.value
  from_port      = 0
  to_port        = 65535
}

resource "aws_network_acl_association" "database" {
  for_each       = var.database_subnet_cidrs
  subnet_id      = aws_subnet.database[each.key].id
  network_acl_id = aws_network_acl.database.id
}