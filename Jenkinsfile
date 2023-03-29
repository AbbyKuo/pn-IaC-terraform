pipeline {

    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')''
        AWS_SECRET_ACCESS_KEY = credentials('AWS_ACCESS_KEY_ID')
    }

    stages {
        stage('TF init & plan') {
            steps {
                sh 'terraform init'
                sh 'terraform validate'
                sh 'terraform plan -out tfplan'
            }
        }
        stage('TF apply') {
            steps {
                sh 'terraform apply -input=false tfplan' // input=false to disables all of Terraform's interactive prompts
            }
        }
    }

    post {
        always {
        cleanWs()
                sh 'ls -la'
            }
    }
}
