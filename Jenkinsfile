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
        }
    }
}
