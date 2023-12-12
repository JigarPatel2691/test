pipeline {
    agent any
    parameters {
        string(name: 'oc_login_command', description: 'Please enter oc login command with --insecure-skip-tls-verify flag.')
        booleanParam(name: 'MAS-CORE', defaultValue: false, description: 'Do you want MAS core to be installed ?')
        booleanParam(name: 'MANAGE', defaultValue: false, description: 'Do you want MANAGE to be installed ?')
        booleanParam(name: 'Prepare_local_env', defaultValue: false, description: 'Do you want install dependences and setup environment ?')
    }
    stages {
        stage('Install Dependencies') {
            when {
                environment name: 'Prepare_local_env', value: 'true'
            }
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
                    export PATH=$PATH:/var/lib/jenkins/.local/bin
                    cd ansible-devops/ibm/mas_devops
                    export ROLE_NAME="ocs"
                    ansible-playbook playbooks/run_role.yml
                '''
            }
        }
        stage('ansible oneclick_core') {
            when {
                environment name: 'MAS-CORE', value: 'true'
            }
            steps {
                sh '''
                echo "starting one core installation...."
                export PATH=$PATH:/var/lib/jenkins/.local/bin
                echo $PWD
                #cd ansible-devops/ibm/mas_devops
                export ARTIFACTORY_USERNAME="pmqcloud@us.ibm.com"
                export ARTIFACTORY_TOKEN="eyJ2ZXIiOiIyIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYiLCJraWQiOiI1Z0dyZUE3SUk1NWNZelJDSmVHcDJXV01YSnV2SjJvWUNfeVcwNnM5WFQwIn0.eyJzdWIiOiJqZi1hY2Nlc3NAYzE0NTBhNDMtZjgyNS00MDA2LTg2ZjMtNDMzNzJiOTVmNjAxXC91c2Vyc1wvcG1xY2xvdWRAdXMuaWJtLmNvbSIsInNjcCI6ImFwcGxpZWQtcGVybWlzc2lvbnNcL3VzZXIiLCJhdWQiOlsiamZydEAqIiwiamZ4ckAqIl0sImlzcyI6ImpmLWFjY2Vzc0BjMTQ1MGE0My1mODI1LTQwMDYtODZmMy00MzM3MmI5NWY2MDEiLCJleHAiOjE3MDQ2MjU3NTMsImlhdCI6MTY5Njg0OTc1MywianRpIjoiYWRkYmY0M2UtYWQ5Yy00OGMwLThhNzUtMGRhOGIzM2Q0ODAxIn0.dZivp35RHFfKgn2T5BLu3dUjmrUfVUW_DPSj_pheg0jEElU6QafkyWNuvq4jfNCCDXne7ba9Gl880nZcS2Y67kkaV1eYmIN1IkTSrM3xtktnwr5Ny91Mq5X61SpnyXpqW8Bk4zb349gqflv39G9yFhMZBuRBeO95fKTLMJposBxqLqYyZSVm0g1kE2Wx6fgTCWCn0gndefZges0zZMe_3WxHKfvA2AjLR02TmAWx70Z3Pa24UqsVUE_it4-XMqUipK77N52DuXrpicYFnG8bMIJn-INC9uy4b1WcsNqduzCUi8jf2hFRpWVptrNfAkwrxT5WFAa6xUxmwet2Nsza0g"
                export ARTIFACTORY_APIKEY="eyJ2ZXIiOiIyIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYiLCJraWQiOiI1Z0dyZUE3SUk1NWNZelJDSmVHcDJXV01YSnV2SjJvWUNfeVcwNnM5WFQwIn0.eyJzdWIiOiJqZi1hY2Nlc3NAYzE0NTBhNDMtZjgyNS00MDA2LTg2ZjMtNDMzNzJiOTVmNjAxXC91c2Vyc1wvcG1xY2xvdWRAdXMuaWJtLmNvbSIsInNjcCI6ImFwcGxpZWQtcGVybWlzc2lvbnNcL3VzZXIiLCJhdWQiOlsiamZydEAqIiwiamZ4ckAqIl0sImlzcyI6ImpmLWFjY2Vzc0BjMTQ1MGE0My1mODI1LTQwMDYtODZmMy00MzM3MmI5NWY2MDEiLCJleHAiOjE3MDQ2MjU3NTMsImlhdCI6MTY5Njg0OTc1MywianRpIjoiYWRkYmY0M2UtYWQ5Yy00OGMwLThhNzUtMGRhOGIzM2Q0ODAxIn0.dZivp35RHFfKgn2T5BLu3dUjmrUfVUW_DPSj_pheg0jEElU6QafkyWNuvq4jfNCCDXne7ba9Gl880nZcS2Y67kkaV1eYmIN1IkTSrM3xtktnwr5Ny91Mq5X61SpnyXpqW8Bk4zb349gqflv39G9yFhMZBuRBeO95fKTLMJposBxqLqYyZSVm0g1kE2Wx6fgTCWCn0gndefZges0zZMe_3WxHKfvA2AjLR02TmAWx70Z3Pa24UqsVUE_it4-XMqUipK77N52DuXrpicYFnG8bMIJn-INC9uy4b1WcsNqduzCUi8jf2hFRpWVptrNfAkwrxT5WFAa6xUxmwet2Nsza0g"
                export MAS_CHANNEL="9.0.x-stable"
                export MAS_CATALOG_VERSION="v8-master-amd64"
                #export MAS_CATALOG_VERSION="v8-predict-dev-amd64"
                export MAS_INSTANCE_ID="devops01"
                export MAS_WORKSPACE_ID="main"
                export MAS_ICR_CP="docker-na-public.artifactory.swg-devops.com/wiotp-docker-local"
                export MAS_ICR_CPOPEN="docker-na-public.artifactory.swg-devops.com/wiotp-docker-local/cpopen"
                export MAS_ENTITLEMENT_USERNAME="pmqcloud@us.ibm.com"
                export MAS_ENTITLEMENT_KEY="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE2OTY4NDgxNDQsImp0aSI6IjhjNWJjMDVmYjhhYjQwMjBiYTRjZGM3ODI0OGZhZGUyIn0.ebvdA1RyPEHJHfq6GlnUHdsOF52l7rFL7KcVFBIDsqc"
                export MAS_CONFIG_DIR="/home/jigar/mas_devops_jigar"
                mkdir -p /home/jigar/mas_devops_jigar
                export IBM_ENTITLEMENT_KEY=${MAS_ENTITLEMENT_KEY}
                export SLS_LICENSE_ID="0242ac110002"
                export SLS_LICENSE_FILE="/home/jigar/authorized_entitlement.lic"
                #export UDS_CONTACT_EMAIL="jigar.patel2@ibm.com"
                #export UDS_CONTACT_FIRSTNAME="jigar"
                #export UDS_CONTACT_LASTNAME="patel"
                export UDS_CONTACT_EMAIL="xxx@xxx.com"
                export UDS_CONTACT_FIRSTNAME="xxx"
                export UDS_CONTACT_LASTNAME="xxx"
                ansible-playbook playbooks/oneclick_core.yml
            '''
            }
        }
        stage('Add Manage') {
            when {
                environment name: 'MANAGE', value: 'true'
            }
            steps{
                sh '''
                export PATH=$PATH:/var/lib/jenkins/.local/bin
                cd ansible-devops/ibm/mas_devops
                export MAS_INSTANCE_ID="devops01"
                export MAS_CONFIG_DIR="/home/jigar/mas_devops_jigar"
                export IBM_ENTITLEMENT_KEY="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE2OTY4NDgxNDQsImp0aSI6IjhjNWJjMDVmYjhhYjQwMjBiYTRjZGM3ODI0OGZhZGUyIn0.ebvdA1RyPEHJHfq6GlnUHdsOF52l7rFL7KcVFBIDsqc"
                export ARTIFACTORY_USERNAME="pmqcloud@us.ibm.com"
                export ARTIFACTORY_TOKEN="eyJ2ZXIiOiIyIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYiLCJraWQiOiI1Z0dyZUE3SUk1NWNZelJDSmVHcDJXV01YSnV2SjJvWUNfeVcwNnM5WFQwIn0.eyJzdWIiOiJqZi1hY2Nlc3NAYzE0NTBhNDMtZjgyNS00MDA2LTg2ZjMtNDMzNzJiOTVmNjAxXC91c2Vyc1wvcG1xY2xvdWRAdXMuaWJtLmNvbSIsInNjcCI6ImFwcGxpZWQtcGVybWlzc2lvbnNcL3VzZXIiLCJhdWQiOlsiamZydEAqIiwiamZ4ckAqIl0sImlzcyI6ImpmLWFjY2Vzc0BjMTQ1MGE0My1mODI1LTQwMDYtODZmMy00MzM3MmI5NWY2MDEiLCJleHAiOjE3MDQ2MjU3NTMsImlhdCI6MTY5Njg0OTc1MywianRpIjoiYWRkYmY0M2UtYWQ5Yy00OGMwLThhNzUtMGRhOGIzM2Q0ODAxIn0.dZivp35RHFfKgn2T5BLu3dUjmrUfVUW_DPSj_pheg0jEElU6QafkyWNuvq4jfNCCDXne7ba9Gl880nZcS2Y67kkaV1eYmIN1IkTSrM3xtktnwr5Ny91Mq5X61SpnyXpqW8Bk4zb349gqflv39G9yFhMZBuRBeO95fKTLMJposBxqLqYyZSVm0g1kE2Wx6fgTCWCn0gndefZges0zZMe_3WxHKfvA2AjLR02TmAWx70Z3Pa24UqsVUE_it4-XMqUipK77N52DuXrpicYFnG8bMIJn-INC9uy4b1WcsNqduzCUi8jf2hFRpWVptrNfAkwrxT5WFAa6xUxmwet2Nsza0g"
                export ARTIFACTORY_APIKEY="eyJ2ZXIiOiIyIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYiLCJraWQiOiI1Z0dyZUE3SUk1NWNZelJDSmVHcDJXV01YSnV2SjJvWUNfeVcwNnM5WFQwIn0.eyJzdWIiOiJqZi1hY2Nlc3NAYzE0NTBhNDMtZjgyNS00MDA2LTg2ZjMtNDMzNzJiOTVmNjAxXC91c2Vyc1wvcG1xY2xvdWRAdXMuaWJtLmNvbSIsInNjcCI6ImFwcGxpZWQtcGVybWlzc2lvbnNcL3VzZXIiLCJhdWQiOlsiamZydEAqIiwiamZ4ckAqIl0sImlzcyI6ImpmLWFjY2Vzc0BjMTQ1MGE0My1mODI1LTQwMDYtODZmMy00MzM3MmI5NWY2MDEiLCJleHAiOjE3MDQ2MjU3NTMsImlhdCI6MTY5Njg0OTc1MywianRpIjoiYWRkYmY0M2UtYWQ5Yy00OGMwLThhNzUtMGRhOGIzM2Q0ODAxIn0.dZivp35RHFfKgn2T5BLu3dUjmrUfVUW_DPSj_pheg0jEElU6QafkyWNuvq4jfNCCDXne7ba9Gl880nZcS2Y67kkaV1eYmIN1IkTSrM3xtktnwr5Ny91Mq5X61SpnyXpqW8Bk4zb349gqflv39G9yFhMZBuRBeO95fKTLMJposBxqLqYyZSVm0g1kE2Wx6fgTCWCn0gndefZges0zZMe_3WxHKfvA2AjLR02TmAWx70Z3Pa24UqsVUE_it4-XMqUipK77N52DuXrpicYFnG8bMIJn-INC9uy4b1WcsNqduzCUi8jf2hFRpWVptrNfAkwrxT5WFAa6xUxmwet2Nsza0g"
                export MAS_CHANNEL="9.0.x-stable"
                export MAS_CATALOG_VERSION="v8-master-amd64"
                #export MAS_CATALOG_VERSION="v8-predict-dev-amd64"
                export MAS_INSTANCE_ID="devops01"
                export MAS_WORKSPACE_ID="main"
                export MAS_ICR_CP="docker-na-public.artifactory.swg-devops.com/wiotp-docker-local"
                export MAS_ICR_CPOPEN="docker-na-public.artifactory.swg-devops.com/wiotp-docker-local/cpopen"
                export MAS_ENTITLEMENT_USERNAME="pmqcloud@us.ibm.com"
                export MAS_ENTITLEMENT_KEY="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE2OTY4NDgxNDQsImp0aSI6IjhjNWJjMDVmYjhhYjQwMjBiYTRjZGM3ODI0OGZhZGUyIn0.ebvdA1RyPEHJHfq6GlnUHdsOF52l7rFL7KcVFBIDsqc"
                export MAS_CONFIG_DIR="/home/jigar/mas_devops_jigar"
                mkdir -p /home/jigar/mas_devops_jigar
                export IBM_ENTITLEMENT_KEY=${MAS_ENTITLEMENT_KEY}
                export SLS_LICENSE_ID="0242ac110002"
                export SLS_LICENSE_FILE="/home/jigar/authorized_entitlement.lic"
                #export UDS_CONTACT_EMAIL="jigar.patel2@ibm.com"
                #export UDS_CONTACT_FIRSTNAME="jigar"
                #export UDS_CONTACT_LASTNAME="patel"
                export UDS_CONTACT_EMAIL="xxx@xxx.com"
                export UDS_CONTACT_FIRSTNAME="xxx"
                export UDS_CONTACT_LASTNAME="xxx"
                ${oc_login_command}
                ansible-playbook ibm.mas_devops.oneclick_add_manage
                '''
            }

        }
    }
}
