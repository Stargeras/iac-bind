provider "kubernetes" {
  config_paths = [
    "${var.kubeconfig}"
  ]
}

resource "kubernetes_namespace" "bind" {
    count = var.bind_namespace != "default" ? 1 : 0
    metadata {
        name = "${var.bind_namespace}"
    }
}

resource "kubernetes_config_map" "named-conf" {
    metadata {
        name = "named-conf"
        namespace = "${var.bind_namespace}"
    }
    data = {
        config = "${file("${path.root}/named.conf")}"
    }
    depends_on = [kubernetes_namespace.bind]
}

resource "kubernetes_config_map" "records-db" {
    metadata {
        name = "records-db"
        namespace = "${var.bind_namespace}"
    }
    data = {
        config = "${file("${path.root}/records.db")}"
    }
    depends_on = [kubernetes_namespace.bind]
}

resource "kubernetes_deployment" "bind" {
    metadata {
        name = "bind"
        namespace = "${var.bind_namespace}"
        labels = {
            app = "bind"
        }
    }
    spec {
        replicas = "${var.bind_replicas}"
        selector {
            match_labels = {
                app = "bind"
            }
        }
        template {
            metadata {
                labels = {
                    app = "bind"
                }
            }
            spec {
                container {
                    image = "${var.bind_image}"
                    name  = "bind"
                    volume_mount {
                        name = "named-conf"
                        mount_path = "/etc/bind/named.conf"
                        sub_path = "named.conf"
                    }
                    volume_mount {
                        name = "records-db"
                        mount_path = "/etc/bind/records.db"
                        sub_path = "records.db"
                    }
                }
                volume {
                    name = "named-conf"
                    config_map {
                        name = "named-conf"
                        items {
                            key = "config"
                            path = "named.conf"
                        }
                    }
                }
                volume {
                    name = "records-db"
                    config_map {
                        name = "records-db"
                        items {
                            key = "config"
                            path = "records.db"
                        }
                    }
                }
            }
        }
    }
    depends_on = [
        kubernetes_namespace.bind,
        kubernetes_config_map.named-conf,
        kubernetes_config_map.records-db,
    ]
}

resource "kubernetes_service" "bind" {
  metadata {
    name = "bind"
    namespace = "${var.bind_namespace}"
  }
  spec {
    selector = {
      app = "bind"
    }
    port {
      port        = 53
      target_port = 53
      protocol = "UDP"
      name = "bind-udp"
    }
    type = "LoadBalancer"
  }
  depends_on = [kubernetes_namespace.bind]
}

