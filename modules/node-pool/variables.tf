variable "project" {
  description = "The ID or project number of the Google Cloud project."
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
}

variable "name" {
  description = "The prefix name of the node pool."
  type        = string
  default     = ""
}

variable "environment" {
  description = "The environment in which the resources are being deployed."
  type        = string
}

variable "location" {
  description = "The location/region of the GKE cluster and node pool."
  type        = string
}

variable "kubernetes_version" {
  description = "The desired Kubernetes version for the GKE cluster and node pool."
  type        = string
}

variable "initial_node_count" {
  description = "The initial number of nodes in the GKE node pool."
  type        = number
}

variable "node_locations" {
  description = "The locations for the GKE node pool's nodes."
  type        = list(string)
}

# Autoscaling settings
variable "min_count" {
  description = "The minimum number of nodes in the GKE node pool."
  type        = number
}

variable "max_count" {
  description = "The maximum number of nodes in the GKE node pool."
  type        = number
}

variable "max_surge" {
  description = "The maximum number of nodes that can be created beyond the desired size during an upgrade."
  type        = number
  default     = 1
}

variable "max_unavailable" {
  description = "The maximum number of nodes that can be unavailable during an upgrade."
  type        = number
  default     = 0
}

# Node pool configuration
variable "preemptible" {
  description = "Whether to create preemptible VM instances for the GKE node pool."
  type        = bool
  default     = false
}

variable "instance_type" {
  description = "The machine type for the GKE node pool instances."
  type        = string
}

variable "disk_size_gb" {
  description = "The size of the disks for the GKE node pool instances."
  type        = number
  default     = 50
}

variable "disk_type" {
  description = "The type of disks for the GKE node pool instances (e.g. pd-standard, pd-balanced, pd-ssd)."
  type        = string
  default     = "pd-standard"
}

variable "tags" {
  description = "The network tags to attach to the GKE node pool instances."
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "The labels to attach to the GKE node pool instances."
  type        = map(string)
  default     = {}
}

variable "service_account" {
  description = "Service account for the default node pool."
  type        = string
}

# Security and metadata settings
variable "boot_disk_kms_key" {
  description = "The KMS key for encrypting the boot disk."
  type        = string
  default     = ""
}

variable "enable_secure_boot" {
  description = "Enable secure boot for node instances."
  type        = bool
  default     = false
}

variable "enable_integrity_monitoring" {
  description = "Enable integrity monitoring for node instances."
  type        = bool
  default     = true
}

variable "workload_metadata_config" {
  description = "Configuration for workload identity."
  type        = string
  default     = "GKE_METADATA"
}

variable "additional_metadata" {
  description = "Additional metadata for node instances."
  type        = map(string)
  default     = {}
}

# Node management settings
variable "auto_repair" {
  description = "Enable automatic repair of nodes."
  type        = bool
  default     = true
}

variable "auto_upgrade" {
  description = "Enable automatic upgrades of nodes."
  type        = bool
  default     = true
}

variable "image_type" {
  description = "Image type for the node instances."
  type        = string
  default     = "COS_CONTAINERD"
}

variable "node_pools_taints" {
  description = "Map of lists containing node taints by node-pool name."
  type        = map(list(object({ key = string, value = string, effect = string })))
  default     = { all = [] }
}

variable "node_pools_oauth_scopes" {
  description = "Map of lists containing node oauth scopes by node-pool name."
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/trace.append",
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

variable "max_pods_per_node" {
  description = "The maximum number of pods per node in the GKE node pool."
  type        = number
  default     = 110
}
