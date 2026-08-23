# Update packages
sudo apt update

# Upgrade packages
sudo apt upgrade -y

# Install NGINX
sudo apt install nginx -y

# Check NGINX
sudo systemctl status nginx

# Enable NGINX at boot
sudo systemctl enable nginx

# Test NGINX locally
curl http://localhost

# Check port 80
sudo ss -tulpn | grep :80

# Test the domain
curl http://nginx.abdulmalikisah.co.uk

# Check HTTP response
curl -I http://nginx.abdulmalikisah.co.uk

# DNS lookup
nslookup nginx.yourdomain.co.uk

# Alternative DNS lookup
dig nginx.yourdomain.co.uk