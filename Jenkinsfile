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
      //      sh 'docker network create -d bridge mynetwork1'
            print('Source Code Review2 Running')
            }
    }
  /*  stage('Database setup')
    {
      agent {
            docker {
              image 'mysql'
              args '-d -p 3306:3306 --network mynetwork1 --name ammysql6 -e MYSQL_ROOT_PASSWORD=admin '
                    }
      }
      steps {
        sh ' mysql --version '
        sh ' mysql -h 127.0.0.1 -p 3306 -u user -p pass123 firstdb '
        sh ' CREATE TABLE Persons (PersonID int, LastName varchar(255), FirstName varchar(255), Address varchar(255), City varchar(255) ); '
        }
    }

    */

   stage('Compile Go Application')
    {
      agent {
            docker {
              image 'golang'
              //for cache error
              args ' -p 8082:8082 -p 3306:3306  -e XDG_CACHE_HOME=\'/tmp/.cache\' -v /var/lib/jenkins/workspace/govwa:/go/src/govwa'
                  //--network mynetwork1 --name mygolang
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
