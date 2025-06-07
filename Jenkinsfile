pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Sync GPT State') {
            steps {
                sh './devops/sync/executable_sync-gpt.sh'
            }
        }
    }
}
