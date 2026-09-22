pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                bat 'cd app && npm ci'
            }
        }

        stage('Run Tests') {
            steps {
                bat 'cd app & npm test'
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t devops-fullstack-app:%BUILD_NUMBER% .'
            }
        }

        stage('Load Image into minikube') {
            steps {
                bat 'minikube image load devops-fullstack-app:%BUILD_NUMBER%'
            }    
        }

        stage('Terraform Deploy') {
            steps {
                bat 'cd terraform && terraform init'
                bat 'cd terraform && terraform apply -auto-approve -var="image_tag=%BUILD_NUMBER%"'
            }
        }
    }
}