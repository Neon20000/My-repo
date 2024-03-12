output "public_ip" {
  value = aws_instance.public_instance.public_ip
}
data "aws_caller_identity" "current" {}
output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}