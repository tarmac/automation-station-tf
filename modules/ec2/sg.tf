resource "aws_security_group" "vpn" {
  name        = "sgrp-${var.tags["env"]}-${var.tags["projectname"]}-sgrp"
  description = "Security group for ${var.tags["env"]}-${var.tags["projectname"]}}"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = "true"
  }

  tags = merge(
    {
      "Name" = "sg-${var.tags["env"]}-${var.tags["projectname"]}}"
    },
    var.tags,
  )
}

resource "aws_security_group_rule" "ssh" {
  description       = "ssh from out"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.vpn.id
  cidr_blocks       = [var.static_ip]
}

resource "aws_security_group_rule" "udp" {
  description       = "openvpn port"
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "UDP"
  security_group_id = aws_security_group.vpn.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "world" {
  description       = "to world"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.vpn.id
  cidr_blocks       = ["0.0.0.0/0"]
}
