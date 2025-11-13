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
                git branch: 'master', url: 'https://github.com/Ankushambhore/test2.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                set -e
                set -x
                docker build -t ${ECR_REPO}:${IMAGE_TAG} .
                docker images
                """
            }
        }

        stage('Login to ECR') {
            steps {
                withAWS(credentials: 'aws-jenkins-creds', region: "${AWS_REGION}") {
                    sh """
                    set -e
                    set -x
                    aws sts get-caller-identity
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    """
                }
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh """
                set -e
                set -x
                docker tag ${ECR_REPO}:${IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}
                docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}
                """
            }
        }

        stage('Verify in ECR') {
            steps {
                sh """
                set -e
                set -x
                aws ecr describe-images --repository-name ${ECR_REPO} --region ${AWS_REGION} --query "imageDetails[?imageTags[0]=='${IMAGE_TAG}']"
                """
            }
        }
    }
}
