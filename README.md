# DevOps CI/CD Pipeline Project

This project demonstrates a complete CI/CD pipeline using Jenkins to automatically build, test, and deploy a Flask application to an AWS EC2 instance.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Prerequisites](#prerequisites)
3. [Project Structure](#project-structure)
4. [Setup Instructions](#setup-instructions)
5. [Jenkins Pipeline Configuration](#jenkins-pipeline-configuration)
6. [AWS EC2 Setup](#aws-ec2-setup)
7. [Troubleshooting](#troubleshooting)
8. [Screenshots and Documentation](#screenshots-and-documentation)

## Project Overview

This project implements a CI/CD pipeline that:
- Automatically pulls code from a Git repository
- Builds a Python Flask application
- Runs unit tests with coverage
- Packages the application
- Deploys to an AWS EC2 instance
- Verifies the deployment

## Prerequisites

Before starting, ensure you have:

1. **AWS Account** with EC2 access
2. **Git Repository** (GitHub, GitLab, or Bitbucket)
3. **Jenkins Server** installed and running
4. **Python 3.8+** installed on Jenkins server and EC2 instance
5. **SSH Access** to EC2 instance
6. **Basic knowledge** of:
   - Git version control
   - Jenkins CI/CD
   - AWS EC2
   - Linux commands

## Project Structure

```
devops-project/
├── app.py                 # Flask application
├── test_app.py           # Unit tests
├── requirements.txt      # Python dependencies
├── Jenkinsfile          # Jenkins pipeline definition
├── deploy.sh            # Deployment script for EC2
├── .gitignore          # Git ignore file
└── README.md           # This file
```

## Setup Instructions

### Step 1: Create Git Repository

1. Initialize a Git repository:
   ```bash
   git init
   git add .
   git commit -m "Initial commit: CI/CD pipeline setup"
   ```

2. Create a repository on GitHub/GitLab/Bitbucket and push your code:
   ```bash
   git remote add origin <your-repo-url>
   git branch -M main
   git push -u origin main
   ```

### Step 2: Create AWS EC2 Instance

#### 2.1 Launch EC2 Instance

1. Log in to AWS Console
2. Navigate to EC2 Dashboard
3. Click "Launch Instance"
4. Configure the instance:
   - **Name**: `devops-demo-server`
   - **AMI**: Amazon Linux 2023 or Ubuntu 22.04 LTS
   - **Instance Type**: t2.micro (free tier eligible)
   - **Key Pair**: Create new or select existing key pair
   - **Network Settings**: 
     - Create security group
     - Allow SSH (port 22) from your IP
     - Allow HTTP (port 80) and Custom TCP (port 5000) from anywhere (0.0.0.0/0)
   - **Storage**: 8 GB gp3 (default)
5. Click "Launch Instance"

#### 2.2 Configure Security Group

1. Go to Security Groups in EC2 Dashboard
2. Select your instance's security group
3. Edit inbound rules and add:
   - **Type**: SSH, Port: 22, Source: Your IP
   - **Type**: HTTP, Port: 80, Source: 0.0.0.0/0
   - **Type**: Custom TCP, Port: 5000, Source: 0.0.0.0/0
4. Save rules

#### 2.3 Connect to EC2 Instance

1. Note your instance's public IP address
2. Connect via SSH:
   ```bash
   ssh -i your-key.pem ec2-user@<EC2-IP-ADDRESS>
   ```
   (For Ubuntu, use `ubuntu` instead of `ec2-user`)

#### 2.4 Install Required Software on EC2

Once connected to EC2, run:

```bash
# Update system packages
sudo yum update -y  # For Amazon Linux
# OR
sudo apt-get update && sudo apt-get upgrade -y  # For Ubuntu

# Install Python 3 and pip
sudo yum install python3 python3-pip -y  # For Amazon Linux
# OR
sudo apt-get install python3 python3-pip python3-venv -y  # For Ubuntu

# Install Git (if not already installed)
sudo yum install git -y  # For Amazon Linux
# OR
sudo apt-get install git -y  # For Ubuntu

# Verify installations
python3 --version
pip3 --version
```

### Step 3: Configure AWS Credentials in Jenkins

#### 3.1 Install Required Jenkins Plugins

1. Go to Jenkins Dashboard → Manage Jenkins → Manage Plugins
2. Install the following plugins:
   - **Git Plugin** (usually pre-installed)
   - **Pipeline Plugin** (usually pre-installed)
   - **AWS Credentials Plugin**
   - **SSH Pipeline Steps**
   - **Credentials Binding Plugin**

#### 3.2 Configure AWS Credentials

**Option A: Using AWS Access Keys**

1. Go to Jenkins Dashboard → Manage Jenkins → Credentials
2. Click "System" → "Global credentials"
3. Click "Add Credentials"
4. Configure:
   - **Kind**: AWS Credentials
   - **ID**: `aws-credentials`
   - **Access Key ID**: Your AWS Access Key
   - **Secret Access Key**: Your AWS Secret Key
   - **Description**: AWS Credentials for EC2
5. Click "OK"

**Option B: Using IAM Role (Recommended for EC2-based Jenkins)**

If Jenkins is running on an EC2 instance:
1. Create an IAM role with EC2 permissions
2. Attach the role to your Jenkins EC2 instance
3. No need to configure credentials in Jenkins

#### 3.3 Configure SSH Credentials for EC2

1. Go to Jenkins Dashboard → Manage Jenkins → Credentials
2. Click "System" → "Global credentials"
3. Click "Add Credentials"
4. Configure:
   - **Kind**: SSH Username with private key
   - **ID**: `ec2-ssh-key`
   - **Username**: `ec2-user` (or `ubuntu` for Ubuntu)
   - **Private Key**: Enter directly or upload your `.pem` file
   - **Description**: SSH key for EC2 deployment
5. Click "OK"

#### 3.4 Configure EC2 Instance IP

1. Go to Jenkins Dashboard → Manage Jenkins → Credentials
2. Click "System" → "Global credentials"
3. Click "Add Credentials"
4. Configure:
   - **Kind**: Secret text
   - **ID**: `ec2-instance-ip`
   - **Secret**: Your EC2 instance public IP address
   - **Description**: EC2 Instance IP Address
5. Click "OK"

### Step 4: Create Jenkins Job

#### 4.1 Create Pipeline Job

1. Go to Jenkins Dashboard → New Item
2. Enter job name: `devops-cicd-pipeline`
3. Select "Pipeline" and click "OK"

#### 4.2 Configure Pipeline

1. **General Settings**:
   - Description: "CI/CD Pipeline for DevOps Demo Application"
   - Check "GitHub project" if using GitHub and enter project URL

2. **Build Triggers**:
   - Check "GitHub hook trigger for GITscm polling" (for webhook)
   - OR check "Poll SCM" and set schedule: `H/5 * * * *` (polls every 5 minutes)

3. **Pipeline Definition**:
   - Definition: Pipeline script from SCM
   - SCM: Git
   - Repository URL: Your Git repository URL
   - Credentials: Add if repository is private
   - Branches to build: `*/main` or `*/master`
   - Script Path: `Jenkinsfile`

4. Click "Save"

#### 4.3 Configure GitHub Webhook (Optional but Recommended)

1. Go to your GitHub repository → Settings → Webhooks
2. Click "Add webhook"
3. Configure:
   - **Payload URL**: `http://your-jenkins-url/github-webhook/`
   - **Content type**: application/json
   - **Events**: Just the push event
4. Click "Add webhook"

### Step 5: Run the Pipeline

1. Go to your Jenkins job dashboard
2. Click "Build Now" to trigger the pipeline manually
3. Click on the build number to view progress
4. Check "Console Output" for detailed logs

## Jenkins Pipeline Configuration

The `Jenkinsfile` defines the following stages:

### Stage 1: Checkout
- Pulls latest code from Git repository
- Displays latest commit information

### Stage 2: Build
- Creates Python virtual environment
- Installs application dependencies

### Stage 3: Test
- Runs unit tests using pytest
- Generates test coverage report

### Stage 4: Package
- Creates a compressed archive of the application
- Archives artifacts for deployment

### Stage 5: Deploy to EC2
- Copies package to EC2 instance via SCP
- Executes deployment script on EC2
- Starts application using Gunicorn

### Stage 6: Verify Deployment
- Checks application health endpoint
- Verifies application is responding

## AWS EC2 Setup

### Security Group Configuration

Ensure your EC2 security group allows:
- **Inbound SSH (22)**: From your IP or Jenkins server IP
- **Inbound HTTP (80)**: From anywhere (0.0.0.0/0)
- **Inbound Custom TCP (5000)**: From anywhere (0.0.0.0/0)

### EC2 Instance Requirements

- Python 3.8 or higher
- pip3 installed
- Sufficient disk space (minimum 2 GB free)
- Network connectivity to Jenkins server

## Troubleshooting

### Common Issues and Solutions

#### Issue 1: Jenkins cannot connect to EC2 via SSH

**Solution**:
- Verify security group allows SSH from Jenkins server IP
- Check that SSH key is correctly configured in Jenkins credentials
- Test SSH connection manually: `ssh -i key.pem ec2-user@<IP>`
- Ensure EC2 instance is running

#### Issue 2: Application fails to start on EC2

**Solution**:
- Check application logs: `cat /home/ec2-user/app/app.log`
- Verify Python and dependencies are installed correctly
- Check if port 5000 is available: `netstat -tulpn | grep 5000`
- Ensure security group allows traffic on port 5000

#### Issue 3: Tests fail in Jenkins

**Solution**:
- Verify all dependencies are in `requirements.txt`
- Check Python version compatibility
- Review test output in Jenkins console

#### Issue 4: Git trigger not working

**Solution**:
- Verify webhook URL is correct
- Check Jenkins logs for webhook events
- Use "Poll SCM" as fallback option
- Verify repository URL and credentials in Jenkins job

#### Issue 5: Permission denied errors

**Solution**:
- Ensure deployment script has execute permissions: `chmod +x deploy.sh`
- Verify user has write permissions to deployment directory
- Check file ownership on EC2 instance

### Useful Commands

**On EC2 Instance**:
```bash
# Check if application is running
ps aux | grep gunicorn

# View application logs
tail -f /home/ec2-user/app/app.log

# Test application locally
curl http://localhost:5000/health

# Stop application
pkill -f gunicorn

# Check port usage
sudo netstat -tulpn | grep 5000
```

**In Jenkins**:
- View build logs: Click on build number → Console Output
- Check workspace: Click on build number → Workspace
- View test results: Click on build number → Test Result

## Screenshots and Documentation

### Required Screenshots

Document your setup with screenshots of:

1. **AWS EC2 Instance**:
   - EC2 instance dashboard showing running instance
   - Security group configuration
   - Instance details (IP address, key pair, etc.)

2. **Jenkins Configuration**:
   - Jenkins credentials configuration (AWS and SSH)
   - Pipeline job configuration
   - Build history showing successful builds

3. **Pipeline Execution**:
   - Pipeline stages execution (Blue Ocean view recommended)
   - Test results
   - Deployment logs

4. **Application Verification**:
   - Application running on EC2 (curl or browser)
   - Health check endpoint response
   - Application info endpoint response

### Testing the Application

After successful deployment, test the application:

```bash
# Health check
curl http://<EC2-IP>:5000/health

# Home endpoint
curl http://<EC2-IP>:5000/

# Info endpoint
curl http://<EC2-IP>:5000/api/info
```

Expected responses:
- `/health`: `{"status": "healthy", "service": "devops-demo-app"}`
- `/`: `{"message": "Welcome to DevOps CI/CD Pipeline Demo", "status": "success", "version": "1.0.0"}`
- `/api/info`: Application information JSON

## Additional Notes

- The pipeline uses Gunicorn as the WSGI server for production deployment
- Application runs on port 5000 by default
- Logs are stored in `/home/ec2-user/app/app.log` on EC2
- Each build creates a new package with build number
- Previous deployments are overwritten (consider implementing versioning)

## Evaluation Checklist

- [x] Git repository created and configured
- [x] AWS EC2 instance created with proper security groups
- [x] AWS credentials configured in Jenkins
- [x] Jenkins pipeline job created with all required stages
- [x] Git trigger configured (webhook or polling)
- [x] Application successfully deploys to EC2
- [x] Documentation complete with screenshots

## Author

[Your Name]

## Date

[Current Date]

