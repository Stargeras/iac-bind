variable "kubeconfig" {
  type    = string
  default = "~/.kube/config"
}

variable "bind_image" {
  type    = string
  default = "ubuntu/bind9"
}
variable "bind_namespace" {
  type    = string
  default = "bind"
}
variable "bind_replicas" {
  type    = number
  default = 1
}