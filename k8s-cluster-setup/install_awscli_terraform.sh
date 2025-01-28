#!/bin/bash

# Exit on error
set -e

# Update and install prerequisites
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl unzip jq

# Install Terraform
TERRAFORM_VERSION="1.10.5"
echo "Downloading Terraform version $TERRAFORM_VERSION..."
curl -fsSL "https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o terraform.zip
unzip terraform.zip
sudo mv terraform /usr/local/bin/
rm terraform.zip

echo "Terraform installed: $(terraform -version)"

# Install AWS CLI
AWS_CLI_VERSION="2.23.6"
echo "Downloading AWS CLI version $AWS_CLI_VERSION..."
curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o awscliv2.zip
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

echo "AWS CLI installed: $(aws --version)"

# Completion message
echo "Installation of Terraform and AWS CLI is complete."