# Use Ubuntu as the base image
FROM ubuntu:latest

# Update the package list and install required dependencies
RUN apt-get update && \
    apt-get install -y curl

# Install kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod +x get_helm.sh && \
    ./get_helm.sh && \
    mv /usr/local/bin/helm /usr/bin/helm

# Install Kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && \
    chmod +x kustomize && \
    mv ./kustomize /usr/bin/kustomize

# Set PATH environment variable to include /usr/bin
ENV PATH="${PATH}:/usr/bin"

# Command to keep the container running (example: sleep infinity)
CMD ["sleep", "infinity"]
