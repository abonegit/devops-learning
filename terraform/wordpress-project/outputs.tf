output "wordpress_public_ip" {
  description = "Public IP address of the WordPress server"
  value       = aws_instance.wordpress.public_ip
}

output "wordpress_public_dns" {
  description = "Public DNS name of the WordPress server"
  value       = aws_instance.wordpress.public_dns
}

output "wordpress_url" {
  description = "URL for the WordPress website"
  value       = "http://${aws_instance.wordpress.public_ip}"
}