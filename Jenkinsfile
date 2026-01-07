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
            when {
                branch 'main'
            }
            steps {
                sshagent(credentials: ['bastion-ssh-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@172.31.15.44 "
                          export TF_VAR_key_name=redis.0788 &&
                          export TF_IN_AUTOMATION=true &&
                          export TF_INPUT=0 &&
                          cd ~/redis-production/terraform &&
                          terraform init -input=false &&
                          terraform plan -input=false
                        "
                    '''
                }
            }
        }
         
       stage('Manual Approval') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Approve Terraform Apply to PRODUCTION?', ok: 'Apply'
            }
        }

        stage('Terraform Apply(Manual approval)') {
            when {
                branch 'main'
            } 
            steps {
                sshagent(credentials: ['bastion-ssh-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@172.31.15.44 \
                        "export TF_VAR_key_name=redis.0788 && \
                        export TF_IN_AUTOMATION=true && \
                        export TF_INPUT=0 && \
                        cd ~/redis-production/terraform && \
                        terraform apply -auto-approve
                    '''
                }
            }
        }

    }
}

