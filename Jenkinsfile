pipeline {
    agent any
    stages {
        stage('Install Dependencies') {
            steps {
                script {
                    try {
                        sh '''
                        sudo apt-get update
                        sudo apt-get -y install python3-pip
                        sudo apt-get -y install git
                        sudo python3 -m pip install ansible junit_xml pymongo xmljson jmespath kubernetes openshift
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
