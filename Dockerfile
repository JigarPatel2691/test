FROM ubuntu
RUN apt-get update
RUN apt-get -y install python3-pip
RUN apt-get -y install git
RUN apt-get -y install sudo
#RUN python3 -m pip install ansible junit_xml pymongo xmljson jmespath kubernetes==12.0.1 openshift==0.12.1
RUN python3 -m pip install ansible junit_xml pymongo xmljson jmespath kubernetes openshift
