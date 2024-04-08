# Use Ubuntu as the base image
FROM ubuntu:latest

# Update the package list and install required dependencies
RUN apt-get update && \
    apt-get install -y curl unzip

# Download kubectl binary
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        ARCH="amd64"; \
    fi && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl"

# Download kubectl checksum file
RUN KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt) && \
    ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        ARCH="amd64"; \
    fi && \
    curl -LO "https://dl.k8s.io/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl.sha256"

# Validate the binary
RUN echo "$(cat kubectl.sha256) kubectl" | sha256sum --check --status || echo "ERROR: Invalid checksum"

# Install kubectl
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Test the installed version
RUN kubectl version --client

# Clean up
RUN rm kubectl kubectl.sha256

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod +x get_helm.sh && \
    ./get_helm.sh && \
    mv /usr/local/bin/helm /usr/bin/helm

# Clean up
RUN rm get_helm.sh

# Install Kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && \
    chmod +x kustomize && \
    mv ./kustomize /usr/bin/kustomize

# Download and install awscli
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        ARCH="amd64"; \
    fi && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# Cleanup
RUN rm awscliv2.zip && \
    rm -rf ./aws

# Set PATH environment variable to include /usr/bin
ENV PATH="${PATH}:/usr/bin"

# Command to keep the container running (example: sleep infinity)
CMD ["sleep", "infinity"]
