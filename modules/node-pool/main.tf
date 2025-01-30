resource "google_container_node_pool" "node_pool" {
  name               = format("%s-%s-node-pool", var.name, var.environment)
  location           = var.location
  cluster            = var.cluster_name
  project            = var.project
  max_pods_per_node  = var.max_pods_per_node
  version            = var.kubernetes_version
  initial_node_count = var.initial_node_count
  node_locations     = var.node_locations
  autoscaling {
    min_node_count = var.min_count
    max_node_count = var.max_count
  }

  upgrade_settings {
    max_surge       = var.max_surge
    max_unavailable = var.max_unavailable
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }
  management {
    auto_repair  = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }

  node_config {
    preemptible       = var.preemptible
    machine_type      = var.instance_type
    disk_size_gb      = var.disk_size_gb
    disk_type         = var.disk_type
    image_type        = var.image_type
    boot_disk_kms_key = var.boot_disk_kms_key
    service_account   = var.service_account
    oauth_scopes      = var.node_pools_oauth_scopes
    tags              = var.tags
    labels            = var.labels

    metadata = merge(
      {
        "disable-legacy-endpoints" = "true"
      },
      var.additional_metadata
    )

    dynamic "taint" {
      for_each = lookup(var.node_pools_taints, "all", [])
      content {
        effect = taint.value.effect
        key    = taint.value.key
        value  = taint.value.value
      }
    }

    shielded_instance_config {
      enable_secure_boot          = var.enable_secure_boot
      enable_integrity_monitoring = var.enable_integrity_monitoring
    }

    workload_metadata_config {
      mode = var.workload_metadata_config
    }
  }
}
