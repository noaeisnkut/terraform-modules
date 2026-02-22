variable "zone_name" {}
variable "resource_group_name" {}
variable "alb_public_ip" {}
variable "argocd_record_name" {}
variable "flask_record_name" {}
variable "ttl" {
  type    = number
  default = 300
}