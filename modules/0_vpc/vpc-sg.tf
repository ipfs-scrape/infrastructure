resource "aws_security_group" "internal" {
  name = "${var.identifier}-sg-internal"

  tags = {
    "Name" = "${var.identifier}-sg-internal"
    "Type" = "internal"
  }

  vpc_id = aws_vpc.deployment.id
}

resource "aws_security_group_rule" "environment_ingress" {
  security_group_id = aws_security_group.internal.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  description       = "intra-deployment traffic"

}
resource "aws_security_group_rule" "lb_hc_ingress" {
  security_group_id = aws_security_group.internal.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "intra-deployment traffic"
  cidr_blocks = [
    aws_vpc.deployment.cidr_block,
  ]
}

resource "aws_security_group_rule" "environment_egress" {
  security_group_id = aws_security_group.internal.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
