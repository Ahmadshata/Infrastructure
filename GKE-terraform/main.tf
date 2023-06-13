module "network" {
    source                      = "./Network"
    vpc-name                    = "prod-vpc"
    subnet-name                 = "my-subnetwork"
    private-google-access       = true
    subnet-cidr                 = "10.0.0.0/16"
    subnet-region               = "us-central1"
    secondary-ip-range-1-name   = "k8s-pod-range"
    secondary-ip-range-1-cidr   = "10.1.0.0/24"
    secondary-ip-range-2-name   = "k8s-service-range"
    secondary-ip-range-2-cidr   = "10.2.0.0/26"
    router-name                 = "my-router"
    nat-name                    = "my-router-nat"
    nat-ip-allocation           = "AUTO_ONLY"
    source-subnet-ranges        = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    bgp-keepalive               = 60
}

module "bastion" {
    source = "./Bastion"
    name                        = "bastion-server"
    machine-type                = "e2-medium"
    zone                        = "us-central1-a"
    boot-image                  = "ubuntu-os-cloud/ubuntu-2004-lts"
    vpc-uri                     = module.network.vpc-uri
    subnet-uri                  = module.network.subnet-uri
    service-account-email       = "sa-owner-perm@shata-387907.iam.gserviceaccount.com"
    service-account-scope       = ["cloud-platform"]
  
}

module "cluster" {
    source = "./GKE"
    cluster-name                = "my-gke"
    cluster-zone                = "us-central1-a"
    vpc-uri                     = module.network.vpc-uri
    subnet-uri                  = module.network.subnet-uri
    master-cidr                 = "172.16.0.0/28"
    authorized-cidr-1           = "156.201.111.195/32"
    authorized-network-name-1   = "Home"
    authorized-cidr-2           = "${module.bastion.bastion-pub-ip}/32"
    authorized-network-name-2   = "Bastion"
    node-pool-count             = 1
    node-pool-machine_type      = "e2-medium"
}

