pipeline {
    agent any
    stages {
        stage('Install Dependencies') {
            steps {
                sh '''
                    whoami
                    sudo apt-get update
                    sudo apt-get -y install python3-pip
                    sudo apt-get -y install git
                '''
            }
        }
    }
}
