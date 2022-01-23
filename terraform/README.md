# Terraform
Terraform is an infrastructure as code (IaC) tool that allows you to build, change, and version infrastructure safely and efficiently

# Target infrastructure
Infrastructure will be provisioned
- A VPC/Subnet/Route
- A NAT router that allows the instances inside the VPC to access the internet.
- A private GKE cluster with one node
- A Bastion Instance that for accessing to the Kubernetes Control Plane to run kubectl CMD

## Providers
| Provider | Version |
| :---         |     :---:      |
| hashicorp/google  | latest    | 

## Modules
| Name | Source | Description |
| :---         |     :---:      | :---:      |
|networks | ./modules/networks    | provision vpc,subnet,route,egress,nat_router      |
|kubernetes_cluster | ./modules/kubernetes_cluster    | provision GKE private cluster with authorized_networks to the bastion compute instance    |
|bastion | ./modules/bastion    |  provision bastion compuete instance for GKE control plane access      |

## Create GCP service account & JSON key
Create a GCP service account from console or gcloud command, create a JSON key for the account. Download the key file as ./service-account.json.

## Configure Terraform backend and variables
- Copy ./terraform.tfvars.example as ./terraform.tfvars.dev or ./terraform.tfvars.prod. Replace the values as needed.
- Create a GCS bucket and update GCS bucket name in the backend.conf

## Usage
```
# initialize a working directory containing Terraform configuration files
terraform init -backend-config=backend.conf

# preview the changes that Terraform plans to make to your infrastructure, replace the terraform.tfvars.example as required 
terrform plan -var-file terraform.tfvars.example

# executes the actions proposed in a Terraform plan, replace the terraform.tfvars.example as required 
terrform apply -var-file terraform.tfvars.example
```
