#! /bin/bash 
mkdir download
cd download/
wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
unzip terraform_0.11.7_linux_amd64.zip 
mv terraform /usr/bin/terraform
terraform
exit