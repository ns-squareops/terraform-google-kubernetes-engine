locals {
  region           = var.region
  project          = var.project_name
  environment      = var.environment
  gke_zones_string = join(",", var.gke_zones)
  autoscaling_resource_limits = var.cluster_autoscaling.enabled ? concat([
    {
      resource_type = "cpu"
      minimum       = var.cluster_autoscaling.min_cpu_cores
      maximum       = var.cluster_autoscaling.max_cpu_cores
    },
    {
      resource_type = "memory"
      minimum       = var.cluster_autoscaling.min_memory_gb
      maximum       = var.cluster_autoscaling.max_memory_gb
    }
  ], var.cluster_autoscaling.gpu_resources) : []
}

data "google_client_config" "default" {}

module "service_accounts_gke" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 4.0"
  project_id = local.project
  prefix     = var.name
  names      = [local.environment]
  project_roles = [
    "${local.project}=>roles/monitoring.viewer",
    "${local.project}=>roles/monitoring.metricWriter",
    "${local.project}=>roles/logging.logWriter",
    "${local.project}=>roles/stackdriver.resourceMetadata.writer",
    "${local.project}=>roles/storage.objectViewer",
    "${local.project}=>roles/artifactregistry.admin",
    "${local.project}=>roles/cloudkms.cryptoKeyEncrypterDecrypter",
  ]
  display_name = format("%s-%s-gke-cluster Nodes Service Account", var.name, local.environment)
}

module "gke" {
  source                                   = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version                                  = "35.0.1"
  project_id                               = local.project
  name                                     = format("%s-%s-gke-cluster", var.name, local.environment)
  regional                                 = var.regional
  region                                   = local.region
  zones                                    = var.gke_zones
  network                                  = var.vpc_name
  subnetwork                               = var.subnet
  master_global_access_enabled             = var.master_global_access_enabled
  ip_range_pods                            = var.ip_range_pods_name
  ip_range_services                        = var.ip_range_services_name
  release_channel                          = var.release_channel
  kubernetes_version                       = var.kubernetes_version
  http_load_balancing                      = var.enable_http_load_balancing
  deletion_protection                      = var.deletion_protection
  network_policy                           = var.network_policy
  network_policy_provider                  = var.network_policy_provider
  enable_private_endpoint                  = var.enable_private_endpoint
  enable_private_nodes                     = var.enable_private_nodes
  master_ipv4_cidr_block                   = var.master_ipv4_cidr_block
  gke_backup_agent_config                  = var.gke_backup_agent_config
  database_encryption                      = var.database_encryption
  create_service_account                   = var.create_service_account
  remove_default_node_pool                 = var.remove_default_node_pool
  master_authorized_networks               = var.enable_private_endpoint ? [{ cidr_block = var.master_authorized_networks, display_name = "VPN IP" }] : []
  logging_service                          = var.logging_service
  logging_enabled_components               = var.logging_enabled_components
  monitoring_service                       = var.monitoring_service
  monitoring_enabled_components            = var.monitoring_enabled_components
  enable_vertical_pod_autoscaling          = var.vertical_pod_autoscaling_enabled
  horizontal_pod_autoscaling               = var.enable_horizontal_pod_autoscaling
  cluster_resource_labels                  = var.cluster_resource_labels
  enable_shielded_nodes                    = var.enable_shielded_nodes
  enable_binary_authorization              = var.enable_binary_authorization
  enable_cost_allocation                   = var.enable_cost_management
  enable_cilium_clusterwide_network_policy = var.enable_cilium_clusterwide_network_policy
  enable_intranode_visibility              = var.enable_intranode_visibility
  enable_kubernetes_alpha                  = var.enable_kubernetes_alpha
  enable_l4_ilb_subsetting                 = var.enable_l4_ilb_subsetting
  enable_tpu                               = var.enable_tpu

  cluster_autoscaling = {
    enabled                     = var.cluster_autoscaling.enabled
    autoscaling_profile         = var.cluster_autoscaling.autoscaling_profile
    min_cpu_cores               = var.cluster_autoscaling.min_cpu_cores
    max_cpu_cores               = var.cluster_autoscaling.max_cpu_cores
    min_memory_gb               = var.cluster_autoscaling.min_memory_gb
    max_memory_gb               = var.cluster_autoscaling.max_memory_gb
    gpu_resources               = var.cluster_autoscaling.gpu_resources
    auto_repair                 = var.cluster_autoscaling.auto_repair
    auto_upgrade                = var.cluster_autoscaling.auto_upgrade
    disk_size                   = var.cluster_autoscaling.disk_size
    disk_type                   = var.cluster_autoscaling.disk_type
    image_type                  = var.cluster_autoscaling.image_type
    strategy                    = var.cluster_autoscaling.strategy
    max_surge                   = var.cluster_autoscaling.max_surge
    max_unavailable             = var.cluster_autoscaling.max_unavailable
    enable_secure_boot          = var.cluster_autoscaling.enable_secure_boot
    enable_integrity_monitoring = var.cluster_autoscaling.enable_integrity_monitoring
  }

  node_pools = [
    {
      name               = format("%s-%s-node-pool", var.default_np_name, local.environment)
      machine_type       = var.default_np_instance_type
      node_locations     = local.gke_zones_string
      min_count          = var.default_np_min_count
      max_count          = var.default_np_max_count
      local_ssd_count    = var.default_np_local_ssd_count
      disk_size_gb       = var.default_np_disk_size_gb
      enable_secure_boot = var.enable_secure_boot
      disk_type          = var.disk_type
      image_type         = var.node_pool_image_type
      auto_repair        = var.node_pool_auto_repair
      auto_upgrade       = var.node_pool_auto_upgrade
      preemptible        = var.default_np_preemptible
      spot               = var.spot_enabled
      initial_node_count = var.default_np_initial_node_count
      service_account    = module.service_accounts_gke.email
      enable_gcfs        = var.enable_gcfs
      enable_gvnic       = var.enable_gvnic
      boot_disk_kms_key  = var.boot_disk_kms_key
    }
  ]

  node_pools_oauth_scopes = var.node_pools_oauth_scopes

  node_pools_labels = {
    all = {}

    format("%s-%s-node-pool", var.default_np_name, local.environment) = {
      "Addon-Services" = true
    }
  }

  node_pools_metadata = {
    all = {}
  }

  node_pools_taints = {
    all = []
  }

  node_pools_tags = {
    all = []
  }
}
