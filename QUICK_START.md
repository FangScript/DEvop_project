# Quick Start Guide

This is a condensed guide for experienced users. For detailed instructions, see `SETUP_GUIDE.md`.

## Prerequisites Checklist

- [ ] AWS Account with EC2 access
- [ ] Git repository (GitHub/GitLab/Bitbucket)
- [ ] Jenkins server installed and running
- [ ] EC2 instance created and accessible via SSH
- [ ] Python 3.8+ on Jenkins and EC2

## Quick Setup Steps

### 1. Git Repository
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin <your-repo-url>
git push -u origin main
```

### 2. AWS EC2 Instance
- Launch t2.micro instance (Amazon Linux or Ubuntu)
- Security Group: SSH (22), HTTP (80), Custom TCP (5000)
- Download key pair (.pem file)
- Note public IP address
- SSH and install: `python3`, `pip3`, `git`

### 3. Jenkins Credentials
Add these credentials in Jenkins (Manage Jenkins → Credentials):

1. **SSH Key** (`ec2-ssh-key`):
   - Kind: SSH Username with private key
   - Username: `ec2-user` (or `ubuntu`)
   - Private Key: Content of your `.pem` file

2. **EC2 IP** (`ec2-instance-ip`):
   - Kind: Secret text
   - Secret: Your EC2 public IP

3. **AWS Credentials** (if Jenkins not on AWS):
   - Kind: AWS Credentials
   - Access Key ID and Secret Access Key

### 4. Jenkins Plugins
Install: Git Plugin, Pipeline Plugin, AWS Credentials Plugin, SSH Pipeline Steps

### 5. Create Pipeline Job
- New Item → Pipeline
- Name: `devops-cicd-pipeline`
- Build Triggers: GitHub webhook OR Poll SCM (`H/5 * * * *`)
- Pipeline: Pipeline script from SCM
- Repository: Your Git repo URL
- Script Path: `Jenkinsfile`

### 6. Test
- Click "Build Now" in Jenkins
- Check console output
- Verify: `curl http://<EC2-IP>:5000/health`

## Common Commands

**Test Application**:
```bash
curl http://<EC2-IP>:5000/health
curl http://<EC2-IP>:5000/
curl http://<EC2-IP>:5000/api/info
```

**Check Application on EC2**:
```bash
ssh -i key.pem ec2-user@<EC2-IP>
ps aux | grep gunicorn
tail -f /home/ec2-user/app/app.log
```

**Trigger Pipeline**:
- Push to Git: `git push origin main`
- Or manually: Jenkins → Build Now

## Troubleshooting

| Issue | Solution |
|-------|----------|
| SSH connection fails | Check security group, key permissions, username |
| App not accessible | Check security group port 5000, app logs |
| Tests fail | Check requirements.txt, Python version |
| Git trigger not working | Verify webhook URL, use Poll SCM as fallback |

## File Structure

```
devops-project/
├── app.py              # Flask application
├── test_app.py        # Unit tests
├── requirements.txt   # Dependencies
├── Jenkinsfile        # CI/CD pipeline
├── deploy.sh         # Deployment script
├── setup_ec2.sh      # EC2 setup script
├── README.md         # Main documentation
├── SETUP_GUIDE.md    # Detailed setup guide
└── QUICK_START.md    # This file
```

## Next Steps

1. Follow detailed setup in `SETUP_GUIDE.md`
2. Take required screenshots
3. Test complete pipeline
4. Document any issues
5. Submit assignment

