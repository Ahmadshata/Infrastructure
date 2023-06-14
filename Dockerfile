FROM ubuntu:18.04

USER root

RUN mkdir -p /var/jenkins_home /home/jenkins


RUN adduser jenkins; echo "jenkins:123456" | chpasswd

RUN chown -R jenkins:jenkins /var/jenkins_home  /home/jenkins

WORKDIR /home/jenkins
RUN apt-get update && apt-get install gettext -y

#dist-upgrade upgrades the entire distribution. 
#It considers dependencies and conflicts between packages and resolves them automatically.

RUN apt-get update && apt-get dist-upgrade -y && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y \
    git \
    apt-transport-https \
    curl \
    init \
    openssh-server openssh-client \
    docker.io \
    sudo \
    vim \
 && rm -rf /var/lib/apt/lists/*
 
 #install helm
 RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 -o get_helm.sh  \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh
#to use sudo with user jenkins uncomment the next line.
#RUN usermod -aG sudo jenkins

#install Gcloud
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-434.0.0-linux-x86_64.tar.gz
RUN tar -xf google-cloud-cli-434.0.0-linux-x86_64.tar.gz
RUN CLOUDSDK_CORE_DISABLE_PROMPTS=1 ./google-cloud-sdk/install.sh
ENV PATH /home/jenkins/google-cloud-sdk/bin:$PATH
RUN gcloud components install gke-gcloud-auth-plugin

#install kubectl
RUN apt update && apt-get install gnupg gnupg1 gnupg2 -y
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN touch /etc/apt/sources.list.d/kubernetes.list 
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y kubectl

# Install Java
RUN apt-get update && apt-get install -y openjdk-11-jdk && rm -rf /var/lib/apt/lists/*


EXPOSE 22

# tail -f the "f" stands for follow it monitors the file in real-time
ENTRYPOINT ["/bin/bash", "-c", "service ssh start && tail -f /dev/null && chmod 777 /var/run/docker.sock"]
