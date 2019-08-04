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
            print('Source Code Review Running')
            }
    }
    stage('Database setup')
    {
      agent {
            docker {
              image 'mysql:latest'
              args ' --network my_network -e MYSQL_ROOT_PASSWORD=admin '
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
              args ' --network my_network -e XDG_CACHE_HOME=\'/tmp/.cache\' -v /var/lib/jenkins/workspace/govwa:/go/src/govwa'
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
