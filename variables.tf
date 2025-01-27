variable "project_name" {
  description = "The ID or project number of the Google Cloud project."
  type        = string
  default     = ""
}

variable "environment" {
  description = "The environment in which the resources are being deployed."
  type        = string
  default     = ""
}

variable "deletion_protection" {
  description = "Deletion protection of cluster"
  type        = string
  default     = "false"
}

variable "name" {
  description = "The suffix name for the resources being created."
  type        = string
}

variable "regional" {
  type        = bool
  description = "Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!)"
  default     = true
}

variable "region" {
  type        = string
  description = "The region to host the cluster in (optional if zonal cluster / required if regional)"
  default     = null
}

variable "gke_zones" {
  type        = list(string)
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)"
  default     = []
}

variable "vpc_name" {
  description = "The name of the VPC network where the GKE cluster will be created."
  type        = string
  default     = ""
}

variable "subnet" {
  description = "The name of the subnet within the VPC network for the GKE cluster."
  type        = string
  default     = ""
}

variable "cluster_resource_labels" {
  type        = map(string)
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster"
  default     = {}
}

variable "ip_range_pods_name" {
  description = "The name of the IP range for pods in the GKE cluster."
  type        = string
  default     = ""
}

variable "ip_range_services_name" {
  description = "The name of the IP range for services in the GKE cluster."
  type        = string
  default     = ""
}

variable "release_channel" {
  description = "The release channel of the cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `UNSPECIFIED`."
  type        = string
  default     = "STABLE"
}

variable "kubernetes_version" {
  description = "The desired Kubernetes version for the GKE cluster."
  type        = string
  default     = "1.25"
}

variable "enable_private_endpoint" {
  description = "Whether to enable the private endpoint for the GKE cluster."
  type        = bool
  default     = false
}

variable "enable_private_nodes" {
  description = "Whether to enable private nodes for the GKE cluster."
  type        = bool
  default     = true
}
variable "master_ipv4_cidr_block" {
  type        = string
  description = "(Beta) The IP range in CIDR notation to use for the hosted master network"
  default     = "10.0.0.0/28"
}

variable "master_authorized_networks" {
  description = "Authorized networks for GKE master."
  default     = ""
  type        = string
}

variable "master_global_access_enabled" {
  type        = bool
  description = "Whether the cluster master is accessible globally (from any region) or only within the same region as the private endpoint."
  default     = true
}

variable "network_policy" {
  type        = bool
  description = "Enable network policy addon"
  default     = false
}

variable "database_encryption" {
  description = "Application-layer Secrets Encryption settings. The object format is {state = string, key_name = string}. Valid values of state are: \"ENCRYPTED\"; \"DECRYPTED\". key_name is the name of a CloudKMS key."
  type        = list(object({ state = string, key_name = string }))

  default = [{
    state    = "DECRYPTED"
    key_name = ""
  }]
}

variable "network_policy_provider" {
  type        = string
  description = "The network policy provider."
  default     = "CALICO"
}

variable "gke_backup_agent_config" {
  type        = bool
  description = "Whether Backup for GKE agent is enabled for this cluster."
  default     = false
}

variable "logging_service" {
  description = "The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none"
  type        = string
  default     = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  description = "The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none"
  type        = string
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "monitoring_enabled_components" {
  type        = list(string)
  description = "List of services to monitor: SYSTEM_COMPONENTS, WORKLOADS (provider version >= 3.89.0). Empty list is default GKE configuration."
  default     = []
}

variable "logging_enabled_components" {
  type        = list(string)
  description = "List of services to monitor: SYSTEM_COMPONENTS, WORKLOADS. Empty list is default GKE configuration."
  default     = []
}

variable "remove_default_node_pool" {
  default     = true
  type        = bool
  description = "Remove default node pool"
}

variable "default_np_name" {
  description = "Name of the default node pool"
  type        = string
  default     = "addons"
}

variable "default_np_instance_type" {
  description = "Machine type for the default node pool"
  type        = string
  default     = "e2-medium"
}

variable "default_np_min_count" {
  description = "Minimum number of nodes for the default node pool"
  type        = number
  default     = 1
}

variable "default_np_max_count" {
  description = "Maximum number of nodes for the default node pool"
  type        = number
  default     = 3
}

variable "default_np_disk_size_gb" {
  description = "Disk size (in GB) for the default node pool"
  type        = number
  default     = 50
}

variable "enable_secure_boot" {
  description = "Enable secure boot for the default node pool"
  type        = bool
  default     = false
}

variable "disk_type" {
  description = "Disk type for the default node pool"
  type        = string
  default     = "pd-standard"
}

variable "default_np_preemptible" {
  description = "Enable preemptible instances for the default node pool"
  type        = bool
  default     = true
}

variable "spot_enabled" {
  description = "Enable spot instances for the default node pool"
  type        = bool
  default     = true
}

variable "default_np_initial_node_count" {
  description = "Initial number of nodes for the default node pool"
  type        = number
  default     = 1
}

variable "node_pools_oauth_scopes" {
  type        = map(list(string))
  description = "Map of lists containing node oauth scopes by node-pool name"

  # Default is being set in variables_defaults.tf
  default = {
    all = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

variable "cluster_autoscaling" {
  type = object({
    enabled                     = bool
    autoscaling_profile         = string
    min_cpu_cores               = number
    max_cpu_cores               = number
    min_memory_gb               = number
    max_memory_gb               = number
    gpu_resources               = list(object({ resource_type = string, minimum = number, maximum = number }))
    auto_repair                 = bool
    auto_upgrade                = bool
    disk_size                   = optional(number)
    disk_type                   = optional(string)
    image_type                  = optional(string)
    strategy                    = optional(string)
    max_surge                   = optional(number)
    max_unavailable             = optional(number)
    node_pool_soak_duration     = optional(string)
    batch_soak_duration         = optional(string)
    batch_percentage            = optional(number)
    batch_node_count            = optional(number)
    enable_secure_boot          = optional(bool, false)
    enable_integrity_monitoring = optional(bool, true)
  })
  default = {
    enabled                     = false
    autoscaling_profile         = "BALANCED"
    max_cpu_cores               = 0
    min_cpu_cores               = 0
    max_memory_gb               = 0
    min_memory_gb               = 0
    gpu_resources               = []
    auto_repair                 = true
    auto_upgrade                = true
    disk_size                   = 100
    disk_type                   = "pd-standard"
    image_type                  = "COS_CONTAINERD"
    enable_secure_boot          = false
    enable_integrity_monitoring = true
  }
  description = "Cluster autoscaling configuration. See [more details](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling)"
}
