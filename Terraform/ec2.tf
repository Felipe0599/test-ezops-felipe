resource "aws_instance" "kubernetes" {
  ami                    = "ami-005fc0f236362e99f"
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  key_name               = var.ec2_key_name

  user_data = "${file("${path.module}/../Kubernetes/setup_k0s.sh")}"
  tags = {
    Name = "test-felipe-kubernetes"
  }

  lifecycle {
    create_before_destroy = false
    prevent_destroy = true
  }
}

resource "aws_instance" "docker-compose" {
  ami                    = "ami-005fc0f236362e99f"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  key_name               = var.ec2_key_name

  user_data = "${file("${path.module}/../Kubernetes/setup_compose.sh")}"

  tags = {
    Name = "test-felipe-docker-compose"
  }
}
