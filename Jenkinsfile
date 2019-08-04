pipeline {
  agent none
  stages {
    stage('Checkout Go Code') {
      agent any
      steps {
        git(url: 'https://github.com/paroksh/govwa.git', branch: 'master')
      }
    }
    stage('Run Source Code Review')
    {
      agent any
      steps{
            sh 'docker network create -d bridge mynetwork1'
            print('Source Code Review2 Running')
            }
    }
    stage('Database setup')
    {
      agent {
            docker {
              image 'mysql:latest'
              args ' --network mynetwork1 -e MYSQL_ROOT_PASSWORD=admin '
            }
      }
      steps {
        sh 'mysql --version'
        }
    }



    stage('Compile Go Application')
     {
      agent {
            docker {
              image 'golang'
              //for cache error
              args ' --network mynetwork1 -e XDG_CACHE_HOME=\'/tmp/.cache\' -v /var/lib/jenkins/workspace/govwa:/go/src/govwa'
                  }
            }
      steps
      {
        sh 'go env'
        sh 'cd /go/src/'
        sh 'go get github.com/go-sql-driver/mysql'
        sh 'go get github.com/gorilla/sessions'
        sh 'go get github.com/julienschmidt/httprouter'
        sh 'go run app.go'
      }
    }
  }
}
