# Use a base image with necessary dependencies (e.g., ubuntu, alpine)
FROM ubuntu:latest

# Install required packages
RUN apt-get update && apt-get install -y curl

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# Install Helm
RUN curl -s https://api.github.com/repos/helm/helm/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | xargs curl -LO && \
    tar -zxvf helm-*-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -rf helm-*-linux-amd64.tar.gz linux-amd64

# Set the entry point
ENTRYPOINT ["/bin/bash"]

