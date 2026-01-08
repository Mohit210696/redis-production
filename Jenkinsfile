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

        stage('Terraform Plan') {
            steps {
                sshagent(credentials: ['bastion-ssh-key']) {
                    sh '''
                      ssh ubuntu@172.31.15.44 "
                        export TF_VAR_key_name=redis.0788 &&
                        cd ~/redis-production/terraform &&
                        terraform workspace select ${BRANCH_NAME} || terraform workspace new ${BRANCH_NAME} &&
                        terraform init -input=false &&
                        terraform plan -input=false
                      "
                    '''
                }
            }
        }

        stage('Terraform Apply DEV (Auto)') {
            when {
                branch 'develop'
            }
            steps {
                sshagent(credentials: ['bastion-ssh-key']) {
                    sh '''
                      ssh ubuntu@172.31.15.44 "
                        export TF_VAR_key_name=redis.0788 &&
                        cd ~/redis-production/terraform &&
                        terraform workspace select dev &&
                        terraform apply -auto-approve
                      "
                    '''
                }
            }
        }

        stage('Manual Approval PROD') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Approve Terraform Apply to PRODUCTION?', ok: 'Apply'
            }
        }

        stage('Terraform Apply PROD') {
            when {
                branch 'main'
            }
            steps {
                sshagent(credentials: ['bastion-ssh-key']) {
                    sh '''
                      ssh ubuntu@172.31.15.44 "
                        export TF_VAR_key_name=redis.0788 &&
                        cd ~/redis-production/terraform &&
                        terraform workspace select prod &&
                        terraform apply -auto-approve
                      "
                    '''
                }
            }
        }
    }
}

