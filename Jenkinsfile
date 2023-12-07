pipeline {
    agent { dockerfile true }
    stages {
        stage('Clone MAS Repo') {
            steps {
                git clone https://github.com/ibm-mas/ansible-devops.git
                echo '${PWD}'
            }
        }
    }
}
