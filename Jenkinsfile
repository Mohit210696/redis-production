pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("mohitredis:latest")
                }
            }
        }

        stage('Run Redis Container') {
            steps {
                script {
                    sh "docker rm -f redis-server || true"
                    sh "docker run -d --name redis-server -p 6379:6379 mohitredis:latest"
                }
            }
        }
    }
}

