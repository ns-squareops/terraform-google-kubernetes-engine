locals {
  region       = "asia-south1"
  environment  = "dev"
  name         = "org"
  project_name = "atmosly-439606"
  project      = "atmosly-439606"
}

module "gke" {
  source                  = "../../"
  project_name            = local.project_name
  name                    = local.name
  region                  = local.region
  environment             = local.environment
  gke_zones               = ["asia-south1-a"] #, "asia-south1-b", "asia-south1-c"]
  vpc_name                = "atmosly-vpc"
  subnet                  = "dev-atmosly-subnet"
  kubernetes_version      = "1.30"
  enable_private_endpoint = false
  # database_encryption = [{
  #   state    = "ENCRYPTED"
  #   key_name = "" #name of a CloudKMS key
  # }]
  master_authorized_networks       = ""          #Pass a cidr here when enable_private_endpoint is true
  default_np_instance_type         = "e2-medium" #"e2-standard-2" #"e2-medium"
  default_np_max_count             = 5
  default_np_preemptible           = false
  deletion_protection              = false
  spot_enabled                     = true  # Keep it false if preemptible is true
  vertical_pod_autoscaling_enabled = false # Keep it true if you want to use vertical pod autoscaling
  cluster_autoscaling = {
    enabled                     = false # keep it true if you want to use node pool autoscaling
    autoscaling_profile         = "BALANCED"
    max_cpu_cores               = 8
    min_cpu_cores               = 1
    max_memory_gb               = 16
    min_memory_gb               = 1
    gpu_resources               = []
    auto_repair                 = true
    auto_upgrade                = true
    disk_size                   = 50
    disk_type                   = "pd-standard"
    image_type                  = "COS_CONTAINERD"
    enable_secure_boot          = false
    enable_integrity_monitoring = true
  }
}


module "managed_node_pool" {
  source             = "../../modules/node-pool"
  depends_on         = [module.gke]
  project            = local.project
  cluster_name       = module.gke.cluster_name
  name               = "app"
  environment        = local.environment
  location           = local.region
  kubernetes_version = "1.30"
  service_account    = module.gke.service_accounts_gke
  initial_node_count = 1
  min_count          = 1
  max_count          = 5
  node_locations     = ["asia-south1-a"] # , "asia-south1-b", "asia-south1-c"]
  preemptible        = true
  instance_type      = "e2-medium"
  disk_size_gb       = 50
  disk_type          = "pd-standard"
  image_type         = "COS_CONTAINERD"
  boot_disk_kms_key  = "" # Can be modified if required
  max_surge          = 1
  max_unavailable    = 0
  enable_secure_boot = false
  auto_repair        = true
  auto_upgrade       = true
  # Metadata & Labels
  labels = {
    "Addons-Services" = true
  }
  tags = ["gke-node-pool", "env-${local.environment}"]

  # Node Taints (if applicable)
  node_pools_taints = {
    all = []
  }
}
