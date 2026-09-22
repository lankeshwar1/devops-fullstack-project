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
    }
}