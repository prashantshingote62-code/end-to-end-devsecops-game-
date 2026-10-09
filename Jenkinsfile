properties([
    parameters([
        string(defaultValue: 'variables.tfvars', description: 'Specify the file name', name: 'File-Name'),
        choice(choices: ['plan', 'apply', 'destroy'], description: 'Select Terraform action', name: 'Terraform-Action')
    ])
])

pipeline {
    agent any
    stages {
        stage('Checkout from Git') {
            steps {
                git branch: 'main', url: 'https://github.com/prashantshingote62-code/end-to-end-devsecops-game-.git'
            }
        }
        stage('Initializing Terraform') {
            steps {
                withAWS(credentials: 'aws-key', region: 'ap-south-1') {
                dir('EKS-TF') {
                    script {
                        sh 'set -ex; terraform init -reconfigure'
                    }
                }
                }
            }
        }
        stage('Validate Terraform Code') {
            steps {
                withAWS(credentials: 'aws-key', region: 'ap-south-1') {
                dir('EKS-TF') {
                    script {
                        sh 'set -ex; terraform validate'
                    }
                }
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                withAWS(credentials: 'aws-key', region: 'ap-south-1') {
                dir('EKS-TF') {
                    script {
                        sh "set -ex; terraform plan -var-file=${params.'File-Name'}"
                    }
                }
                }
            }
        }
        stage('Terraform Action') {
            steps {
                withAWS(credentials: 'aws-key', region: 'ap-south-1') {
                dir('EKS-TF') {
                    script {
                        def action = params.'Terraform-Action'
                        def varFile = params.'File-Name'

                        echo "Executing Terraform action: ${action}"

                        if (action == 'plan') {
                            sh "set -ex; terraform plan -var-file=${varFile}"
                        } else if (action == 'apply') {
                            sh "set -ex; terraform apply -auto-approve -var-file=${varFile}"
                        } else if (action == 'destroy') {
                            sh "set -ex; terraform destroy -auto-approve -var-file=${varFile}"
                        } else {
                            error "Invalid value for Terraform-Action: ${action}"
                        }
                    }
                }
                }
            }
        }
    }
}
