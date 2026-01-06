
peline {
    agent any

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
                      ssh -o StrictHostKeyChecking=no ubuntu@172.31.15.44 << 'EOF'
                        set -e
                        cd ~/redis-production/terraform
                        terraform init -input=false
                        terraform plan -input=false
                      EOF
                    '''
                }
            }
        }
    }
}

pipeline {
    agent any

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
   }
}

stage('Terraform Init & Plan') {
    steps {
        sshagent(['bastion-ssh-key']) {
            sh '''
              ssh -o StrictHostKeyChecking=no ubuntu@172.31.15.44 << 'EOF'
                set -e
                cd ~/redis-production/terraform
                terraform init -input=false
                terraform plan -input=false
              EOF
            '''
        }
    }
}

