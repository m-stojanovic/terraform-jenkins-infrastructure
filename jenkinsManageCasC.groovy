#!/usr/bin/env groovy
import uk.co.devopscher.Utilities
import uk.co.devopscher.EnvParams

def call(Map config=[:]) {
    def scmVars
    node('k8s-deploy') {
        container('jenkins') {
            stage('Configure AWS') {
                withCredentials([string(credentialsId: EnvParams.AWS_ACCESS_KEY, variable: 'access_key'),
                                 string(credentialsId: EnvParams.AWS_SECRET_KEY, variable: 'secret_key')])
                {
                    utils = new Utilities()
                    utils.awsConfigure(this, access_key, secret_key, 'eu-west-1')
                    sh 'aws --version && aws sts get-caller-identity'
                }
            }
            stage('Get terraform version') {
                sh 'terraform version'
            }
            stage('Get terraform code') {
                scmVars = checkout scm
            }
            def applyTerraform = false
            if (params?.dryRun == false) {
                applyTerraform = true
            }
            stage('Run terraform step0') {
                terraformRun(applyTerraform, '1', '1', '1', env)
            }
        }
    }
}

def terraformRun(apply=false, infrustructure=0, helm=0, pvc=0, env) {
    def applyCode = ""
    if (apply) {applyCode = " && /bin/terraform apply /tmp/plan_output"}
    ansiColor('xterm') {
        dir ('k8s') {
            sh """
            set -e
            echo "jenkins_${env.JENKINS_SECOND_ENV}_ec2_count = ${infrustructure}" > terraform.tfvars
            echo "jenkins_${env.JENKINS_SECOND_ENV}_helm_deploy = ${helm}" >> terraform.tfvars
            echo "jenkins_${env.JENKINS_SECOND_ENV}_pvc_count = ${pvc}" >> terraform.tfvars
            echo aws_access_key  = \\"\\" >> terraform.tfvars
            echo aws_secret_key  = \\"\\" >> terraform.tfvars
            echo aws_region  = \\"eu-west-1\\" >> terraform.tfvars
            echo aws_owner_id  = \\"xxxx\\" >> terraform.tfvars
            echo aws_key_path  = \\"./devops-ci.pem\\" >> terraform.tfvars
            echo aws_key_name  = \\"devops-ci\\" >> terraform.tfvars
            ln -sf ../modules_new
            /bin/terraform init
            /bin/terraform plan \
            -target=kubernetes_config_map.jcasc \
            -refresh=true -out /tmp/plan_output ${applyCode}
            """
        }
    }
}
