# output "instance_public_ip" {
#   description = "The web instance Ip"
#   value       = aws_instance.node_instance.public_ip
#   sensitive = true
# }

output "Time_Date_Stamp" {
  description = "Time of execution"
  value       = timestamp()
}
