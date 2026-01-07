pipeline {
    agent any

    environment {
        TF_VAR_key_name = "redis.0788"
        TF_IN_AUTOMATION = "true"
        TF_INPUT = "0"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('SSH to Bastion (Test)') {
            steps {
                sshagent(credentials: ['bastion-ssh-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@172.31.15.44 hostname
                        ssh -o StrictHostKeyChecking=no ubuntu@172.31.15.44 whoami
                    '''
                }
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                sshagent(credentials: ['bastion-ssh-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@172.31.15.44  "cd ~/redis-production/terraform && terraform init -input=false && terraform plan -input=false"
                    '''
                }
            }
        }

    }
}

