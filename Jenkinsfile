pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID     = ''
    AWS_SECRET_ACCESS_KEY = ''
  }

  stages {
    stage('Setup AWS Credentials') {
      steps {
        script {
          withCredentials([usernamePassword(credentialsId: 'aws-creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
            sh '''
              terraform init
              terraform plan
              # prompt approval handled separately
            '''
          }
        }
      }
    }
    stage('Terraform Apply') {
      steps {
        input 'Approve apply?'
        script {
          withCredentials([usernamePassword(credentialsId: 'aws-creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
            sh 'terraform apply -auto-approve'
          }
        }
      }
    }
  }
}

