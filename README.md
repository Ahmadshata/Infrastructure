# Infrastructure Repository

This repository contains the infrastructure code and configurations for setting up a private Google Kubernetes Engine (GKE) cluster, network components, and deploying Jenkins using Helm and Ansible.

## Terraform

The `GKE-terraform/` directory contains the Terraform code for provisioning the infrastructure components.

### GKE Module

The `GKE-terraform/gke` directory contains the Terraform module for creating a private GKE cluster and node pool. It sets up the necessary networking and security configurations for the cluster.

### Network Module

The `GKE-terraform/network` directory contains the Terraform module for creating the network components such as VPC, subnetwork, NAT, and router. It provides the networking infrastructure required for the GKE cluster and other resources.

### Bastion Server Module

The `GKE-terraform/bastion` directory contains the Terraform module for creating a bastion server. The bastion server acts as a jump host for accessing resources within the private network, including the GKE cluster.

#### Backend Configuration

This repository uses a Google Cloud Storage (GCS) bucket as the backend for storing the Terraform state file. To configure the backend, update the `provider.tf` file with your GCS bucket information:

```hcl
terraform {
  backend "gcs" {
    bucket  = "<your-bucket-name>"
    prefix  = "<optional-prefix>"
  }
}
```
> :warning: Make sure to replace <your-bucket-name> with the name of your GCS bucket, <optional-prefix> with an optional prefix for your state file.

## Usage
To provision the infrastructure and deploy Jenkins, follow these steps:

Modify the configuration files in the terraform/ directory to customize your infrastructure settings.

Configure the Terraform backend in each module's backend.tf file as described in the Backend Configuration section above.

Execute the Terraform commands to create the infrastructure components:
  ```hcl
cd GKE-terraform/
terraform init
terraform plan
terraform apply
  ```
## Kubernetes Helm Charts

The `Jenkins-master&slave-chart/` directory contains the Kubernetes Helm chart for deploying Jenkins on the GKE cluster. The chart utilizes Helm templating language (Go templates) to generate Kubernetes manifests with customizable configurations.

### Jenkins Chart

The `Jenkins-master&slave-chart/templates` directory contains the Helm template for deploying Jenkins. It allows you to configure various aspects of the Jenkins deployment, including resource allocation, persistence, and other settings.

## Usage
To deploy Jenkins on the GKE cluster using Helm, follow these steps:

> :warning: Update the Helm chart values in the charts/jenkins/values.yaml file to match your requirements.

```hcl
helm install <You-release-name> ./Jenkins-master&slave-chart
```
### Access Jenkins:

Once the deployment is successful, you can access Jenkins by retrieving the external IP associated with the Jenkins LoadBalancer service.
  
 ## Ansible

The Ansible deployment directory (`Ansible/`) contains the necessary files and configurations for deploying the Jenkins Helm chart on the GKE cluster. Ansible is used to automate the deployment process and execute the necessary commands on the bastion server.

### Prerequisites

Before running the Ansible deployment, ensure that you have the following prerequisites set up:

- Ansible installed on your local machine or the machine from which you plan to run the deployment.
- SSH access to the bastion server.
- Proper configuration of the Ansible inventory file (`ansible/inventory.yaml`) with the necessary connection details for the bastion server.

### Deployment Steps

To deploy Jenkins on the GKE cluster using Ansible, follow these steps:

1. Update the Ansible inventory file (`ansible/inventory.yaml`) with the correct connection details for the bastion server. Make sure to provide the appropriate SSH key or credentials for authentication.

2. Modify the Ansible playbook (`ansible/deploy.yaml`) if needed. This playbook includes tasks to connect to the bastion server and run the necessary commands for deploying the Jenkins Helm chart.

3. Run the Ansible playbook:

```shell
  cd Ansible
  ansible-playbook -i <path-to-your-private-key> playbook.yaml
```

## Set up the Jenkins agent:

- Log in to your Jenkins server and navigate to the Jenkins dashboard.
- Click on "Manage Jenkins" in the left sidebar.
- Click on "Manage Nodes and Clouds."
- Click on "New Node" to create a new Jenkins agent.
- Provide a name for the agent (e.g., "portfolio-agent") and select the appropriate options based on your configuration.
- Make the Remote root directory to be /var/jenkins_home.
- Set the label for the agent to be myagent.
- Choose Launch method to be SSH.
- Put the Host as the Jenkins agent service name which is "jenkins-ubuntu-slave-svc"
- See the credentials section below on how to learn how to create SSH credentials and then add them to the credentials section.
- Save the agent configuration.
- Download Gcloud Auth Plugin using the command below when you are logged in to your agent using the jenkins user.
  
```shell
 apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
```
- Connect to the GKE cluster using the connect commaned provided in the console.

## Configure Jenkins credentials:

- Log in to your Jenkins server and navigate to the Jenkins dashboard.
- Click on "Manage Jenkins" in the left sidebar.
- Click on "Manage Credentials" to access the credentials management page.
- On the Credentials page, click on the "Global" domain or select an appropriate domain based on your requirements.
- Under the "Credentials" section, click on the "Add Credentials" link.
- Select the appropriate credential type based on your needs. 
- For this Jenkins pipeline. You Need to create two "Username with password" credentials.
- You need one for docker hub account and set its ID to "dockerhub"
- You need another one for the Jenkins agent SSH credentials in our case set the name to ahmad and the password to 123456 and set its ID to "jenkins"
- You also need a credential of type "Secret file" to upload the Kubeconfig file from your agent after you connect to the cluser.
- Jenkins will validate and store the credentials for future use.
  
  Once you completed the preceding steps now it is time to spin up your first application using Jenkins pipeline.
  Check out the App repository here https://github.com/Ahmadshata/App
  
  
