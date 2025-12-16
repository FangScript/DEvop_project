#!/bin/bash
# Jenkins Setup Script for DevOps CI/CD Pipeline
# This script helps set up Jenkins on Ubuntu/Debian or Amazon Linux

set -e

echo "=========================================="
echo "Jenkins CI/CD Pipeline Setup Script"
echo "=========================================="

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Cannot detect OS. Exiting."
    exit 1
fi

echo "Detected OS: $OS"

# Function to install Jenkins on Ubuntu/Debian
install_jenkins_ubuntu() {
    echo "Installing Jenkins on Ubuntu/Debian..."
    
    # Update system
    sudo apt-get update
    
    # Install Java
    sudo apt-get install -y openjdk-17-jdk
    
    # Add Jenkins repository
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
        /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
        https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
        /etc/apt/sources.list.d/jenkins.list > /dev/null
    
    # Update and install Jenkins
    sudo apt-get update
    sudo apt-get install -y jenkins
    
    # Start Jenkins
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    
    echo "Jenkins installed successfully!"
}

# Function to install Jenkins on Amazon Linux/RHEL
install_jenkins_amazon() {
    echo "Installing Jenkins on Amazon Linux/RHEL..."
    
    # Update system
    sudo yum update -y
    
    # Install Java
    sudo yum install -y java-17-amazon-corretto-headless
    
    # Add Jenkins repository
    sudo wget -O /etc/yum.repos.d/jenkins.repo \
        https://pkg.jenkins.io/redhat-stable/jenkins.repo
    
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    
    # Install Jenkins
    sudo yum install -y jenkins
    
    # Start Jenkins
    sudo systemctl daemon-reload
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    
    echo "Jenkins installed successfully!"
}

# Install Jenkins based on OS
case $OS in
    ubuntu|debian)
        install_jenkins_ubuntu
        ;;
    amzn|rhel|centos)
        install_jenkins_amazon
        ;;
    *)
        echo "Unsupported OS: $OS"
        echo "Please install Jenkins manually."
        exit 1
        ;;
esac

# Get initial admin password
echo ""
echo "=========================================="
echo "Jenkins Installation Complete!"
echo "=========================================="
echo ""
echo "Get your initial admin password:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo ""
echo "Access Jenkins at: http://$(hostname -I | awk '{print $1}'):8080"
echo "or http://localhost:8080"
echo ""
echo "Next steps:"
echo "1. Access Jenkins web interface"
echo "2. Enter the initial admin password"
echo "3. Install suggested plugins"
echo "4. Create admin user"
echo "5. Run: ./configure-jenkins.sh (if available)"
echo ""

