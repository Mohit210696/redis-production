pipeline {
    agent any

    environment {
        DOCKER_COMPOSE_PATH = "${WORKSPACE}/docker-compose.yml"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Docker') {
            steps {
                sh '''
                if ! command -v docker >/dev/null; then
                    echo "Installing Docker..."
                    sudo apt-get update
                    sudo apt-get install -y docker.io
                    sudo systemctl enable docker
                    sudo systemctl start docker
                fi
                '''
            }
        }

        stage('Deploy Redis and Tools') {
            steps {
                sh '''
                echo "Launching Redis Cluster, RedisInsight & Exporter..."
                sudo docker compose -f ${DOCKER_COMPOSE_PATH} up -d --remove-orphans
                '''
            }
        }
    }
}
