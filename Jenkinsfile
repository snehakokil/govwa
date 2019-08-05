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
              image 'mysql/mysql-server:5.7'
              args '-d -p 3306:3306 --entrypoint /home/paroksh/Docker/entrypoint.sh --network mynetwork1 --name ammysql2 -e MYSQL_ROOT_PASSWORD=admin '
            }
      }
      steps {
        sh 'mysql --version'
        }
    }



  //   stage('Compile Go Application')
  /*   {
      agent {
            docker {
              image 'golang'
              //for cache error
              args ' -p 8082:8082 --network mynetwork1 --name mygolang  -e XDG_CACHE_HOME=\'/tmp/.cache\' -v /var/lib/jenkins/workspace/govwa:/go/src/govwa'
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
    } */
  }
}
