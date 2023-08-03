resource "aws_security_group" "edge" {
  name = "${var.identifier}-sg-edge"

  tags = {
    "Name" = "${var.identifier}-sg-edge"
    "Type" = "edge"
  }

  vpc_id = var.network.vpc.id
}
resource "aws_security_group_rule" "edge_ingress" {
  security_group_id = aws_security_group.edge.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "edge traffic"
  cidr_blocks       = var.edge_ips
}
