#  AWS Application Load Balancer

##  Project Overview

load-balanced web application using an AWS Application Load Balancer (ALB)
I deployed two EC2 web servers in separate Availability Zones and configured an Application Load Balancer to distribute incoming HTTP requests between them.
The project was completed through the AWS Management Console, with browser-based testing used to validate the load balancer.

##  Project Objectives
* Deploy two EC2 web servers in separate Availability Zones.
* Create an internet-facing Application Load Balancer.
* Configure an HTTP listener on port `80`.
* Create and configure a target group.
* Register both EC2 instances as targets.
* Configure health checks.
* Apply separate security groups for the ALB and EC2 instances.
* Validate load balancing through the ALB DNS address.

## Architecture
./architecture/alb.drawio.png

### Architecture Flow
Internet
   |
   | HTTP :80
   v
Application Load Balancer
   |
   |--------------------------|
   |                          |
   v                          v
EC2 Web Server 1       EC2 Web Server 2
Availability Zone 1    Availability Zone 2
   |                          |
   |--------------------------|
               |
               v
         Target Group
```

The Application Load Balancer receives incoming HTTP requests and forwards them to healthy EC2 instances registered in the target group.

## ☁️ AWS Resources

| Resource           | Configuration         |
| ------------------ | --------------------- |
| VPC                | `alb-vpc`             |
| VPC CIDR           | `10.1.0.0/16`         |
| Public Subnet 1    | `alb-public-subnet-1` |
| Public Subnet 2    | `alb-public-subnet-2` |
| Internet Gateway   | `alb-igw`             |
| Route Table        | `alb-public-rt`       |
| Load Balancer      | `vpc-alb`     |
| Target Group       | `ec2-tg` |
| EC2 Instance 1     | `webserver1`   |
| EC2 Instance 2     | `webserver2`   |
| ALB Security Group | `alb-sg`  |
| EC2 Security Group | `ec2-sg`  |
| Listener           | HTTP :80              |
| Health Check Path  | `/`                   |


## 🌍 Network Design

The environment was deployed inside a dedicated VPC with two public subnets.

Each subnet was configured in a separate Availability Zone to demonstrate a basic multi-AZ architecture.

### Public Subnets

* `alb-public-subnet-1`
* `alb-public-subnet-2`

The public subnets use a route table containing a default route to the Internet Gateway:

Destination: 0.0.0.0/0
Target: Internet Gateway

The Application Load Balancer and EC2 instances were deployed in the configured public subnets for this learning exercise.

##  Security Group Design

Two separate security groups were configured to control traffic between the load balancer and the EC2 instances.

### Application Load Balancer Security Group

Security group: `alb-sg`

| Type | Port | Source      |
| ---- | ---- | ----------- |
| HTTP | 80   | `0.0.0.0/0` |

This allows incoming HTTP traffic from the internet to reach the Application Load Balancer.

### EC2 Security Group

Security group:`ec2-sg`

| Type | Port | Source               |
| ---- | ---- | -------------------- |
| HTTP | 80   | `assignment2-alb-sg` |

The EC2 instances allow HTTP traffic from the ALB security group rather than directly from all internet sources.

This demonstrates the use of security group references to control application traffic.

## Application Load Balancer Configuration
The Application Load Balancer was configured with:

* Name:`assignment2-alb`
* Scheme: Internet-facing
* Protocol: HTTP
* Listener: Port `80`
* Target group: `assignment2-targets`
* VPC: `alb-vpc`
* Subnets: Two public subnets in separate Availability Zones

The ALB forwards incoming requests to the EC2 instances registered in the target group.

## Target Group Configuration

The target group was configured with:

* Name: `assignment2-targets`
* Target type: Instances
* Protocol: HTTP
* Port: `80`
* Health check protocol: HTTP
* Health check path: `/`

Both EC2 instances were registered as targets.

The health checks were used to verify that the web servers were available to receive traffic.


## Validation & Testing

The Application Load Balancer was tested through its DNS address using a web browser.

### Browser-Based Test

1. Opened the Application Load Balancer DNS address.
2. Confirmed that the web application loaded successfully.
3. Refreshed the same DNS address multiple times.
4. Observed different responses from the registered web servers.

The browser displayed content from Web Server 1 and at other points Web Server 2

### Validation Result

✅ The same ALB DNS address returned pages from both configured web servers during browser refresh testing.

This demonstrated that the Application Load Balancer was forwarding requests to different registered EC2 targets.

## 📸 Project Evidence

Screenshots were captured throughout the implementation and testing process.
The evidence includes:
* VPC configuration
* Public subnet configuration
* Internet Gateway
* Route table
* Security groups
* EC2 instances
* Target group
* Application Load Balancer
* Target health status
* Web Server 1 response
* Web Server 2 response

The screenshots document the AWS Console configuration and browser-based load-balancing validation.

## Project Structure
loadbalancer/
           │
           ├── README.md
           │
           ├── architecture/
           │   └── assignment-2-alb-architecture.png
           │
           └── screenshots/
                         ├── 01-vpc.png
                         ├── 02-subnet1.png
                         ├── 03-internet-gateway.png
                         ├── 04-routetable.png
                         ├── 05-security-groups.png
                         ├── 06-ec2-instances.png
                         ├── 07-target-groups.png
                         ├── 08-load-balancer.png
                         ├── 9-webserver.png
                         └── 11-webserver2.png


## Cost Awareness

This project used AWS resources that may incur charges, including:

* EC2 instances
* EBS volumes
* Application Load Balancer
* Public IPv4 addresses
* Data processing and data transfer

Resources was reviewed and removed when they were no longer required.


## Potential Improvements

Future improvements to this architecture could include:

* Introducing an Auto Scaling Group.
* Using an EC2 Launch Template.
* Adding dynamic scaling policies.
* Integrating Amazon CloudWatch metrics.
* Configuring HTTPS using AWS Certificate Manager.
* Adding a custom domain using Amazon Route 53.
* Deploying application instances in private subnets behind the ALB.


##  Conclusion

I deployed two EC2 web servers and used an Application Load Balancer to distribute incoming traffic between them.
Browser-based validation confirmed that the same ALB DNS endpoint could return responses from both web servers.

##  Technologies Used
* Amazon VPC
* Amazon EC2
* Application Load Balancer
* Target Groups
* Security Groups
* Internet Gateway
* AWS Management Console
* Amazon Linux
* Apache HTTP Server
