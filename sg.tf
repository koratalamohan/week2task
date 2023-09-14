resource "aws_security_group" "sg" {
  count = var.feature_flag ? 1 : 0
  name  = "sg for webserver"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_sg" {
  count = var.feature_flag ? 1 : 0
  name  = "security group fo alb"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}