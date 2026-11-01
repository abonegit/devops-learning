# DevOps CI/CD Automation Project

## Overview

This project demonstrates practical Continuous Integration (CI), and Continuous Delivery (CD) using GitHub Actions, 
Python, Docker, Docker Hub, and Terraform.

The goal was to build automated workflows that test application code, build and publish a Docker image, and validate 
Terraform configuration whenever relevant changes are made to the repository.


## Technologies Used

- Git and GitHub — Version control and source code management
- GitHub Actions — CI/CD workflow automation
- Python — Application development and unit testing
- Ruff — Python linting and code quality checks
- Docker — Application containerisation
- Docker Hub — Container image storage and distribution
- Terraform — Infrastructure as Code (IaC)
- YAML — GitHub Actions workflow configuration

## Repository Structure

screenshots/repository structure
## Project 1: Application CI

Workflow: `.github/workflows/application-ci.yml`

This workflow automates quality checks for the Python application.

### What it does

1. Checks out the repository.
2. Sets up Python 3.12.
3. Installs Ruff for Python linting.
4. Checks the code for linting issues.
5. Runs automated unit tests.
6. Builds the Docker image to verify that the application can be containerised.

### Why it matters

Automated testing and linting help identify problems early, before code changes are integrated into the project.

Status: Passing

### Screenshot

screenshots/application-ci-passing.png

## Project 2: Docker Build and Publish

Workflow: `.github/workflows/docker-publish.yml`

This workflow automates building and publishing the Python application's Docker image to Docker Hub.

### What it does

1. Checks out the repository.
2. Sets up Python and runs code quality checks.
3. Runs the automated unit tests.
4. Configures Docker Buildx.
5. Authenticates with Docker Hub using GitHub repository settings.
6. Builds the Docker image.
7. Publishes the image to Docker Hub when the workflow runs for a push to the main branch.
8. Tags the image with `latest` and the Git commit SHA.

Pull requests run the build and tests without publishing the image.

### Security

Docker Hub authentication uses GitHub repository variables and secrets:

- `DOCKERHUB_USERNAME` — Stores the Docker Hub username as a repository variable.
- `DOCKERHUB_TOKEN` — Stores the Docker Hub Personal Access Token as a repository secret.

The token is not stored in the source code or committed to GitHub.

### Why it matters

Automating image publishing reduces manual work and makes the container image available for subsequent deployment stages.

Status: Passing

### Screenshot

screenshots/docker-publish-passing.png

### Docker Hub Image

**Docker Hub repository:** [Add your Docker Hub repository link here]

The image is published with the following tags:

- `latest`
- A tag based on the Git commit SHA

Example image reference:

YOUR_DOCKERHUB_USERNAME/hello-app:latest


Replace `YOUR_DOCKERHUB_USERNAME` with your actual Docker Hub username when using the image.

## Project 3: Terraform CI

Workflow: `.github/workflows/terraform-ci.yml`

This workflow checks Terraform configuration automatically.

### What it does

1. Checks out the repository.
2. Installs Terraform.
3. Checks Terraform formatting using `terraform fmt -check -recursive`.
4. Initialises Terraform without configuring a remote backend.
5. Validates the Terraform configuration using `terraform validate`.

### Why it matters

Automated Terraform checks help identify formatting and configuration problems before infrastructure changes are considered for deployment.

This project uses Terraform's built-in `terraform_data` resource as a simple validation example. It does not deploy cloud infrastructure or require cloud-provider credentials.

Status: Passing

### Screenshot

screenshots/terraform-ci-passing.png

## Docker Hub Image Verification

The Docker image was published through GitHub Actions.

The following screenshot shows the image tags available in Docker Hub.

screenshots/docker-hub-tags.png

## What I Learned

Through this project, I gained practical experience with:

- Creating GitHub Actions workflows using YAML.
- Configuring workflow triggers for pushes, pull requests, and manual runs.
- Automating Python linting and unit testing.
- Building Docker images in a CI/CD pipeline.
- Publishing Docker images automatically to Docker Hub.
- Managing credentials securely with GitHub repository secrets.
- Tagging container images with Git commit SHAs.
- Formatting and validating Terraform configuration.
- Troubleshooting Git conflicts, YAML errors, workflow failures, and Docker authentication issues.
- Using successful and failed pipeline runs to understand and improve automation.

## Challenges and Troubleshooting

During development, I worked through several common issues:

Challenge: Python test failures 
Solutions:The function's return value must match the expected test result.                `      
Challenge: YAML workflow errors.             
Solution: Correct YAML syntax, indentation, and event triggers are essential.                       
Challenge: Git conflicts during a rebase.     
Solution: Conflicts must be resolved carefully before continuing a rebase. 
Challenge: Docker Hub authentication failure.  
Solution: GitHub Actions must receive the correct username variable and token secret. 
Challenge: Workflow file placement.           
Solution: GitHub Actions workflows must be stored in the repository-root `.github/workflows/` directory. 
Challenge: Terraform formatting.               
Solution: Terraform formatting checks help maintain consistent configuration. 


## Conclusion

This project gives a hands-on experience with the building blocks of a DevOps CI/CD pipeline.

By combining GitHub Actions, automated testing, Docker image publishing, and Terraform validation, I developed a better understanding of 
how automation can improve code quality, consistency, and delivery workflows.


Learning, building, troubleshooting, and improving, one pipeline at a time.
