provider "google" {
  project = "shata-387907"
  region  = "us-central1"
}
terraform {
#Google Cloud Platform like most of the remote backends natively supports locking so we don't need DynamoDB.
#state locking is done by using a special lock file with .tflock extension.
#This file is placed next to the Terraform state itself in the bucket for the period of Terraform state operation.
#AWS doesn't support locking natively via S3 but it does so via DynamoDB.
        backend "gcs" {
          bucket  = "tf-state-shata"
          prefix  = "terraform/state"
    }
        required_providers {
            google = {
              source  = "hashicorp/google"
              version = "~> 4.0"
    }
  }
}