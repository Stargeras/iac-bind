module "bind" {
  source         = "./module-bind"
  kubeconfig     = var.kubeconfig
  bind_image     = var.bind_image
  bind_namespace = var.bind_namespace
  bind_replicas  = var.bind_replicas
}