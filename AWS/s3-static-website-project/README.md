# S3 Static Website, CloudFront CDN & Route 53

## Overview
For this project, I deployed a static website using Amazon S3 and delivered it globally through Amazon CloudFront. 
I also configured Amazon Route 53 for DNS management and Amazon Certificate Manager (ACM) for HTTPS.
The project demonstrates how AWS services can work together to host, secure, cache, and deliver a static website.

### Live Website

Main domain: https://abdulmalikisah.co.uk
WWW domain: https://www.abdulmalikisah.co.uk
CloudFront distribution: AWS-generated CloudFront domain

## Architecture

The architecture implemented for this assignment is:

                    Internet
                       |
                       v
                 Amazon Route 53
                       |
                       v
                 Amazon CloudFront
                 HTTPS / CDN / Cache
                       |
                       v
              S3 Website Endpoint
                       |
                       v
              Amazon S3 Bucket
              Static Website Files

### AWS Services Used

| AWS Service                       | Purpose                                       |
| --------------------------------- | --------------------------------------------- |
| Amazon S3                         | Hosts the static website files                |
| Amazon CloudFront                 | Provides CDN delivery, caching and HTTPS      |
| Amazon Route 53                   | Provides DNS resolution for the custom domain |
| AWS Certificate Manager (ACM)     | Provides the SSL/TLS certificate              |
| GitHub                            | Stores the project files and documentation    |

---

# 1. Amazon S3 Static Website Hosting

I created an Amazon S3 bucket in the AWS London (eu-west-2) region.
The bucket contains:
index.html
error.html

## index.html
The homepage contains information about the AWS DevOps project and the AWS services being used.

### error.html
A custom 404 page was created for requests to pages that do not exist.

### Static Website Hosting
S3 Static Website Hosting was enabled with:
Index document: index.html
Error document: error.html
The S3 website endpoint was tested successfully before connecting it to CloudFront.

# 2. S3 Public Access Configuration
For this project, the S3 bucket was configured to allow public read access to objects.
The bucket policy grants:
s3:GetObject to public users for objects within the website bucket.
This configuration was used because the project specifically requires the S3 website endpoint and publicly readable objects.


# 3. Amazon CloudFront
I created an Amazon CloudFront distribution to deliver the website through a global content delivery network.

### Origin
The CloudFront origin uses the S3 static website endpoint.
This is important because the assignment specifically requires the S3 website endpoint rather than the standard S3 REST endpoint.
The origin communicates using:
HTTP
Port 80


### Viewer Protocol
CloudFront was configured to redirect HTTP requests to HTTPS.
Therefore users access the website using:
https://

### Allowed Methods
The default CloudFront behaviour was configured for:
GET
HEAD

### Cache Policy
The CloudFront distribution uses:
Managed-CachingOptimized

### Compression
Object compression was enabled so that CloudFront can efficiently deliver supported content.

### Default Root Object
The default root object is:
index.html

# 4. Custom Domain Names
The CloudFront distribution was configured with the following alternate domain names:
abdulmalikisah.co.uk
www.abdulmalikisah.co.uk
Both domains point to the same CloudFront distribution.
The final configuration allows the website to be accessed through:
https://abdulmalikisah.co.uk and https://www.abdulmalikisah.co.uk

# 5. HTTPS with AWS Certificate Manager
An ACM public certificate was requested for:
abdulmalikisah.co.uk
www.abdulmalikisah.co.uk
The certificate was created in US East (N. Virginia) because CloudFront requires ACM certificates used with CloudFront to be in that AWS region.
DNS validation was used to validate ownership of the domain.
The certificate was successfully issued and then attached to the CloudFront distribution.

# 6. Route 53 DNS
Amazon Route 53 was used to connect the custom domain to CloudFront.
The domain:
abdulmalikisah.co.uk was configured with an Alias record pointing to the CloudFront distribution.
The `www` hostname was also configured to point to the same CloudFront distribution.
The final DNS flow is:

abdulmalikisah.co.uk
        |
        v
     Route 53
        |
        v
    CloudFront
        |
        v
    Amazon S3

# 7. DNS and ACM Validation Challenge

One of the main challenges during this assignment involved DNS delegation and ACM certificate validation.
The ACM certificate initially remained in a pending validation state even though the required DNS validation records had been created.
After investigating the DNS configuration, I discovered that the domain's public nameserver delegation did not
match the Route 53 hosted zone containing the ACM validation records.
The domain was still delegated to an older Route 53 nameserver set associated with a previous configuration.

## Solution
I updated the registered domain's nameservers so that they matched the active Route 53 hosted zone.
After the nameserver delegation was corrected:
1. The ACM validation records became publicly resolvable.
2. ACM successfully validated the domain.
3. The certificate changed from Pending validation to Issued.
4. The certificate was attached to CloudFront.

