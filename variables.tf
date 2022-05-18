variable "kubeconfig" {
  type    = string
  default = "~/.kube/config"
}
variable "bind_domain_name" {
  type    = string
  default = "local.domain"
}
variable "bind_domain_forwarders" {
  type    = string
  default = "23.82.1.1"
}
variable "bind_namespace" {
  type    = string
  default = "bind"
}
variable "bind_replicas" {
  type    = number
  default = 1
}
variable "bind_service_type" {
  type    = string
  default = "LoadBalancer"
}
