resource "aws_eip" "default" {
  vpc      = var.vpc
  instance = var.instance
  tags = {
    Name = var.name
  }
}
