pipeline {
    agent { dockerfile true }
    environment {
        ANSIBLE_REMOTE_TEMP=/tmp/.ansible/tmp
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
                sh "export 
                sh "ansible-galaxy collection build"
            }
        }
    }
}
