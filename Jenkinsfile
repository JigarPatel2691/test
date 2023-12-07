pipeline {
    agent { dockerfile true }
    stages {
        stage('Clone MAS Repo') {
            steps {
                sh "git clone https://github.com/ibm-mas/ansible-devops.git"
                echo '${PWD}'
            }
        }
        stage('Build Collection') {
            steps {
                sh "cd ansible-devops/ibm/mas_devops"
                sh "ansible-galaxy collection build"
            }
        }
    }
}
