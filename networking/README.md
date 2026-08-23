# AWS Networking Lab

## Overview

This project demonstrates basic networking concepts by deploying an NGINX web server on an AWS EC2 instance and connecting it to a custom domain using Amazon Route 53.

## Architecture

Browser
↓
Route 53 DNS
↓
A Record
↓
Elastic IP
↓
EC2
↓
Security Group
↓
Port 80
↓
NGINX

## Technologies Used

- AWS EC2
- Amazon Route 53
- Ubuntu
- NGINX
- Git
- GitHub

## What was Built

A domain using Amazon Route 53 was registered and an Ubuntu EC2 instance was launched.

 NGINX was installed and the EC2 Security Group was configured to allow HTTP traffic on port 80.

An Elastic IP was allocated and an A record was created in Route 53 pointing my subdomain to the Elastic IP.

The final result was an NGINX webpage accessible through my custom domain.

## DNS Configuration

My Route 53 configuration used an A record:

nginx.abdulmalikisah.co.uk → 13.134.5.172

## What I Learned

- How DNS works
- How A records map domains to IPv4 addresses
- How EC2 instances use IP addresses
- How Security Groups control inbound traffic
- How ports work
- How HTTP traffic reaches an NGINX web server
- How Route 53 manages DNS
- How Elastic IPs provide a persistent public IP
- How Git and GitHub can be used to document technical projects

## Challenges

### 1. EC2 SSH Connection Timeout

Day two came, When I returned to the project, I was unable to connect to my EC2 instance through PowerShell. The SSH connection kept timing out. I initially had to go through the networking chain step by step to identify where the problem was.
I checked the EC2 instance, Elastic IP, Security Group, and inbound rules. I eventually discovered that the SSH inbound rule was no longer allowing access from my current IP address. I edited the inbound rule and changed the SSH source back to my IP, which restored the connection.
This took almost two hours to troubleshoot the first time, but it helped me understand how the different parts of the network work together. When I encountered the same issue later, I was able to identify and fix it within a few minutes.

### 2. Understanding What Is Safe to Upload to GitHub

Another challenge was making sure that I did not accidentally upload sensitive information to my GitHub repository. I had to carefully review the files and configuration used throughout the project to determine what was safe to make public.
I learned that private files such as my SSH `.pem` key, credentials, passwords, and access keys should never be committed to GitHub. I reviewed my repository before committing and made sure sensitive files were excluded.

This helped me understand the importance of protecting credentials and checking what is being committed before pushing code to a public repository.


## Testing

I tested the setup using the following

- nslookup
- dig
- curl
- Browser

## Screenshots
see [screenshots] folder

## Commands

See [commands.md].

## Notes

See [notes.md].