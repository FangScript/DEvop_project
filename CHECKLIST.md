# Assignment Checklist

Use this checklist to track your progress through the assignment.

## Part 1: Git Repository Setup

- [ ] Initialize local Git repository
- [ ] Create remote repository (GitHub/GitLab/Bitbucket)
- [ ] Push code to remote repository
- [ ] Verify repository is accessible
- [ ] **Screenshot**: Git repository with code

## Part 2: AWS EC2 Instance Setup

- [ ] Create AWS account (if needed)
- [ ] Launch EC2 instance (t2.micro)
- [ ] Configure security group:
  - [ ] SSH (port 22) from your IP
  - [ ] HTTP (port 80) from anywhere
  - [ ] Custom TCP (port 5000) from anywhere
- [ ] Create/download key pair (.pem file)
- [ ] Note EC2 public IP address
- [ ] Connect to EC2 via SSH
- [ ] Install Python 3, pip, and git on EC2
- [ ] Verify installations
- [ ] **Screenshot**: EC2 instance dashboard (running instance)
- [ ] **Screenshot**: Security group inbound rules

## Part 3: Jenkins Configuration

- [ ] Install Jenkins (if not already installed)
- [ ] Access Jenkins web interface
- [ ] Install required plugins:
  - [ ] Git Plugin
  - [ ] Pipeline Plugin
  - [ ] AWS Credentials Plugin
  - [ ] SSH Pipeline Steps
  - [ ] Credentials Binding Plugin
- [ ] Configure SSH credentials in Jenkins:
  - [ ] ID: `ec2-ssh-key`
  - [ ] Username: `ec2-user` (or `ubuntu`)
  - [ ] Private key configured
- [ ] Configure EC2 IP credential:
  - [ ] ID: `ec2-instance-ip`
  - [ ] Secret: EC2 public IP
- [ ] Configure AWS credentials (if needed):
  - [ ] ID: `aws-credentials`
  - [ ] Access keys configured
- [ ] **Screenshot**: Jenkins credentials configuration

## Part 4: Jenkins Pipeline Job

- [ ] Create new Pipeline job
- [ ] Name: `devops-cicd-pipeline`
- [ ] Configure Git repository URL
- [ ] Configure branch (main/master)
- [ ] Set Script Path: `Jenkinsfile`
- [ ] Configure build triggers:
  - [ ] GitHub webhook OR
  - [ ] Poll SCM (schedule: `H/5 * * * *`)
- [ ] Save job configuration
- [ ] **Screenshot**: Pipeline job configuration

## Part 5: GitHub Webhook (Optional but Recommended)

- [ ] Go to GitHub repository settings
- [ ] Add webhook
- [ ] Configure webhook URL: `http://<jenkins-url>/github-webhook/`
- [ ] Set content type: `application/json`
- [ ] Select events: Push events
- [ ] Save webhook
- [ ] Test webhook (push a commit)
- [ ] **Screenshot**: Webhook configuration (if using GitHub)

## Part 6: Test the Pipeline

- [ ] Trigger pipeline manually (Build Now)
- [ ] Monitor build progress
- [ ] Verify all stages complete successfully:
  - [ ] Checkout stage
  - [ ] Build stage
  - [ ] Test stage
  - [ ] Package stage
  - [ ] Deploy to EC2 stage
  - [ ] Verify Deployment stage
- [ ] Check console output for errors
- [ ] **Screenshot**: Build history (showing successful builds)
- [ ] **Screenshot**: Pipeline stages execution (Blue Ocean view recommended)

## Part 7: Verify Deployment

- [ ] Test health endpoint: `curl http://<EC2-IP>:5000/health`
- [ ] Test home endpoint: `curl http://<EC2-IP>:5000/`
- [ ] Test info endpoint: `curl http://<EC2-IP>:5000/api/info`
- [ ] Verify application is running on EC2
- [ ] Check application logs on EC2
- [ ] **Screenshot**: Application response (curl output or browser)

## Part 8: Test Git Trigger

- [ ] Make a small change to code (e.g., update version)
- [ ] Commit changes: `git commit -m "Test trigger"`
- [ ] Push to repository: `git push origin main`
- [ ] Verify Jenkins automatically triggers new build
- [ ] Wait for build to complete
- [ ] Verify new version is deployed
- [ ] **Screenshot**: Git commit triggering Jenkins build

## Part 9: Documentation

- [ ] Review all documentation files:
  - [ ] README.md
  - [ ] SETUP_GUIDE.md
  - [ ] QUICK_START.md
- [ ] Document any issues encountered:
  - [ ] Issue description
  - [ ] Solution applied
- [ ] Create final documentation with:
  - [ ] Introduction/overview
  - [ ] Step-by-step setup instructions
  - [ ] All required screenshots
  - [ ] Configuration details
  - [ ] Testing procedures
  - [ ] Issues encountered and solutions
  - [ ] Conclusion/lessons learned

## Part 10: Final Verification

- [ ] All pipeline stages working correctly
- [ ] Application successfully deployed to EC2
- [ ] Application accessible and responding
- [ ] Git trigger working (automatic builds)
- [ ] All screenshots captured
- [ ] Documentation complete
- [ ] Code pushed to Git repository
- [ ] Ready for submission

## Screenshot Checklist

Ensure you have screenshots of:

1. [ ] Git repository with code
2. [ ] EC2 instance dashboard (running instance)
3. [ ] Security group configuration (inbound rules)
4. [ ] Jenkins credentials (SSH key, EC2 IP)
5. [ ] Jenkins pipeline job configuration
6. [ ] Build history (successful builds)
7. [ ] Pipeline stages execution (Blue Ocean view)
8. [ ] Application running (curl/browser output)
9. [ ] Git commit triggering build (if applicable)
10. [ ] Webhook configuration (if using GitHub)

## Notes Section

Use this space to document any issues, solutions, or important notes:

### Issues Encountered:
1. 
2. 
3. 

### Solutions Applied:
1. 
2. 
3. 

### Additional Notes:
- 
- 

---

**Assignment Status**: ⬜ Not Started | ⬜ In Progress | ⬜ Completed

**Date Started**: _______________

**Date Completed**: _______________

