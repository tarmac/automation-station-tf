resource "aws_instance" "vpn" {

  ami                         = var.instance_ami
  ebs_optimized               = true
  instance_type               = var.instance_type
  key_name                    = var.key_pair
  subnet_id                   = element(tolist(var.public_subnets), 0)
  vpc_security_group_ids      = [aws_security_group.vpn.id]
  disable_api_termination     = true
  associate_public_ip_address = true


  tags = merge(
    {
      "Name" = "${var.tags["env"]}-server"
    },
    var.tags,
  )

  volume_tags = merge(
    {
      "Name" = "vol-${var.tags["env"]}-server-root"
    },
    var.tags,
  )
}

resource "aws_eip" "vpn" {
  vpc        = true
  instance   = aws_instance.vpn.id
  depends_on = [aws_instance.vpn]

  tags = {
    Name = "${var.tags["env"]}-server-eip"
  }
}
