# Jenkins Quick Setup Guide

Since Jenkins is already installed, follow these steps to configure the pipeline:

## Step 1: Install Required Plugins

1. Go to: `http://localhost:8080/pluginManager/available` (or your Jenkins URL)
2. Search and install these plugins:
   - **Git Plugin**
   - **Pipeline Plugin**
   - **AWS Credentials Plugin**
   - **SSH Pipeline Steps**
   - **Credentials Binding Plugin**
   - **GitHub Plugin** (if using GitHub)
   - **Blue Ocean** (optional, for better UI)

3. Restart Jenkins if prompted

## Step 2: Configure Credentials

Go to: `http://localhost:8080/credentials/store/system/domain/_/`

### Credential 1: SSH Key for EC2
- Click **"Add Credentials"**
- **Kind**: SSH Username with private key
- **ID**: `ec2-ssh-key`
- **Description**: SSH key for EC2 deployment
- **Username**: `ec2-user` (or `ubuntu` for Ubuntu instances)
- **Private Key**: Enter directly (paste your `.pem` file content)
- Click **OK**

### Credential 2: EC2 Instance IP
- Click **"Add Credentials"**
- **Kind**: Secret text
- **ID**: `ec2-instance-ip`
- **Description**: EC2 Instance IP Address
- **Secret**: Your EC2 public IP address (e.g., `54.123.45.67`)
- Click **OK**

### Credential 3: AWS Credentials (Optional)
- Only needed if Jenkins is NOT running on AWS EC2
- Click **"Add Credentials"**
- **Kind**: AWS Credentials
- **ID**: `aws-credentials`
- **Access Key ID**: Your AWS Access Key
- **Secret Access Key**: Your AWS Secret Key
- Click **OK**

## Step 3: Create Pipeline Job

1. Go to: `http://localhost:8080/view/all/newJob`
2. Enter item name: `devops-cicd-pipeline`
3. Select: **Pipeline**
4. Click **OK**

### Configure the Job:

**General:**
- Description: `CI/CD Pipeline for DevOps Demo Application`

**Build Triggers:**
- Check **"Poll SCM"**
- Schedule: `H/5 * * * *` (checks every 5 minutes)
- OR check **"GitHub hook trigger for GITscm polling"** (if using webhook)

**Pipeline:**
- **Definition**: Pipeline script from SCM
- **SCM**: Git
- **Repository URL**: `https://github.com/FangScript/DEvop_project.git`
- **Credentials**: (leave empty if public repo)
- **Branches to build**: `*/main`
- **Script Path**: `Jenkinsfile`
- **Lightweight checkout**: (unchecked)

5. Click **Save**

## Step 4: Test the Pipeline

1. Go to: `http://localhost:8080/job/devops-cicd-pipeline`
2. Click **"Build Now"**
3. Click on the build number (#1)
4. Click **"Console Output"** to see progress

The pipeline will:
- ✓ Checkout code from Git
- ✓ Build the application
- ✓ Run tests
- ✓ Package the application
- ✓ Deploy to EC2
- ✓ Verify deployment

## Step 5: Verify Deployment

After successful build, test your deployed application:

```bash
curl http://<EC2-IP>:5000/health
curl http://<EC2-IP>:5000/
curl http://<EC2-IP>:5000/api/info
```

## Step 6: Configure GitHub Webhook (Optional)

For automatic builds on Git push:

1. Go to: `https://github.com/FangScript/DEvop_project/settings/hooks`
2. Click **"Add webhook"**
3. **Payload URL**: `http://your-jenkins-url/github-webhook/`
4. **Content type**: `application/json`
5. **Events**: Just the push event
6. Click **"Add webhook"**

**Note**: If Jenkins is behind a firewall, use ngrok:
```bash
ngrok http 8080
```
Use the ngrok URL in webhook.

## Quick Links

- **Jenkins Dashboard**: `http://localhost:8080`
- **Pipeline Job**: `http://localhost:8080/job/devops-cicd-pipeline`
- **Git Repository**: `https://github.com/FangScript/DEvop_project.git`

## Troubleshooting

### Pipeline fails at SSH connection
- Verify EC2 security group allows SSH from Jenkins server IP
- Check SSH key credential is correct
- Test SSH manually: `ssh -i key.pem ec2-user@<EC2-IP>`

### Application not accessible
- Check EC2 security group allows port 5000
- Verify application is running: `ps aux | grep gunicorn`
- Check logs: `cat /home/ec2-user/app/app.log`

### Tests fail
- Verify all dependencies in `requirements.txt`
- Check Python version compatibility

### Git trigger not working
- Verify repository URL is correct
- Use "Poll SCM" as fallback
- Check webhook URL if using GitHub webhook

## Need Help?

See detailed documentation:
- `README.md` - Main documentation
- `SETUP_GUIDE.md` - Detailed setup guide
- `QUICK_START.md` - Quick reference

