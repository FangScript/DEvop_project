#!/bin/bash
# Single command Jenkins setup for Linux (Ubuntu/Debian)
# Usage: curl -fsSL https://raw.githubusercontent.com/FangScript/DEvop_project/main/setup-linux-jenkins.sh | bash

set -e

echo "=========================================="
echo "Jenkins Installation Script"
echo "=========================================="

# Update system
echo "Updating system packages..."
sudo apt-get update -qq

# Install Java
echo "Installing Java 17..."
sudo apt-get install -y openjdk-17-jdk > /dev/null 2>&1

# Add Jenkins repository
echo "Adding Jenkins repository..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
echo "Installing Jenkins..."
sudo apt-get update -qq
sudo apt-get install -y jenkins > /dev/null 2>&1

# Start Jenkins
echo "Starting Jenkins service..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Wait for Jenkins to start
echo "Waiting for Jenkins to initialize..."
sleep 10

# Get initial admin password
echo ""
echo "=========================================="
echo "Jenkins Installation Complete!"
echo "=========================================="
echo ""
echo "Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo ""
echo "Access Jenkins at: http://$(hostname -I | awk '{print $1}'):8080"
echo "or http://localhost:8080"
echo ""
echo "Next Steps:"
echo "1. Open Jenkins in your browser"
echo "2. Enter the password above"
echo "3. Install suggested plugins"
echo "4. Create admin user"
echo "5. Configure pipeline job"
echo ""

