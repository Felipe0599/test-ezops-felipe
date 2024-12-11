output "kubernetes_public_ip" {
  value = aws_instance.kubernetes.public_ip
}

output "docker-compose_public_ip" {
  value = aws_instance.docker-compose.public_ip
}