This was an important practical lesson in understanding the difference between:
* DNS records inside a Route 53 hosted zone
* The nameservers delegated at the domain registrar/registry level
Creating a DNS record in Route 53 does not make it publicly authoritative unless the domain is actually delegated to that hosted zone.

# 8. Testing
The deployment was tested at several levels.

### S3 Website
The S3 website endpoint was tested directly and successfully displayed the website.

### CloudFront
The CloudFront distribution domain was tested successfully.

### Custom Domain
The following domains were tested successfully:
https://abdulmalikisah.co.uk
https://www.abdulmalikisah.co.uk
Both successfully displayed the website through CloudFront.

### HTTPS
The website was accessed using HTTPS and the ACM certificate was successfully associated with CloudFront.

# 9. CloudFront Cache Testing
To test CloudFront caching, I modified the visible content of `index.html`.
The updated file was uploaded to S3.
CloudFront was then used to invalidate cached content using:
/*
After the invalidation completed, the website was refreshed and the updated content was successfully displayed.
This demonstrated the relationship between:

S3 origin content
        |
        v
CloudFront cache
        |
        v
CloudFront invalidation
        |
        v
Updated website content

# 10. Production Security Consideration — S3 + CloudFront OAC

The architecture used for this assignment intentionally uses:

CloudFront
    |
    v
S3 Website Endpoint
    |
    v
Public S3 Objects

This is because the project specifically requires S3 static website hosting and publicly readable objects.
For a production environment, I would normally consider a different architecture:

                    Internet
                       |
                       v
                 Amazon CloudFront
                       |
                      OAC
                       |
                       v
                Private S3 Bucket

In this model:

* The S3 bucket is not publicly accessible.
* Public access to the S3 bucket is blocked.
* CloudFront uses Origin Access Control (OAC) to authenticate to S3.
* Users access the website through CloudFront.
* Direct public access to the S3 objects is prevented.

This provides a stronger security boundary because CloudFront becomes the controlled public entry point.

### Important difference

The S3 website endpoint and the normal S3 REST endpoint are different origin types.
The CloudFront OAC architecture uses the normal S3 origin rather than the S3 website endpoint.
Therefore, the production OAC architecture would require a different CloudFront/S3 configuration from the one used in this project.

# 11. What I Learned

This project helped me understand how several AWS services work together rather than treating them as isolated services.

Key areas I learned about include:

* Creating and configuring S3 static website hosting
* Working with S3 bucket policies
* Understanding public access and security trade-offs
* Configuring CloudFront distributions
* Understanding CloudFront origins and caching
* Configuring HTTPS with ACM
* Understanding why CloudFront ACM certificates use US East (N. Virginia)
* Configuring Route 53 Alias records
* Understanding DNS nameserver delegation
* Troubleshooting ACM DNS validation
* Testing CloudFront cache invalidation
* Understanding the difference between S3 website endpoints and S3 REST endpoints
* Understanding the production benefits of CloudFront Origin Access Control


# 12. Challenges and Solutions

| Challenge                                             | Solution                                                                                                                       |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| ACM certificate remained pending                      | Investigated public DNS and discovered incorrect nameserver delegation                                                         |
| DNS validation records were not publicly visible      | Updated the domain's nameserver delegation to the active Route 53 hosted zone                                                  |
| `www` initially returned a CloudFront 403 error       | Added `www.abdulmalikisah.co.uk` as an alternate domain name in CloudFront and ensured Route 53 pointed it to the distribution |
| Website content was cached                            | Used CloudFront invalidation to refresh cached content                                                                         |
| Understanding S3 public access vs production security | Compared the project architecture with private S3 + CloudFront OAC                                                          |


# 13. Project Outcome

The final deployment successfully provides a static website hosted on Amazon S3 and delivered through Amazon CloudFront.

The website is accessible through:
https://abdulmalikisah.co.uk
and:
https://www.abdulmalikisah.co.uk

The project demonstrates:

S3
 ↓
Static Website Hosting
 ↓
CloudFront
 ↓
HTTPS
 ↓
Route 53
 ↓
Custom Domain

This project gave me practical experience with AWS infrastructure, DNS, CDN configuration, HTTPS, caching, troubleshooting and basic cloud security considerations.

# 14. Screenshots

Screenshots documenting the deployment are stored in the `screenshots/` directory.

Suggested evidence includes:

* S3 bucket objects
* S3 static website hosting configuration
* S3 permissions/bucket policy
* ACM certificate
* CloudFront distribution
* CloudFront origin
* CloudFront alternate domain names
* Route 53 DNS records
* Working website
* CloudFront invalidation
* Updated website after cache invalidation

## Conclusion
This project provided practical experience deploying and delivering a static website using AWS cloud infrastructure.
The most valuable part of the exercise was not only getting the website working, but also troubleshooting the 
DNS delegation and ACM validation process and understanding how the architecture could be improved for a production environment.

The next step would be to automate deployment using a CI/CD pipeline such as **GitHub Actions**, allowing website changes to be automatically uploaded to S3 and the CloudFront cache to be invalidated.
