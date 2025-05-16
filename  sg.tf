#############################
#   Public Secutity Group
#############################
resource "aws_security_group" "public" {

  name        = "${var.org}-${var.app}-${var.env}-public-sg"
  description = "Public Subnet Access"
  vpc_id      = aws_vpc.main.id

  tags = {
    Environment = "${var.org}-${var.app}-${var.env}-public-sg"
  }
}

resource "aws_security_group_rule" "public_inbound_http" {
  security_group_id = aws_security_group.public.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTP from anywhere"
}

resource "aws_security_group_rule" "public_inbound_https" {
  security_group_id = aws_security_group.public.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTPS from anywhere"
}

resource "aws_security_group_rule" "public_inbound_ssh" {
  security_group_id = aws_security_group.public.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow SSH from anywhere"
}

resource "aws_security_group_rule" "public_outbound_all" {
  security_group_id = aws_security_group.public.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}


###############################
#   Private Secutity Group
###############################
resource "aws_security_group" "private" {

  name        = "${var.org}-${var.app}-${var.env}-private-sg"
  description = "Private Subnet Access"
  vpc_id      = aws_vpc.main.id

  tags = {
    Environment = "${var.org}-${var.app}-${var.env}-private-sg"
  }
}

resource "aws_security_group_rule" "private_inbound_ssh_from_public" {
  for_each          = var.public_subnet_cidrs
  security_group_id = aws_security_group.private.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = [each.value]
  description       = "Allow SSH from public subnet ${each.key}"
}

resource "aws_security_group_rule" "private_inbound_http_from_public" {
  for_each          = var.public_subnet_cidrs
  security_group_id = aws_security_group.private.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = [each.value]
  description       = "Allow HTTP from public subnet ${each.key}"
}

resource "aws_security_group_rule" "private_inbound_https_from_public" {
  for_each          = var.public_subnet_cidrs
  security_group_id = aws_security_group.private.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = [each.value]
  description       = "Allow HTTPS from public subnet ${each.key}"
}

resource "aws_security_group_rule" "private_outbound_all" {
  security_group_id = aws_security_group.private.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}

###############################
#   Database Secutity Group
###############################
resource "aws_security_group" "database" {

  name        = "${var.org}-${var.app}-${var.env}-database-sg"
  description = "Database Subnet Access"
  vpc_id      = aws_vpc.main.id

  tags = {
    Environment = "${var.org}-${var.app}-${var.env}-database-sg"
  }
}

resource "aws_security_group_rule" "database_inbound_from_private" {
  for_each          = var.private_subnet_cidrs
  security_group_id = aws_security_group.database.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
  cidr_blocks       = [each.value]
  description       = "Allow MySQL from private subnet ${each.key}"
}

resource "aws_security_group_rule" "database_outbound_to_private" {
  for_each          = var.private_subnet_cidrs
  security_group_id = aws_security_group.database.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = [each.value]
  description       = "Allow all TCP to private subnet ${each.key}"
}