# Jenkins Pipeline Configuration Script
# Run this after Jenkins is installed and accessible

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Jenkins Pipeline Configuration" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$JENKINS_URL = Read-Host "Enter Jenkins URL (default: http://localhost:8080)"
if ([string]::IsNullOrWhiteSpace($JENKINS_URL)) {
    $JENKINS_URL = "http://localhost:8080"
}

Write-Host ""
Write-Host "Jenkins URL: $JENKINS_URL" -ForegroundColor Green
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Step 1: Install Required Plugins" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Go to: $JENKINS_URL/pluginManager/available" -ForegroundColor Yellow
Write-Host ""
Write-Host "Install these plugins:" -ForegroundColor Green
Write-Host "  [*] Git Plugin" -ForegroundColor White
Write-Host "  [*] Pipeline Plugin" -ForegroundColor White
Write-Host "  [*] AWS Credentials Plugin" -ForegroundColor White
Write-Host "  [*] SSH Pipeline Steps" -ForegroundColor White
Write-Host "  [*] Credentials Binding Plugin" -ForegroundColor White
Write-Host "  [*] GitHub Plugin (if using GitHub)" -ForegroundColor White
Write-Host "  [*] Blue Ocean (optional, for better UI)" -ForegroundColor White
Write-Host ""
Write-Host "After installing, restart Jenkins if prompted." -ForegroundColor Yellow
Write-Host ""

$continue = Read-Host "Press Enter after plugins are installed..."

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Step 2: Configure Credentials" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Go to: $JENKINS_URL/credentials/store/system/domain/_/" -ForegroundColor Yellow
Write-Host ""

Write-Host "CREDENTIAL 1: SSH Key for EC2" -ForegroundColor Green
Write-Host "  - Click 'Add Credentials'" -ForegroundColor White
Write-Host "  - Kind: SSH Username with private key" -ForegroundColor White
Write-Host "  - ID: ec2-ssh-key" -ForegroundColor White
Write-Host "  - Description: SSH key for EC2 deployment" -ForegroundColor White
Write-Host "  - Username: ec2-user (or ubuntu for Ubuntu instances)" -ForegroundColor White
Write-Host "  - Private Key: Enter directly (paste your .pem file content)" -ForegroundColor White
Write-Host ""

$ec2KeyPath = Read-Host "Enter path to your EC2 .pem key file (or press Enter to skip)"
if (-not [string]::IsNullOrWhiteSpace($ec2KeyPath) -and (Test-Path $ec2KeyPath)) {
    Write-Host "Key file found. Copy this content to Jenkins:" -ForegroundColor Green
    Write-Host "----------------------------------------" -ForegroundColor Gray
    Get-Content $ec2KeyPath
    Write-Host "----------------------------------------" -ForegroundColor Gray
    Write-Host ""
}

Write-Host "CREDENTIAL 2: EC2 Instance IP" -ForegroundColor Green
Write-Host "  - Click 'Add Credentials'" -ForegroundColor White
Write-Host "  - Kind: Secret text" -ForegroundColor White
Write-Host "  - ID: ec2-instance-ip" -ForegroundColor White
Write-Host "  - Description: EC2 Instance IP Address" -ForegroundColor White
Write-Host "  - Secret: [your-ec2-public-ip]" -ForegroundColor White
Write-Host ""

$ec2IP = Read-Host "Enter your EC2 public IP address (or press Enter to skip)"
if (-not [string]::IsNullOrWhiteSpace($ec2IP)) {
    Write-Host "Use this IP: $ec2IP" -ForegroundColor Green
    Write-Host ""
}

Write-Host "CREDENTIAL 3: AWS Credentials (Optional)" -ForegroundColor Green
Write-Host "  - Only needed if Jenkins is NOT running on AWS EC2" -ForegroundColor Yellow
Write-Host "  - Click 'Add Credentials'" -ForegroundColor White
Write-Host "  - Kind: AWS Credentials" -ForegroundColor White
Write-Host "  - ID: aws-credentials" -ForegroundColor White
Write-Host "  - Access Key ID: [your-aws-access-key]" -ForegroundColor White
Write-Host "  - Secret Access Key: [your-aws-secret-key]" -ForegroundColor White
Write-Host ""

$continue = Read-Host "Press Enter after credentials are configured..."

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Step 3: Create Pipeline Job" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Go to: $JENKINS_URL/view/all/newJob" -ForegroundColor Yellow
Write-Host ""
Write-Host "Configuration Steps:" -ForegroundColor Green
Write-Host "  1. Enter item name: devops-cicd-pipeline" -ForegroundColor White
Write-Host "  2. Select: Pipeline" -ForegroundColor White
Write-Host "  3. Click OK" -ForegroundColor White
Write-Host ""
Write-Host "In the job configuration:" -ForegroundColor Green
Write-Host "  - Description: CI/CD Pipeline for DevOps Demo Application" -ForegroundColor White
Write-Host ""
Write-Host "  - Build Triggers:" -ForegroundColor Yellow
Write-Host "    [*] Poll SCM" -ForegroundColor White
Write-Host "    Schedule: H/5 * * * *  (checks every 5 minutes)" -ForegroundColor White
Write-Host "    OR" -ForegroundColor White
Write-Host "    [*] GitHub hook trigger for GITscm polling" -ForegroundColor White
Write-Host ""
Write-Host "  - Pipeline Definition:" -ForegroundColor Yellow
Write-Host "    Definition: Pipeline script from SCM" -ForegroundColor White
Write-Host "    SCM: Git" -ForegroundColor White
Write-Host "    Repository URL: https://github.com/FangScript/DEvop_project.git" -ForegroundColor White
Write-Host "    Credentials: (leave empty if public repo)" -ForegroundColor White
Write-Host "    Branches to build: */main" -ForegroundColor White
Write-Host "    Script Path: Jenkinsfile" -ForegroundColor White
Write-Host "    Lightweight checkout: (unchecked)" -ForegroundColor White
Write-Host ""
Write-Host "  4. Click Save" -ForegroundColor White
Write-Host ""

$continue = Read-Host "Press Enter after pipeline job is created..."

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Step 4: Test the Pipeline" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Go to: $JENKINS_URL/job/devops-cicd-pipeline" -ForegroundColor Yellow
Write-Host "2. Click 'Build Now'" -ForegroundColor Yellow
Write-Host "3. Click on the build number (#1)" -ForegroundColor Yellow
Write-Host "4. Click Console Output to see progress" -ForegroundColor Yellow
Write-Host ""
Write-Host "The pipeline will:" -ForegroundColor Green
Write-Host "  [*] Checkout code from Git" -ForegroundColor White
Write-Host "  [*] Build the application" -ForegroundColor White
Write-Host "  [*] Run tests" -ForegroundColor White
Write-Host "  [*] Package the application" -ForegroundColor White
Write-Host "  [*] Deploy to EC2" -ForegroundColor White
Write-Host "  [*] Verify deployment" -ForegroundColor White
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Step 5: Verify Deployment" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
if (-not [string]::IsNullOrWhiteSpace($ec2IP)) {
    Write-Host "Test your deployed application:" -ForegroundColor Green
    Write-Host "  curl http://${ec2IP}:5000/health" -ForegroundColor White
    Write-Host "  curl http://${ec2IP}:5000/" -ForegroundColor White
    Write-Host "  curl http://${ec2IP}:5000/api/info" -ForegroundColor White
} else {
    Write-Host "Test your deployed application:" -ForegroundColor Green
    Write-Host "  curl http://[EC2-IP]:5000/health" -ForegroundColor White
    Write-Host "  curl http://[EC2-IP]:5000/" -ForegroundColor White
    Write-Host "  curl http://[EC2-IP]:5000/api/info" -ForegroundColor White
}
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Step 6: Configure GitHub Webhook (Optional)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "For automatic builds on Git push:" -ForegroundColor Green
Write-Host "  1. Go to: https://github.com/FangScript/DEvop_project/settings/hooks" -ForegroundColor Yellow
Write-Host "  2. Click 'Add webhook'" -ForegroundColor White
Write-Host "  3. Payload URL: $JENKINS_URL/github-webhook/" -ForegroundColor White
Write-Host "  4. Content type: application/json" -ForegroundColor White
Write-Host "  5. Events: Just the push event" -ForegroundColor White
Write-Host "  6. Click 'Add webhook'" -ForegroundColor White
Write-Host ""
Write-Host "Note: If Jenkins is behind a firewall, use ngrok:" -ForegroundColor Yellow
Write-Host "  ngrok http 8080" -ForegroundColor White
Write-Host "  Use the ngrok URL in webhook" -ForegroundColor White
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Configuration Complete!" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Quick Links:" -ForegroundColor Green
Write-Host "  Jenkins Dashboard: $JENKINS_URL" -ForegroundColor White
Write-Host "  Pipeline Job: $JENKINS_URL/job/devops-cicd-pipeline" -ForegroundColor White
Write-Host "  Git Repository: https://github.com/FangScript/DEvop_project.git" -ForegroundColor White
Write-Host ""
Write-Host "For detailed documentation, see:" -ForegroundColor Yellow
Write-Host "  - README.md" -ForegroundColor White
Write-Host "  - SETUP_GUIDE.md" -ForegroundColor White
Write-Host ""

