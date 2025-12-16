#!/bin/bash
# Jenkins Configuration Script
# This script helps configure Jenkins after installation

set -e

echo "=========================================="
echo "Jenkins Configuration Helper"
echo "=========================================="

JENKINS_URL="${JENKINS_URL:-http://localhost:8080}"
JENKINS_USER="${JENKINS_USER:-admin}"
JENKINS_PASSWORD="${JENKINS_PASSWORD:-}"

if [ -z "$JENKINS_PASSWORD" ]; then
    echo "Please provide Jenkins admin password:"
    read -s JENKINS_PASSWORD
fi

echo ""
echo "Jenkins URL: $JENKINS_URL"
echo "Jenkins User: $JENKINS_USER"
echo ""

# Install required plugins
echo "Installing required plugins..."

PLUGINS=(
    "git"
    "workflow-aggregator"
    "pipeline-stage-view"
    "aws-credentials"
    "ssh"
    "ssh-steps"
    "credentials-binding"
    "github"
    "blueocean"
)

for plugin in "${PLUGINS[@]}"; do
    echo "Installing plugin: $plugin"
    java -jar jenkins-cli.jar -s $JENKINS_URL -auth $JENKINS_USER:$JENKINS_PASSWORD install-plugin $plugin || true
done

echo ""
echo "Plugins installation initiated. Please restart Jenkins:"
echo "sudo systemctl restart jenkins"
echo ""
echo "After restart, configure credentials manually:"
echo "1. Go to: Manage Jenkins -> Credentials -> System -> Global credentials"
echo "2. Add SSH credentials (ID: ec2-ssh-key)"
echo "3. Add Secret text for EC2 IP (ID: ec2-instance-ip)"
echo "4. Add AWS credentials if needed (ID: aws-credentials)"
echo ""

