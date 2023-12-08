pipeline {
    agent any
    parameters {
        string(name: 'oc_login_command', description: 'Please enter oc login command with --insecure-skip-tls-verify flag.')
    }
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
/*
        stage('Create OpenShift Cluster') {
            steps {
                try {
                    sh '''
                        export PATH=$PATH:/var/lib/jenkins/.local/bin
                        export FYRE_USERNAME="jigar.patel2"
                        export FYRE_APIKEY="vVorG8gspkKpMiCH6IlSFU0zTsmOhMztBNcAt2IVg"
                        export FYRE_PRODUCT_ID="225"
                        export CLUSTER_TYPE="quickburn"
                        export CLUSTER_NAME="DemoOpenshiftCluster"
                        export OCP_VERSION="4.13"
                        cd ansible-devops/ibm/mas_devops
                        ansible-playbook playbooks/ocp_fyre_provision.yml
                    '''
                } catch (err) {
                    echo.err.getMessage()
                    echo "Error detected whicl creating/login to cluster, continuing with oc login command"
                }
                
            }
        }
*/
        stage('OC login') {
            steps {
                sh '''
                    wget -q https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-linux-4.14.4.tar.gz
                    tar -zxf openshift-client-linux-4.14.4.tar.gz
                    sudo mv oc kubectl /usr/local/bin/
                    rm -rf openshift-client-linux*.gz
                    ${oc_login_command}
                '''
            }
        }
        stage('ansible run_role') {
            steps {
                sh '''
                    cd ansible-devops/ibm/mas_devops
                    export ROLE_NAME="ocs"
                    ansible-playbook playbooks/run_role.yml
                '''
            }
        }
    }
}
