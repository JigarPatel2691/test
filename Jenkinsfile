pipeline {
    agent any
    stages {
        stage('Install Dependencies') {
            steps {
                script {
                    try {
                        sh '''
                        apt-get update
                        apt-get -y install python3-pip
                        apt-get -y install git
                        '''
                    } catch (err) {
                        echo err.getMessage()
                        echo "Error detected, but we will continue."
                    }
                }
            }
        }
    }
}
