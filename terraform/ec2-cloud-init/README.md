# EC2 Deployment with Cloud-Init

Deploy an Ubuntu EC2 instance on AWS using Terraform and automatically configure an NGINX web server with cloud-init.

## Project Overview

This project demonstrates Infrastructure as Code (IaC) by provisioning AWS infrastructure with Terraform and automating server configuration with cloud-init.

The deployment creates a dedicated Virtual Private Cloud (VPC), a public subnet, internet connectivity, a security group, and an EC2 instance. During initialisation, cloud-init installs NGINX and configures a custom HTML landing page that can be accessed through the instance's public IP address.

## Architecture

The deployment follows this traffic flow:

Internet → Internet Gateway → Public Subnet → EC2 Instance → NGINX Web Server

AWS resources provisioned by Terraform:

* VPC: Isolated project network.
* Public subnet: Hosts the EC2 instance.
* Internet Gateway: Provides internet connectivity.
* Route table: Routes internet-bound traffic through the Internet Gateway.
* Security group: Allows inbound HTTP traffic on TCP port 80 and permits outbound traffic.
* EC2 instance: Runs Ubuntu Server 24.04 LTS.
* NGINX: Serves the custom website.
* Cloud-init: Automates package installation, website file creation, and service startup.

## Technologies Used

* Amazon Web Services (AWS)
* Amazon EC2
* Terraform
* Cloud-init
* Ubuntu Server 24.04 LTS
* NGINX
* HTML5 and CSS3
* Git and GitHub
* Windows Subsystem for Linux (WSL) and Ubuntu

## Repository Structure

ec2-cloud-init/
        ├── main.tf
        ├── variables.tf
        ├── versions.tf
        ├── outputs.tf
        ├── cloud-init.yaml
        ├── terraform.tfvars.example
        ├── .gitignore
        ├── README.md
        └── screenshots/

## Prerequisites

Before deploying, ensure you have:

* An AWS account with permission to create the required EC2 and networking resources.
* AWS CLI installed and configured.
* Terraform installed.
* Git installed.
* An AWS region selected for deployment.

The example configuration uses `eu-west-2` (London) and the `t3.micro` instance type.

## Deployment Instructions

### 1. Clone the repository

git clone <https://github.com/abonegit/devops-learning/edit/main/terraform/ec2-cloud-init>


### 2. Configure AWS credentials

Configure the AWS CLI using your preferred secure authentication method:

aws configure

Verify that your credentials work:

aws sts get-caller-identity



### 3. Configure Terraform variables

Create your local variable file by copying the example:

cp terraform.tfvars.example terraform.tfvars

Review `terraform.tfvars` and set the appropriate values for your deployment.

The example uses:

hcl
aws_region    = "eu-west-2"
instance_type = "t3.micro"
project_name  = "ec2-cloud-init"

The local `terraform.tfvars` file is excluded from version control.

### 4. Initialise Terraform

terraform init

### 5. Validate the configuration

terraform fmt 
terraform validate


### 6. Review the execution plan

terraform plan

Review the resources Terraform proposes to create before proceeding.

### 7. Deploy the infrastructure

terraform apply

Review the plan and enter `yes` when prompted.

### 8. Retrieve the deployment outputs

terraform output

The outputs include the EC2 instance ID, public IP address, and website URL.

Open the `website_url` in your browser to view the deployed website.

## How Cloud-init Works

The `cloud-init.yaml` file automates the EC2 instance's initial configuration.

It performs the following tasks:

1. Updates the package index.
2. Installs NGINX.
3. Creates a custom HTML landing page in `/var/www/html/index.html`.
4. Enables the NGINX service.
5. Restarts NGINX to serve the website.

This removes the need to connect manually to the server to perform the initial web server setup.

## Security Considerations

* The security group allows inbound HTTP traffic on TCP port 80 from the internet to make the demo website publicly accessible.
* SSH access is not configured in this project.
* EC2 instance metadata requires IMDSv2 tokens.
* AWS credentials and Terraform state files must not be committed to version control.
* For production deployments, restrict access where appropriate and consider HTTPS, monitoring, logging, and additional security controls.

## Verification

The deployment was verified by:

* Confirming that the EC2 instance was running and its status checks passed.
* Confirming the public networking and HTTP security group configuration.
* Opening the website through the Terraform-provided URL.
* Receiving an HTTP `200 OK` response from the web server.

## Screenshots

Deployment evidence is available in the `screenshots/` directory.

Suggested evidence includes:

* Successful website in the browser.
* EC2 instance and status checks.
* EC2 networking details.
* Security group HTTP inbound rule.
* Terraform outputs.
* Cloud-init configuration.


## Cleanup

To avoid unnecessary AWS charges, destroy the resources after testing:

terraform plan -destroy
terraform destroy

Review the destruction plan and confirm only the intended project resources will be removed. Enter `yes` when prompted.

Terraform state and the local configuration should be retained until cleanup has completed successfully. Do not delete the local Terraform state before destroying the resources.

## Key Learnings

* Provisioning AWS infrastructure with Terraform.
* Building a public AWS network using a VPC, subnet, Internet Gateway, and route table.
* Configuring security group rules for HTTP traffic.
* Automating EC2 initialisation using cloud-init.
* Deploying and serving a website with NGINX.
* Managing infrastructure through Git and GitHub.

## Author

Created as part of a hands-on DevOps learning project focused on Infrastructure as Code and automated cloud server configuration.
