
pipeline {
    agent any

    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init & Validate') {
            steps {
                sh '''
                  cd terraform
                  terraform init -input=false
                  terraform validate
                '''
            }
        }

        stage('Terraform Plan (Read Only)') {
            steps {
                sh '''
                  cd terraform
                  terraform plan -input=false
                '''
            }
        }

        stage('Ansible Ping') {
            steps {
                sh '''
                  cd ansible
                  ansible all -m ping
                '''
            }
        }

        stage('Ansible Apply') {
            steps {
                sh '''
                  cd ansible
                  ansible-playbook playbooks/site.yml
                '''
            }
        }
    }
}


