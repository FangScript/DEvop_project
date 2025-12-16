# Jenkins Complete Setup Script for Windows
# This script provides all commands needed to set up Jenkins

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Jenkins CI/CD Pipeline Setup" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "WARNING: This script should be run as Administrator for some operations" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "Jenkins Setup Instructions:" -ForegroundColor Green
Write-Host ""
Write-Host "OPTION 1: Install Jenkins on Windows (using WSL or Docker)" -ForegroundColor Yellow
Write-Host "OPTION 2: Install Jenkins on Linux Server (Recommended)" -ForegroundColor Yellow
Write-Host ""

$choice = Read-Host "Choose option (1 for Windows/WSL, 2 for Linux Server, or press Enter for manual setup guide)"

if ($choice -eq "1") {
    Write-Host ""
    Write-Host "Setting up Jenkins on Windows using Docker..." -ForegroundColor Green
    Write-Host ""
    Write-Host "Step 1: Install Docker Desktop (if not installed)" -ForegroundColor Cyan
    Write-Host "Download from: https://www.docker.com/products/docker-desktop" -ForegroundColor White
    Write-Host ""
    Write-Host "Step 2: Run Jenkins in Docker:" -ForegroundColor Cyan
    Write-Host 'docker run -d -p 8080:8080 -p 50000:50000 --name jenkins -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts' -ForegroundColor White
    Write-Host ""
    Write-Host "Step 3: Get initial admin password:" -ForegroundColor Cyan
    Write-Host 'docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword' -ForegroundColor White
    Write-Host ""
    Write-Host "Step 4: Access Jenkins at: http://localhost:8080" -ForegroundColor Cyan
    Write-Host ""
    
    $runDocker = Read-Host "Do you want to run Jenkins Docker container now? (y/n)"
    if ($runDocker -eq "y" -or $runDocker -eq "Y") {
        Write-Host "Checking Docker..." -ForegroundColor Yellow
        docker --version
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Starting Jenkins container..." -ForegroundColor Green
            docker run -d -p 8080:8080 -p 50000:50000 --name jenkins -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
            Write-Host ""
            Write-Host "Jenkins is starting... Wait 30 seconds, then:" -ForegroundColor Green
            Write-Host "1. Access: http://localhost:8080" -ForegroundColor White
            Write-Host "2. Get password: docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword" -ForegroundColor White
        } else {
            Write-Host "Docker is not installed. Please install Docker Desktop first." -ForegroundColor Red
        }
    }
}
elseif ($choice -eq "2") {
    Write-Host ""
    Write-Host "Linux Server Setup Commands:" -ForegroundColor Green
    Write-Host ""
    Write-Host "For Ubuntu/Debian - Copy and paste this single command:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host 'curl -fsSL https://raw.githubusercontent.com/FangScript/DEvop_project/main/setup-linux-jenkins.sh | bash' -ForegroundColor White
    Write-Host ""
    Write-Host "OR run these commands manually:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "# Update system" -ForegroundColor Gray
    Write-Host "sudo apt-get update" -ForegroundColor White
    Write-Host ""
    Write-Host "# Install Java" -ForegroundColor Gray
    Write-Host "sudo apt-get install -y openjdk-17-jdk" -ForegroundColor White
    Write-Host ""
    Write-Host "# Add Jenkins repository" -ForegroundColor Gray
    Write-Host 'curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null' -ForegroundColor White
    Write-Host 'echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null' -ForegroundColor White
    Write-Host ""
    Write-Host "# Install Jenkins" -ForegroundColor Gray
    Write-Host "sudo apt-get update && sudo apt-get install -y jenkins" -ForegroundColor White
    Write-Host ""
    Write-Host "# Start Jenkins" -ForegroundColor Gray
    Write-Host "sudo systemctl start jenkins && sudo systemctl enable jenkins" -ForegroundColor White
    Write-Host ""
    Write-Host "# Get initial password" -ForegroundColor Gray
    Write-Host "sudo cat /var/lib/jenkins/secrets/initialAdminPassword" -ForegroundColor White
    Write-Host ""
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "After Jenkins Installation:" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Access Jenkins: http://localhost:8080 (or your server IP:8080)" -ForegroundColor White
Write-Host "2. Enter initial admin password (from above)" -ForegroundColor White
Write-Host "3. Install suggested plugins" -ForegroundColor White
Write-Host "4. Create admin user" -ForegroundColor White
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Configure Jenkins Pipeline:" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "After Jenkins is running, configure the pipeline:" -ForegroundColor Yellow
Write-Host ""
Write-Host "A. Install Required Plugins:" -ForegroundColor Green
Write-Host "   Manage Jenkins -> Manage Plugins -> Available" -ForegroundColor White
Write-Host "   Install: Git, Pipeline, AWS Credentials, SSH Pipeline Steps, GitHub" -ForegroundColor White
Write-Host ""
Write-Host "B. Configure Credentials:" -ForegroundColor Green
Write-Host "   Manage Jenkins -> Credentials -> System -> Global credentials" -ForegroundColor White
Write-Host "   1. Add SSH Username with private key (ID: ec2-ssh-key)" -ForegroundColor White
Write-Host "   2. Add Secret text (ID: ec2-instance-ip) with your EC2 IP" -ForegroundColor White
Write-Host "   3. Add AWS Credentials (ID: aws-credentials) if needed" -ForegroundColor White
Write-Host ""
Write-Host "C. Create Pipeline Job:" -ForegroundColor Green
Write-Host "   New Item -> devops-cicd-pipeline -> Pipeline" -ForegroundColor White
Write-Host "   Pipeline script from SCM" -ForegroundColor White
Write-Host "   Repository: https://github.com/FangScript/DEvop_project.git" -ForegroundColor White
Write-Host "   Script Path: Jenkinsfile" -ForegroundColor White
Write-Host "   Build Triggers: Poll SCM (H/5 * * * *)" -ForegroundColor White
Write-Host ""
Write-Host "D. Run Pipeline:" -ForegroundColor Green
Write-Host "   Click 'Build Now' to test" -ForegroundColor White
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Quick Reference:" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Jenkins URL: http://localhost:8080" -ForegroundColor White
Write-Host "Repository: https://github.com/FangScript/DEvop_project.git" -ForegroundColor White
Write-Host "Pipeline File: Jenkinsfile" -ForegroundColor White
Write-Host ""
Write-Host "For detailed instructions, see:" -ForegroundColor Yellow
Write-Host "  - SETUP_GUIDE.md" -ForegroundColor White
Write-Host "  - README.md" -ForegroundColor White
Write-Host ""

