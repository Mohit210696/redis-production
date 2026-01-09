pipeline {
    agent any

    environment {
        TF_IN_AUTOMATION = "true"
        TF_INPUT = "0"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init & Plan (DEV)') {
            when { branch 'develop' }
            steps {
                sshagent(credentials: ['bastion-ssh-key']) {
                    sh '''
ssh -o StrictHostKeyChecking=no ubuntu@172.31.15.44 << 'EOF'
set -e
cd ~/redis-production/terraform
terraform workspace select dev || terraform workspace new dev
terraform init -input=false
terraform plan -var-file=dev.tfvars
EOF
                    '''
                }
            }
        }

        stage('Terraform Apply (DEV auto)') {
            when { branch 'develop' }
            steps {
                sshagent(credentials: ['bastion-ssh-key']) {
                    sh '''
ssh -o StrictHostKeyChecking=no ubuntu@172.31.15.44 << 'EOF'
set -e
cd ~/redis-production/terraform
terraform workspace select dev
terraform apply -auto-approve -var-file=dev.tfvars
EOF
                    '''
                }
            }
        }

        stage('Terraform Init & Plan (PROD)') {
            when { branch 'main' }
            steps {
                sshagent(credentials: ['bastion-ssh-key']) {
                    sh '''
ssh -o StrictHostKeyChecking=no ubuntu@172.31.15.44 << 'EOF'
set -e
cd ~/redis-production/terraform
terraform workspace select prod || terraform workspace new prod
terraform init -input=false
terraform plan -var-file=prod.tfvars
EOF
                    '''
                }
            }
        }

        stage('Manual Approval (PROD)') {
            when { branch 'main' }
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    input message: 'Approve Terraform Apply to PROD?', ok: 'Apply'
                }
            }
        }

        stage('Terraform Apply (PROD manual)') {
            when { branch 'main' }
            steps {
                sshagent(credentials: ['bastion-ssh-key']) {
                    sh '''
ssh -o StrictHostKeyChecking=no ubuntu@172.31.15.44 << 'EOF'
set -e
cd ~/redis-production/terraform
terraform workspace select prod
terraform apply -auto-approve -var-file=prod.tfvars
EOF
                    '''
                }
            }
        }
    }
}

