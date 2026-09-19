# AWS VPC & Networking

## Overview

This project demonstrates the design and implementation of a custom AWS VPC with public and private networking.

The environment was built from the AWS Console and tested end-to-end to verify:

* Public internet connectivity
* Private subnet isolation
* Controlled administrative access through a Bastion Host
* Outbound internet access from a private EC2 instance through a NAT Gateway
* Security Group-based access control
* Route table configuration between public and private network components


### Architecture Components

| Component           | Configuration                    |
| ------------------- | -------------------------------- |
| VPC                 | `devops-vpc`                     |
| VPC CIDR            | `10.0.0.0/16`                    |
| Public Subnet       | `public-subnet` — `10.0.1.0/24`  |
| Private Subnet      | `private-subnet` — `10.0.2.0/24` |
| Internet Gateway    | `devops-igw`                     |
| Public Route Table  | `public-rt`                      |
| Private Route Table | `private-rt`                     |
| NAT Gateway         | `devops-nat`                     |
| Public EC2          | `assignment1-public-ec2`         |
| Private EC2         | `assignment1-private-ec2`        |
| Bastion Host        | `assignment1-bastion`            |

## Network Design

### Public Subnet

The public subnet uses the `public-rt` route table.

The default route:
0.0.0.0/0 → Internet Gateway allows resources with public IPv4 addresses to communicate with the internet.

The public subnet contains:

* Bastion Host
* Public EC2 instance
* NAT Gateway

### Private Subnet

The private subnet uses the `private-rt` route table.

Its default route is:
0.0.0.0/0 → NAT Gateway
The private EC2 instance does not have a public IPv4 address, This allows the instance to initiate outbound internet connections through the 
NAT Gateway without being directly reachable from the public internet.

## Security

Separate Security Groups were used for the different roles.

### Public EC2 Security Group
Inbound access:
SSH  TCP 22  → My IP
HTTP TCP 80  → My IP

### Bastion Security Group
Inbound access:
SSH TCP 22 → My IP

### Private EC2 Security Group
Inbound access:
SSH TCP 22 → assignment1-bastion-sg
The private EC2 instance does not expose SSH directly to the internet.
This demonstrates security-group-based access between AWS resources rather than relying on broad public access rules.

## Bastion Host Access
The Bastion Host was deployed in the public subnet and used as the controlled administrative entry point to the private EC2 instance.
The connection flow was:
Local Machine
      ↓
Bastion Host
      ↓ SSH
Private EC2

SSH agent forwarding was used so the private key did not need to be copied onto the Bastion Host.

## NAT Gateway Test
The private EC2 instance had no public IPv4 address but was able to access an external HTTPS endpoint.
The following command was executed from the private EC2 instance:
curl -L -s -o /dev/null -w "%{http_code}\n" https://www.google.com
Result:
200
This verified outbound internet connectivity from the private subnet through the NAT Gateway.

The traffic path was:
Private EC2
    ↓
Private Route Table
    ↓
NAT Gateway
    ↓
Internet Gateway
    ↓
Internet
## Public EC2 Test
The public EC2 instance was configured with Apache HTTP Server and served a simple test page:
Assignment 1 - Public EC2
The page was successfully accessed through the instance's public IPv4 address.

## User Data

The EC2 instances were configured using user-data scripts to install and start Apache HTTP Server.

#!/bin/bash

dnf update -y
dnf install -y httpd
systemctl enable httpd
systemctl start httpd

echo "<h1>Assignment 1 - Public EC2</h1>" > /var/www/html/index.html

The private instance used the same configuration with private-instance-specific page content.

## Validation
The following tests were successfully completed:

*  VPC created with `10.0.0.0/16`
*  Public subnet created
*  Private subnet created
*  Internet Gateway attached
*  Public route table configured
*  Private route table configured
*  NAT Gateway deployed
*  Public EC2 deployed
*  Private EC2 deployed without a public IPv4 address
*  Bastion Host deployed
*  Public EC2 HTTP connectivity verified
*  Local machine → Bastion SSH verified
*  Bastion → Private EC2 SSH verified
*  Private EC2 → Internet connectivity verified
*  HTTP status `200` received through NAT Gateway

## Key Learning Outcomes

This project provided hands-on experience with:

* AWS VPC architecture
* CIDR addressing
* Public and private subnets
* Internet Gateways
* NAT Gateways
* Route Tables
* EC2 networking
* Security Groups
* Bastion Host architecture
* SSH and SSH agent forwarding
* Private subnet outbound connectivity
* AWS network troubleshooting
* Infrastructure documentation

## Project Evidence

Screenshots demonstrating the implementation and testing are available in:
./screenshots/

The architecture diagram is available in:
./architecture/

## Cost Awareness

This project also reinforced the importance of AWS cost management.

Resources such as NAT Gateways, public IPv4 addresses and EC2 instances can generate AWS charges. Temporary lab resources should therefore be reviewed and 
removed when the project is complete.

