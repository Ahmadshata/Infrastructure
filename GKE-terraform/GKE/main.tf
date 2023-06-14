
resource "google_container_cluster" "primary" {
  name     = var.cluster-name
  location = var.cluster-zone
  network                  = var.vpc-uri
  subnetwork               = var.subnet-uri

  ip_allocation_policy {
    #the cluster's subnetwork to use for pod and services IP addresses.
    #Alternatively, cluster_ipv4_cidr_block can be used to automatically create a GKE-managed one.
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false

    master_ipv4_cidr_block  = var.master-cidr
  }

  master_authorized_networks_config {
    cidr_blocks {
    cidr_block   = var.authorized-cidr-1
    display_name = var.authorized-network-name-1
        }
    cidr_blocks {
    cidr_block   = var.authorized-cidr-2
    display_name = var.authorized-network-name-2
        }
    }

#to configure Kubernetes workloads with GCP service accounts.
  workload_identity_config {
  workload_pool = "shata-387907.svc.id.goog"
  }

  release_channel {
    channel = "REGULAR"
  }

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "node-pool" {
  name       = "my-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.id
  node_count = var.node-pool-count
  
   management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = var.node-pool-machine_type
    workload_metadata_config {
      mode = "GKE_METADATA"
  }
  }
}

