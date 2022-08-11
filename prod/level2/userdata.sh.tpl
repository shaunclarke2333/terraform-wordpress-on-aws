#!/bin/bash
function get-config() {
    
    # aws region environment variable for aws cli
    export AWS_DEFAULT_REGION=us-east-1;

    # installing git
    sudo yum install -y git;
    
    # cloning repo with wordpress config files
    git clone https://github.com/shaunclarke2333/aws-wordpress-appconfig.git;

    #Passing env variable to wordpress deploy bash script
    sudo sed -i "s/env_name_here/${env_name}/g" aws-wordpress-appconfig/deploy_wordpress_amzlinux.sh;

    # executing wordpress config script
    bash aws-wordpress-appconfig/deploy_wordpress_amzlinux.sh;
}

#calling function
get-config
