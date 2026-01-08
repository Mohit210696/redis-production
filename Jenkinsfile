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

        stage('Select Terraform Workspace') {
            steps {
                sshagent(credentials: ['bastion-ssh-key']) {
                    sh '''
                      if [ "$BRANCH_NAME" = "develop" ]; then
                        WORKSPACE=dev
                      else
                        WORKSPACE=prod
                      fi

                      ssh ubuntu@172.31.15.44 "
                        cd ~/redis-production/terraform &&
                        terraform workspace select $WORKSPACE
                      "
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                sshagent(credentials: ['bastion-ssh-key']) {
                    sh '''
                      ssh ubuntu@172.31.15.44 "
                        cd ~/redis-production/terraform &&
                        terraform plan
                      "
                    '''
                }
            }
        }

        stage('Manual Approval (PROD only)') {
            when {
                branch 'main'
            }
            steps {
                input message: "Approve Terraform Apply to PRODUCTION?", ok: "Apply"
            }
        }

        stage('Terraform Apply') {
            steps {
                sshagent(credentials: ['bastion-ssh-key']) {
                    sh '''
                      ssh ubuntu@172.31.15.44 "
                        cd ~/redis-production/terraform &&
                        terraform apply -auto-approve
                      "
                    '''
                }
            }
        }
    }
}
