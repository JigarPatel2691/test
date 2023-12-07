pipeline {
    agent { dockerfile true }
    stages {
        stage('Clone MAS Repo') {
            steps {
                try {
                    sh "git clone https://github.com/ibm-mas/ansible-devops.git"
                }
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
