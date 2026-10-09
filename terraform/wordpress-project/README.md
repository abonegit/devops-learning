# WordPress Deployment on AWS Using Terraform

## Project Overview

This project demonstrates how to provision AWS infrastructure using Terraform and automatically deploy a WordPress website on an Ubuntu EC2 instance.

The infrastructure is defined as code, and Terraform uses a remote Amazon S3 backend to store its state.

## Architecture

The deployment includes:

* Amazon EC2: Hosts the WordPress website.
* Ubuntu 24.04 LTS:** Operating system for the web server.
* Apache: Serves the website over HTTP.
* MariaDB: Stores WordPress application data.
* WordPress: Content management system.
* Amazon VPC: Uses the default VPC and its internet gateway.
* Security Group: Controls inbound HTTP and SSH traffic.
* AWS Secrets Manager: Stores the WordPress database credentials.
* IAM Instance Profile: Grants the EC2 instance permissions to access Secrets Manager and Systems Manager.
* Terraform with S3 Backend: Provisions infrastructure and stores Terraform state remotely.
* EC2 User Data: Automates software installation and WordPress configuration during instance startup.

## Repository Structure

wordpress-project/
├── provider.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── wordpress-user-data.sh
├── README.md
└── screenshots/
    ├── AWS ec2 instance.png
    ├── Live wordpress website.png
    ├── terraform output.png
    └── wordpress admin dashboard.png


## Prerequisites

* An AWS account
* AWS CLI configured with appropriate permissions
* Terraform installed
* An AWS S3 bucket for the Terraform backend
* An SSH client if SSH access is required

## Deployment

1. Clone this repository and navigate to the project directory.

2. Ensure the S3 backend bucket configured in `provider.tf` exists.

3. Authenticate to AWS using an appropriate IAM identity.

4. Initialise Terraform:

   terraform init

5. Format and validate the configuration:

   terraform fmt -recursive
   terraform validate

6. Review the proposed infrastructure:

   terraform plan

7. Deploy the infrastructure:

   terraform apply


8. Retrieve the website URL:

   terraform output wordpress_url


9. Open the resulting HTTP URL in a browser and complete the WordPress setup wizard.

## Screenshots

The `screenshots/` directory contains evidence of the completed deployment:

* Live WordPress website: Confirms the website is reachable.
* WordPress admin dashboard: Confirms the WordPress installation and administration interface work.
* EC2 instance: Shows the AWS compute resource.
* Terraform outputs: Shows the deployment endpoint and instance details.

## Security Considerations

* The security group allows HTTP and SSH access from `0.0.0.0/0`. For production, restrict SSH to trusted IP addresses or use AWS Systems Manager Session Manager.
* Use HTTPS with a domain name and a valid TLS certificate before exposing a production website.
* Database credentials are stored in AWS Secrets Manager rather than hard-coded into the Terraform configuration.
* Follow the principle of least privilege when assigning IAM permissions.
* The default VPC is used for this learning project; a production deployment should consider dedicated networking, backups, monitoring, and database architecture.

## Cleanup

To remove the infrastructure created by this project and avoid ongoing AWS charges, run:

terraform destroy
git status --short
git check-ignore .terraform

Review the proposed deletions and confirm only when you are ready.

The S3 backend bucket is configured separately and is not intended to be deleted by this cleanup command. Keep the Terraform state until the destroy operation has completed successfully.

## Learning Outcomes

* Provisioning AWS resources using Terraform
* Using Terraform variables, outputs, data sources, and resource dependencies
* Configuring a remote S3 state backend
* Automating server configuration with EC2 user data
* Deploying WordPress with Apache, PHP, and MariaDB
* Managing application credentials with AWS Secrets Manager
* Verifying deployments and documenting infrastructure with screenshots

## Disclaimer

This project is intended for learning and portfolio demonstration. Review and harden the infrastructure before using it in a production environment.
