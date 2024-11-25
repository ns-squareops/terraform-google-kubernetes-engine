locals {
  region       = "asia-south1"
  environment  = "dev"
  name         = "org"
  project_name = "atmosly-439606"
  project      = "atmosly-439606"
}

module "gke" {
  source                  = "../../"
  project_name             = local.project_name
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
  master_authorized_networks = ""
  default_np_instance_type   = "e2-medium" #"e2-standard-2" #"e2-medium"
  default_np_max_count       = 5
  default_np_preemptible     = true
  deletion_protection        = false
  
}


# module "managed_node_pool" {
#   source             = "../../modules/node-pool"
#   depends_on         = [module.gke]
#   project            = local.project
#   cluster_name       = module.gke.cluster_name
#   name               = "app"
#   environment        = local.environment
#   location           = local.region
#   kubernetes_version = "1.30"
#   service_account    = module.gke.service_accounts_gke
#   initial_node_count = 1
#   min_count          = 1
#   max_count          = 5
#   node_locations     = ["asia-south1-a"] # , "asia-south1-b", "asia-south1-c"]
#   preemptible        = true
#   instance_type      = "e2-standard-2"
#   disk_size_gb       = 50
#   labels = {
#     "Addons-Services" : true
#   }
# }
