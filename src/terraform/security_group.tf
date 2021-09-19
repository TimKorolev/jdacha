resource "aws_security_group" "youtrack_perf_security_group" {
  name = "${var.project}-${var.os}-${var.os_type}"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "youtrack_perf_access_22" {
  type = "ingress"
  security_group_id = aws_security_group.youtrack_perf_security_group.id
  from_port = 22
  to_port = 22
  protocol = "TCP"

  cidr_blocks = [
    "91.132.204.0/24",
    "94.19.114.0/24"]
}

resource "aws_security_group_rule" "youtrack_perf_access_80" {
  type = "ingress"
  security_group_id = aws_security_group.youtrack_perf_security_group.id
  from_port = 80
  to_port = 80
  protocol = "TCP"

  cidr_blocks = [
    "91.132.204.0/24",
    "94.19.114.0/24"]
}

resource "aws_security_group_rule" "youtrack_perf_access_8080" {
  type = "ingress"
  security_group_id = aws_security_group.youtrack_perf_security_group.id
  from_port = 8088
  to_port = 8088
  protocol = "TCP"

  cidr_blocks = [
    "91.132.204.0/24",
    "94.19.114.0/24"]
}
