output "instance_ip" {
  description = "IP Publico"
  value       = aws_instance.ec2.public_ip
}
