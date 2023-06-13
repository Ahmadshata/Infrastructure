resource "google_compute_instance" "bastion-server" {
  name         = var.name
  machine_type = var.machine-type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.boot-image
    }
  }

  network_interface {
    network = var.vpc-uri
    subnetwork = var.subnet-uri
#To assign ephemeral public ip address    
    access_config {}
  }

#ssh-keygen -t ed25519 -C  <remote-user-name> -f <file-name>
    metadata = {
    "ssh-keys" = <<EOT
      ahmad:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAik9TiVuSNV/PO5b71pn49oxD1cv2CzgJyzEaH7i3UQ ahmad
     EOT
   }
    
  service_account {
    email  = var.service-account-email
    scopes = var.service-account-scope
  }
}