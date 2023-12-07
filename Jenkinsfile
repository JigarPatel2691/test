pipeline {
    agent { dockerfile true }
    stages {
        stage('Clone MAS Repo') {
            steps {
                script { 
                    try {
                        sh "git clone https://github.com/ibm-mas/ansible-devops.git"                    
                    } catch (err) {
                        echo err.getMessage()
                        echo "Error detected, but we will continue."
                    }
                }
            }
        }
        stage('Build Collection') {
            steps {
                sh "cd ansible-devops/ibm/mas_devops"
                sh "export ANSIBLE_REMOTE_TEMP=/tmp/.ansible/tmp"
                sh "ansible-galaxy collection build"
            }
        }
    }
}
