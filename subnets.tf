# Subnets
resource "aws_subnet" "public" {
  for_each                = var.public_subnet_cidrs
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.org}-${var.app}-${var.env}-public-subnet-${each.key}"
    Tier = "public"
  }
}

resource "aws_subnet" "private" {
  for_each          = var.private_subnet_cidrs
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name = "${var.org}-${var.app}-${var.env}-private-subnet-${each.key}"
    Tier = "private"
  }
}

resource "aws_subnet" "database" {
  for_each          = var.database_subnet_cidrs
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name = "${var.org}-${var.app}-${var.env}-database-subnet-${each.key}"
    Tier = "database"
  }
}