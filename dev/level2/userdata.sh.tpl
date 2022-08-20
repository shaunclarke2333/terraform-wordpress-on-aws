#!/bin/bash
function get-config() {
    
    # aws region environment variable for aws cli
    export AWS_DEFAULT_REGION=us-east-1;

    # installing git
    sudo yum install -y git;
    
    # cloning repo with wordpress config files
    git clone https://github.com/shaunclarke2333/html_website_deploy.git;

    # executing wordpress config script
    bash html_website_deploy/deploy_html_site.sh;
}

#calling function.
get-config
