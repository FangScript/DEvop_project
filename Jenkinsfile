pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'
        APP_NAME = 'devops-demo-app'
        EC2_INSTANCE_IP = credentials('ec2-instance-ip')
        EC2_USER = 'ec2-user'
        EC2_KEY = credentials('ec2-ssh-key')
        DEPLOY_PATH = '/home/ec2-user/app'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from Git repository...'
                checkout scm
                sh 'git log -1 --oneline'
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building the application...'
                sh '''
                    python3 -m venv venv
                    source venv/bin/activate || venv\\Scripts\\activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }
        
        stage('Test') {
            steps {
                echo 'Running tests...'
                sh '''
                    source venv/bin/activate || venv\\Scripts\\activate
                    pytest test_app.py -v --cov=app --cov-report=term-missing
                '''
            }
            post {
                always {
                    publishTestResults testResultsPattern: 'test-results.xml'
                    publishCoverage adapters: [coberturaAdapter('coverage.xml')]
                }
            }
        }
        
        stage('Package') {
            steps {
                echo 'Packaging the application...'
                sh '''
                    mkdir -p dist
                    tar -czf dist/${APP_NAME}-${BUILD_NUMBER}.tar.gz \
                        app.py requirements.txt \
                        --exclude=venv --exclude=.git --exclude=dist
                '''
                archiveArtifacts artifacts: 'dist/*.tar.gz', fingerprint: true
            }
        }
        
        stage('Deploy to EC2') {
            steps {
                echo 'Deploying application to AWS EC2 instance...'
                script {
                    def sshCommand = """
                        # Create deployment directory
                        mkdir -p ${DEPLOY_PATH}
                        
                        # Stop existing application if running
                        pkill -f 'gunicorn.*app:app' || true
                        
                        # Extract application files
                        cd ${DEPLOY_PATH}
                        tar -xzf ${APP_NAME}-${BUILD_NUMBER}.tar.gz
                        
                        # Create virtual environment and install dependencies
                        python3 -m venv venv
                        source venv/bin/activate
                        pip install --upgrade pip
                        pip install -r requirements.txt
                        
                        # Start application with Gunicorn
                        nohup gunicorn -w 2 -b 0.0.0.0:5000 app:app > app.log 2>&1 &
                        
                        # Wait a moment and check if app is running
                        sleep 5
                        curl -f http://localhost:5000/health || exit 1
                    """
                    
                    // Copy package to EC2
                    sh """
                        scp -o StrictHostKeyChecking=no \
                            -i ${EC2_KEY} \
                            dist/${APP_NAME}-${BUILD_NUMBER}.tar.gz \
                            ${EC2_USER}@${EC2_INSTANCE_IP}:${DEPLOY_PATH}/
                    """
                    
                    // Execute deployment commands on EC2
                    sh """
                        ssh -o StrictHostKeyChecking=no \
                            -i ${EC2_KEY} \
                            ${EC2_USER}@${EC2_INSTANCE_IP} \
                            '${sshCommand}'
                    """
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                echo 'Verifying deployment...'
                sh """
                    sleep 10
                    curl -f http://${EC2_INSTANCE_IP}:5000/health || exit 1
                    curl -f http://${EC2_INSTANCE_IP}:5000/ | grep -q success || exit 1
                """
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
            emailext (
                subject: "SUCCESS: Pipeline '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Pipeline succeeded. Application deployed to EC2.",
                to: "${env.CHANGE_AUTHOR_EMAIL}"
            )
        }
        failure {
            echo 'Pipeline failed!'
            emailext (
                subject: "FAILURE: Pipeline '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Pipeline failed. Please check the console output.",
                to: "${env.CHANGE_AUTHOR_EMAIL}"
            )
        }
        always {
            cleanWs()
        }
    }
}

