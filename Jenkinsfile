pipeline {
  agent any
  stages {
    stage('error') {
      steps {
        echo 'checkout'
        git(url: 'https://github.com/penguin02007/vagrant.git', changelog: true, branch: 'master', poll: true)
      }
    }
  }
}