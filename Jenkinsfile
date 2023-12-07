pipeline {
    agent any
    stages {
        stage('Install Dependencies') {
            steps {
                sh '''
                    apt-get update
                    apt-get -y install python3-pip
                    apt-get -y install git
                '''
            }
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
                sh '''
                    cd ansible-devops/ibm/mas_devops
                    id
                    cat /etc/os-release
                '''
                
            }
        }
    }
}
