variable "aws_profile" {
  default = "admin"
}
variable "region" {
  description = "Region"
  type        = string
  default     = "eu-north-1"
}
variable "instance_name" {
  description = "Instanse Name"
  type        = string
  default     = "public_instance"
}
variable "volume_size" {
  description = "Volume Size"
  type        = number
  default     = 10
}
variable "volume_type" {
  description = "Volume Type"
  type        = string
  default     = "gp2"
}