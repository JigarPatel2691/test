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
                        python3 -m pip install ansible junit_xml pymongo xmljson jmespath kubernetes openshift
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
