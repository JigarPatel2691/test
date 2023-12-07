pipeline {
    agent any
    stages {
        stage('Install Dependencies') {
            steps {
                script {
                    try {
                        sh '''
                        sudo apt-get update
                        sudo apt-get install python3-setuptools ca-certificates
                        sudo apt-get -y install git
                        sudo curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
                        python3 get-pip.py 
                        python3 -m pip install ansible junit_xml pymongo xmljson jmespath kubernetes openshift
                        export PATH=$PATH:/var/lib/jenkins/.local/bin
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
