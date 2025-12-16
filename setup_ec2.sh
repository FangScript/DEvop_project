#!/bin/bash
# Setup script for EC2 instance
# Run this script once when setting up a new EC2 instance

set -e

echo "Setting up EC2 instance for CI/CD deployment..."

# Update system packages
if [ -f /etc/redhat-release ]; then
    # Amazon Linux / CentOS / RHEL
    echo "Updating packages (Amazon Linux/RHEL)..."
    sudo yum update -y
    sudo yum install -y python3 python3-pip git
elif [ -f /etc/debian_version ]; then
    # Ubuntu / Debian
    echo "Updating packages (Ubuntu/Debian)..."
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y python3 python3-pip python3-venv git
else
    echo "Unknown Linux distribution. Please install Python 3, pip, and git manually."
    exit 1
fi

# Verify installations
echo "Verifying installations..."
python3 --version
pip3 --version
git --version

# Create application directory
echo "Creating application directory..."
mkdir -p /home/ec2-user/app
chmod 755 /home/ec2-user/app

# Install Gunicorn globally (optional, will be installed in venv)
pip3 install --user gunicorn

echo "EC2 instance setup complete!"
echo "The instance is now ready for CI/CD deployments."

