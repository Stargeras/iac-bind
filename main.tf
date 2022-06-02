module "bind" {
  source                 = "./module-bind"
  kubeconfig             = var.kubeconfig
  bind_namespace         = var.bind_namespace
  bind_replicas          = var.bind_replicas
  bind_service_type      = var.bind_service_type
  bind_domain_name       = var.bind_domain_name
  bind_domain_forwarders = var.bind_domain_forwarders
}