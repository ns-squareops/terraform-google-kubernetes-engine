provider "kubernetes" {
  host  = "${module.gke.endpoint}"
  token = base64encode(data.google_client_config.default.access_token)
  cluster_ca_certificate = base64decode(
    module.gke.ca_certificate
  )
}

resource "kubernetes_cluster_role_binding" "cluster-admin" {
  metadata {
    name = "cluster-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "Group"
    name      = "system:masters"
    api_group = "rbac.authorization.k8s.io"
  }
    subject {
    kind      = "Group"
    name      = "org-gke-admins@squareops.com"
    api_group = "rbac.authorization.k8s.io"
  }
}


resource "kubernetes_cluster_role" "cluster-rw" {
  metadata {
    name = "cluster-rw"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
  }
  rule {
    non_resource_urls = ["*"]
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
  }

}

resource "kubernetes_cluster_role_binding" "cluster-rw" {
  metadata {
    name = "cluster-rw"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-rw"
  }
    subject {
    kind      = "Group"
    name      = "org-gke-editors@squareops.com"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role" "cluster-ro" {
  metadata {
    name = "cluster-ro"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    non_resource_urls = ["*"]
    verbs      = ["get", "list", "watch"]
  }

}

resource "kubernetes_cluster_role_binding" "cluster-ro" {
  metadata {
    name = "cluster-ro"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-ro"
  }
    subject {
    kind      = "Group"
    name      = "org-gke-readonly@squareops.com"
    api_group = "rbac.authorization.k8s.io"
  }
}
