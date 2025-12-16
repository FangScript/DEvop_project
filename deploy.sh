#!/bin/bash
# Deployment script for EC2 instance
# This script is executed on the EC2 instance

set -e

APP_NAME="devops-demo-app"
DEPLOY_PATH="/home/ec2-user/app"
BUILD_NUMBER=$1

if [ -z "$BUILD_NUMBER" ]; then
    echo "Error: Build number is required"
    exit 1
fi

echo "Starting deployment of ${APP_NAME} build ${BUILD_NUMBER}..."

# Create deployment directory
mkdir -p ${DEPLOY_PATH}
cd ${DEPLOY_PATH}

# Stop existing application
echo "Stopping existing application..."
pkill -f 'gunicorn.*app:app' || true
sleep 2

# Extract application files
echo "Extracting application files..."
tar -xzf ${APP_NAME}-${BUILD_NUMBER}.tar.gz

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment and install dependencies
echo "Installing dependencies..."
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Start application with Gunicorn
echo "Starting application..."
nohup gunicorn -w 2 -b 0.0.0.0:5000 app:app > app.log 2>&1 &

# Wait and verify application is running
sleep 5
if curl -f http://localhost:5000/health > /dev/null 2>&1; then
    echo "Deployment successful! Application is running."
    exit 0
else
    echo "Deployment failed! Application is not responding."
    exit 1
fi

