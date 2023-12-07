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
                        '''
                    } catch (err) {
                        echo err.getMessage()
                        echo "Error detected, but we will continue."
                    }
                }
            }
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
                    export PATH=$PATH:/var/lib/jenkins/.local/bin
                    cd ansible-devops/ibm/mas_devops
                    ansible-galaxy collection build
                    ansible-galaxy collection install ibm-mas_devops-*.tar.gz --ignore-certs --force
                    rm ibm-mas_devops-*.tar.gz

                '''
                
            }
        }
        stage('Create OpenShift Cluster') {
            steps {
                sh '''
                    export FYRE_USERNAME="jigar.patel2"
                    export FYRE_APIKEY="vVorG8gspkKpMiCH6IlSFU0zTsmOhMztBNcAt2IVg"
                    export FYRE_PRODUCT_ID="225"
                    export CLUSTER_TYPE="quickburn"
                    export CLUSTER_NAME="DemoOpenshiftCluster"
                    export OCP_VERSION="4.13"
                    ansible-playbook playbooks/ocp_fyre_provision.yml
                '''
            }
        }
    }
}
