pipeline {
  agent {
    label 'docker'
  }
  environment {
    COMPOSE_PROJECT_NAME = 'inst_access'
    COMPOSE_FILE         = 'docker-compose.yml:docker-compose.test.yml'
  }
  options {
    parallelsAlwaysFailFast()
  }
  stages {
    stage('Build') {
      steps {
        sh 'docker-compose build --pull'
        // Needed to ensure the docker network is created before the linters start
        sh 'docker-compose up -d inst_access'
        sh 'docker-compose run --rm gergich reset'
      }
    }
    stage('Lint') {
      steps {
        sh '''#!/usr/bin/env bash
        set -o pipefail
        docker-compose run --rm inst_access bundle exec rubocop --fail-level autocorrect \
            | docker-compose run --rm gergich capture rubocop -
        '''
      }
    }
    stage ('Spec') {
      steps {
        sh 'docker-compose run inst_access bundle exec rspec --format doc'
        sh '''
        image=$(docker ps --all --no-trunc | grep spec | cut -f 1 -d " " | head -n 1)
        docker cp "$image:/usr/src/app/coverage" .
        '''
        sh 'ls -als coverage'
      }
      post {
        always {
          // publish html
          publishHTML target: [
              allowMissing: false,
              alwaysLinkToLastBuild: false,
              keepAll: true,
              reportDir: "coverage",
              reportFiles: 'index.html',
              reportName: 'Coverage Report'
            ]
        }
      }
    }
  }
  post {
    always {
      sh 'docker-compose run --rm gergich publish'
    }
    cleanup { // Always runs after all other post conditions=
      sh 'docker-compose down --rmi=all --volumes --remove-orphans'
    }
  }
}
