pipeline {
  agent any

  environment {
    DEPLOY_HOST = "198.96.88.177"
    DEPLOY_USER = "wingman"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Verify Codex Scripts') {
      steps {
        sh 'bash scripts/verify_codex_changes.sh'
      }
    }

    stage('Run Codex Agent Deploy') {
      steps {
        sh 'bash agents/codex-deploy-agent/deploy.sh'
      }
    }

    stage('Push Codex Results') {
      steps {
        sshagent(['wingman-ssh-key']) {
          sh '''
            git config user.email "wingman@pegasuswingman.com"
            git config user.name "Wingman CI"
            git add .
            git commit -m "🤖 CI: Auto-pushed changes from Jenkins" || true
            git push origin codex-patch-bundle || true
          '''
        }
      }
    }
  }

  post {
    failure {
      echo "Build failed. See logs at ${env.BUILD_URL}"
    }
  }
}
