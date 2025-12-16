# Step-by-Step Setup Guide

This guide provides detailed step-by-step instructions for setting up the complete CI/CD pipeline.

## Part 1: Git Repository Setup

### 1.1 Initialize Local Repository

```bash
# Navigate to project directory
cd devops-project

# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: CI/CD pipeline setup"
```

### 1.2 Create Remote Repository

1. Go to GitHub/GitLab/Bitbucket
2. Create a new repository (name: `devops-cicd-project`)
3. **DO NOT** initialize with README, .gitignore, or license
4. Copy the repository URL

### 1.3 Push to Remote

```bash
# Add remote repository
git remote add origin <your-repo-url>

# Rename branch to main (if needed)
git branch -M main

# Push to remote
git push -u origin main
```

## Part 2: AWS EC2 Instance Setup

### 2.1 Launch EC2 Instance

1. **Login to AWS Console**
   - Go to https://aws.amazon.com/console/
   - Sign in with your credentials

2. **Navigate to EC2**
   - Search for "EC2" in the services search bar
   - Click on "EC2"

3. **Launch Instance**
   - Click "Launch Instance" button
   - Follow these steps:

   **Step 1: Name and Tags**
   - Name: `devops-demo-server`

   **Step 2: Choose AMI**
   - Select: Amazon Linux 2023 AMI (or Ubuntu Server 22.04 LTS)
   - Architecture: x86_64

   **Step 3: Instance Type**
   - Select: t2.micro (Free tier eligible)
   - Click "Next: Configure Instance Details"

   **Step 4: Configure Instance**
   - Number of instances: 1
   - Network: Default VPC (or create new)
   - Subnet: Default (or any public subnet)
   - Auto-assign Public IP: Enable
   - Click "Next: Add Storage"

   **Step 5: Add Storage**
   - Size: 8 GiB (default)
   - Volume type: gp3
   - Click "Next: Add Tags"

   **Step 6: Add Tags** (Optional)
   - Key: Name, Value: devops-demo-server
   - Click "Next: Configure Security Group"

   **Step 7: Configure Security Group**
   - Security group name: `devops-demo-sg`
   - Description: Security group for DevOps CI/CD demo
   - Add rules:
     - **Type**: SSH, **Port**: 22, **Source**: My IP
     - **Type**: HTTP, **Port**: 80, **Source**: 0.0.0.0/0
     - **Type**: Custom TCP, **Port**: 5000, **Source**: 0.0.0.0/0
   - Click "Review and Launch"

   **Step 8: Review**
   - Review all settings
   - Click "Launch"

   **Step 9: Key Pair**
   - Select "Create a new key pair"
   - Key pair name: `devops-demo-key`
   - Download key pair (save `.pem` file securely)
   - **IMPORTANT**: You won't be able to download this again!
   - Click "Launch Instances"

