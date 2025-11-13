pipeline {
    agent any

    environment {
        AWS_REGION = 'eu-north-1'
        AWS_ACCOUNT_ID = '893915939153'
        ECR_REPO = 'test_java'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "🔍 Checking out code from GitHub..."
                git branch: 'master', url: 'https://github.com/Ankushambhore/test2.git'
            }
        }

        stage('Build with Maven') {
            steps {
                echo "⚙️ Building Java project with Maven..."
                sh 'mvn clean install'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image: ${ECR_REPO}:${IMAGE_TAG}"
                sh """
                set -x
                docker build -t ${ECR_REPO}:${IMAGE_TAG} .
                docker images | grep ${ECR_REPO}
                """
            }
        }

        stage('Login to Amazon ECR') {
            steps {
                echo "🔐 Logging into Amazon ECR..."
                withAWS(credentials: 'aws-jenkins-creds', region: "${AWS_REGION}") {
                    sh """
                    set -x
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    """
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                echo "📤 Tagging and pushing image to ECR..."
                sh """
                set -x
                docker tag ${ECR_REPO}:${IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}
                docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}
                """
            }
        }

        stage('Verify Image in ECR') {
            steps {
                echo "✅ Verifying image in ECR..."
                sh """
                set -x
                aws ecr describe-images --repository-name ${ECR_REPO} --region ${AWS_REGION} --query "imageDetails[?imageTags[0]=='${IMAGE_TAG}']"
                """
            }
        }
    }

    post {
        success {
            echo "🎉 SUCCESS: Image pushed to ECR: ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"
        }
        failure {
            echo "❌ Pipeline failed. Check logs for details."
        }
    }
}
