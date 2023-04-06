resource "aws_security_group" "aurora_vpc_security_group" {
  name        = "${var.tags["env"]}-${var.tags["projectname"]}-aurora-sg"
  description = "Default Aurora security group to allow inbound"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, tomap(
    {
      Name = "${var.tags["env"]}-${var.tags["projectname"]}-aurora-sg"
    }
  ))
}

resource "aws_security_group_rule" "allow_3306_from_pvt_subnets" {
  description       = "allow 3306 from pvt subnets"
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.aurora_vpc_security_group.id
  cidr_blocks       = var.private_subnets
}

resource "aws_security_group_rule" "ingress_from_vpn" {
  description       = "allow 3306 from VPN"
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.aurora_vpc_security_group.id
  cidr_blocks       = var.public_subnets
}