4. **Wait for Instance to Start**
   - Click "View Instances"
   - Wait for instance state to be "Running"
   - Note the **Public IPv4 address** (you'll need this)

### 2.2 Configure Security Group (If Needed)

If you need to modify security group later:

1. Go to EC2 Dashboard → Security Groups
2. Select `devops-demo-sg`
3. Click "Edit inbound rules"
4. Add/modify rules as needed
5. Click "Save rules"

### 2.3 Connect to EC2 Instance

**For Windows (PowerShell)**:
```powershell
# Navigate to directory with .pem file
cd C:\path\to\key\file

# Set permissions (if needed)
icacls devops-demo-key.pem /inheritance:r
icacls devops-demo-key.pem /grant:r "$($env:USERNAME):(R)"

# Connect via SSH
ssh -i devops-demo-key.pem ec2-user@<YOUR-EC2-IP>
```

**For Linux/Mac**:
```bash
# Set permissions
chmod 400 devops-demo-key.pem

# Connect via SSH
ssh -i devops-demo-key.pem ec2-user@<YOUR-EC2-IP>
```

**Note**: For Ubuntu AMI, use `ubuntu` instead of `ec2-user`

### 2.4 Install Required Software on EC2

Once connected to EC2, run:

```bash
# For Amazon Linux
sudo yum update -y
sudo yum install -y python3 python3-pip git

# For Ubuntu
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y python3 python3-pip python3-venv git

# Verify installations
python3 --version
pip3 --version
git --version

# Create application directory
mkdir -p /home/ec2-user/app
```

## Part 3: Jenkins Setup

### 3.1 Install Jenkins (If Not Already Installed)

**On Ubuntu/Debian**:
```bash
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

**On Amazon Linux/RHEL**:
```bash
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo yum install jenkins java-17-amazon-corretto-headless
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

**Access Jenkins**:
- Open browser: `http://your-jenkins-server:8080`
- Get initial admin password: `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
- Install suggested plugins
- Create admin user

### 3.2 Install Required Jenkins Plugins

1. Go to **Manage Jenkins** → **Manage Plugins**
2. Click **Available** tab
3. Search and install:
   - Git Plugin (usually pre-installed)
   - Pipeline Plugin (usually pre-installed)
   - AWS Credentials Plugin
   - SSH Pipeline Steps
   - Credentials Binding Plugin
   - GitHub Plugin (if using GitHub)
4. Click **Install without restart** or **Download now and install after restart**

### 3.3 Configure Credentials in Jenkins

#### 3.3.1 Configure SSH Key for EC2

1. Go to **Manage Jenkins** → **Credentials**
2. Click **System** → **Global credentials (unrestricted)**
3. Click **Add Credentials**
4. Configure:
   - **Kind**: SSH Username with private key
   - **Scope**: Global
   - **ID**: `ec2-ssh-key`
   - **Description**: SSH key for EC2 deployment
   - **Username**: `ec2-user` (or `ubuntu` for Ubuntu)
   - **Private Key**: 
     - Select "Enter directly"
     - Click "Add" and paste your private key content
     - OR select "From a file on Jenkins master" and upload `.pem` file
5. Click **OK**

**To get private key content**:
```bash
# On your local machine
cat devops-demo-key.pem
# Copy the entire output including -----BEGIN RSA PRIVATE KEY----- and -----END RSA PRIVATE KEY-----
```

#### 3.3.2 Configure EC2 Instance IP

1. Go to **Manage Jenkins** → **Credentials**
2. Click **System** → **Global credentials (unrestricted)**
3. Click **Add Credentials**
4. Configure:
   - **Kind**: Secret text
   - **Scope**: Global
   - **ID**: `ec2-instance-ip`
   - **Description**: EC2 Instance IP Address
   - **Secret**: `<YOUR-EC2-PUBLIC-IP>` (e.g., 54.123.45.67)
5. Click **OK**

#### 3.3.3 Configure AWS Credentials (Optional)

**If Jenkins is NOT on AWS EC2**:

1. Create IAM user in AWS Console:
   - Go to IAM → Users → Create user
   - Name: `jenkins-user`
   - Attach policy: `AmazonEC2FullAccess` (or minimal required permissions)
   - Create access key
   - **Save Access Key ID and Secret Access Key**

2. In Jenkins:
   - Go to **Manage Jenkins** → **Credentials**
   - Click **System** → **Global credentials (unrestricted)**
   - Click **Add Credentials**
   - Configure:
     - **Kind**: AWS Credentials
     - **ID**: `aws-credentials`
     - **Access Key ID**: Your AWS Access Key
     - **Secret Access Key**: Your AWS Secret Key
   - Click **OK**

**If Jenkins IS on AWS EC2** (Recommended):
- Create IAM role with EC2 permissions
- Attach role to Jenkins EC2 instance
- No need to configure credentials in Jenkins

### 3.4 Create Jenkins Pipeline Job

1. **Create New Job**:
   - Go to Jenkins Dashboard
   - Click **New Item**
   - Enter name: `devops-cicd-pipeline`
   - Select **Pipeline**
   - Click **OK**

2. **Configure General Settings**:
   - **Description**: `CI/CD Pipeline for DevOps Demo Application`
   - (Optional) Check **GitHub project** and enter project URL

3. **Configure Build Triggers**:
   - **Option A - GitHub Webhook** (Recommended):
     - Check **GitHub hook trigger for GITscm polling**
   - **Option B - Poll SCM**:
     - Check **Poll SCM**
     - Schedule: `H/5 * * * *` (polls every 5 minutes)

4. **Configure Pipeline**:
   - **Definition**: Pipeline script from SCM
   - **SCM**: Git
   - **Repository URL**: `<your-git-repo-url>`
   - **Credentials**: Add if repository is private
   - **Branches to build**: `*/main` (or `*/master`)
   - **Script Path**: `Jenkinsfile`
   - **Lightweight checkout**: Unchecked

5. Click **Save**

### 3.5 Configure GitHub Webhook (If Using GitHub)

1. Go to your GitHub repository
2. Click **Settings** → **Webhooks**
3. Click **Add webhook**
4. Configure:
   - **Payload URL**: `http://<your-jenkins-url>/github-webhook/`
   - **Content type**: `application/json`
   - **Secret**: (optional, leave empty for now)
   - **Which events**: Just the push event
   - **Active**: Checked
5. Click **Add webhook**

**Note**: If Jenkins is behind a firewall, use a service like ngrok to expose it:
```bash
ngrok http 8080
# Use the ngrok URL in webhook
```

## Part 4: Test the Pipeline

### 4.1 Manual Trigger

1. Go to Jenkins Dashboard
2. Click on `devops-cicd-pipeline`
3. Click **Build Now**
4. Click on the build number (#1)
5. Click **Console Output** to view progress

### 4.2 Verify Deployment

After successful build:

```bash
# Test from your local machine
curl http://<EC2-IP>:5000/health
curl http://<EC2-IP>:5000/
curl http://<EC2-IP>:5000/api/info
```

Expected output:
- `/health`: `{"status": "healthy", "service": "devops-demo-app"}`
- `/`: `{"message": "Welcome to DevOps CI/CD Pipeline Demo", "status": "success", "version": "1.0.0"}`

### 4.3 Test Git Trigger

1. Make a small change to `app.py`:
   ```python
   # Change version number
   'version': '1.0.1'
   ```

2. Commit and push:
   ```bash
   git add app.py
   git commit -m "Update version to 1.0.1"
   git push origin main
   ```

3. Check Jenkins:
   - New build should trigger automatically
   - Wait for build to complete
   - Verify new version is deployed

## Part 5: Troubleshooting

### Issue: Jenkins cannot SSH to EC2

**Check**:
1. Security group allows SSH from Jenkins server IP
2. EC2 instance is running
3. SSH key is correct in Jenkins credentials
4. Username is correct (`ec2-user` for Amazon Linux, `ubuntu` for Ubuntu)

**Test manually**:
```bash
ssh -i devops-demo-key.pem ec2-user@<EC2-IP>
```

### Issue: Application not accessible

**Check**:
1. Security group allows port 5000
2. Application is running: `ps aux | grep gunicorn`
3. Check logs: `cat /home/ec2-user/app/app.log`
4. Test locally on EC2: `curl http://localhost:5000/health`

### Issue: Tests failing

**Check**:
1. All dependencies in `requirements.txt`
2. Python version compatibility
3. Test output in Jenkins console

### Issue: Git trigger not working

**Check**:
1. Webhook URL is correct
2. Jenkins is accessible from internet (or use ngrok)
3. Repository URL and credentials are correct
4. Use "Poll SCM" as fallback

## Part 6: Documentation Requirements

### Required Screenshots

Take screenshots of:

1. **AWS EC2**:
   - EC2 instance dashboard (showing running instance)
   - Security group inbound rules
   - Instance details (IP, key pair, etc.)

2. **Jenkins**:
   - Credentials configuration (SSH key, EC2 IP)
   - Pipeline job configuration
   - Build history (showing successful builds)
   - Pipeline stages (Blue Ocean view recommended)

3. **Application**:
   - Application running (curl output or browser)
   - Health check response
   - Info endpoint response

4. **Git**:
   - Repository with code
   - Commit history
   - Webhook configuration (if applicable)

### Documentation Template

Create a document with:

1. **Introduction**: Brief overview of the project
2. **Architecture**: Diagram or description of the setup
3. **Setup Steps**: Detailed steps with screenshots
4. **Configuration**: All configurations made
5. **Testing**: How to test the pipeline
6. **Issues Encountered**: Any problems and solutions
7. **Conclusion**: Summary and lessons learned

## Next Steps

1. Complete all setup steps above
2. Take required screenshots
3. Test the complete pipeline
4. Document any issues encountered
5. Create final documentation document

Good luck with your assignment!

