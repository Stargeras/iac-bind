resource "helm_release" "bind" {
  name             = "bind"
  namespace        = "${var.bind_namespace}"
  chart            = "${path.root}/helm/bind"
  create_namespace = true

  values = [
    "${file("${path.root}/records.yaml")}"
  ]

  set {
    name  = "service.type"
    value = "${var.bind_service_type}"
  }

  set {
    name  = "domain.name"
    value = "${var.bind_domain_name}"
  }

  set {
    name  = "domain.forwarders"
    value = "${var.bind_domain_forwarders}"
  }

  set {
    name  = "replicaCount"
    value = "${var.bind_replicas}"
  }
}