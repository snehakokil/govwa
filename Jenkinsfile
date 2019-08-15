pipeline {
  agent none
  stages {
    stage('1. Checkout Go Code') {
      agent any
      steps {
        git(url: 'https://github.com/paroksh/govwa.git', branch: 'master')
      }
    }

    stage("3. SCA - Dependency Check") {
      agent none
      steps{
        echo 'performing dependency check'
        dependencyCheck

           }
         }

    stage('2. Running Source Code Review using GoSec on Docker')
    {
      agent {
            docker {
              image 'golang:latest'
              args ' -u 0 -v /var/lib/jenkins/workspace/govwa:/go/src/govwa'
                  }
            }
      steps{
      //      sh 'docker network create -d bridge mynetwork1'
          script{
            echo ' Importing dependencies'
            sh 'pwd'
            sh 'cd /go/src/'
            sh 'go get github.com/go-sql-driver/mysql'
            sh 'go get github.com/gorilla/sessions'
            sh 'go get github.com/julienschmidt/httprouter'
            echo 'Source Code Review Running in GoSec'
            echo 'cloning Gosec'
            sh 'curl -sfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh -s -- -b $GOPATH/bin'
            echo 'listing current folder contents for verification'
            sh 'cd /go/src/govwa'
            sh 'ls -l'
            echo 'scanning gosec'
            try{
            sh 'gosec -fmt=json -out=results.json ./...'
             }
            catch(ex) {
            echo 'go scan failed'
            echo 'printing results'
            sh 'cat results.json'
                   }
            finally
            {
            archiveArtifacts '*.json'
             }

           }
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

   stage('4. Compile Go Application on Docker')
    {
      agent {
            docker {
              image 'golang'
              //for cache error
              args ' --network=host -e XDG_CACHE_HOME=\'/tmp/.cache\' -v /var/lib/jenkins/workspace/govwa:/go/src/govwa'
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
