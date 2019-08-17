pipeline {
  agent none
  stages {
    stage('1. Checkout Go Code') {
      agent any
      steps {
        git(url: 'https://github.com/paroksh/govwa.git', branch: 'master')
      }
    }

/*    stage("1. SCA - Dependency Check OWASP")
    {

       agent {
             docker {
                 image 'owasp/dependency-check'
                 args ' --rm -u 0 --entrypoint= "/usr/share/dependency-check/bin/dependency-check.sh" -v /var/lib/jenkins/workspace/govwa:/src -v /var/lib/jenkins/OWASP-Dependency-Check/data:/usr/share/dependency-check/data -v /var/lib/jenkins/OWASP-Dependency-Check/reports:/report  '

                   }
        }

       steps{
         echo 'Running ODC'
         sh 'owasp/dependency-check --scan /src  --format "ALL" --project "My OWASP Dependency Check Project" --out /report '
       }
          }

  */

/*  stage("1. SCA - Dependency Check using DEPSCHECK") {
      agent {
            docker {
                image 'golang:latest'
                args ' -u 0 -v /var/lib/jenkins/workspace/govwa:/go/src/govwa'
                    }
              }

    steps{
        echo 'downloadind performing dependency check'
        sh 'go get github.com/divan/depscheck'
        sh 'cd /go/src/'
        sh 'go get github.com/go-sql-driver/mysql'
        sh 'go get github.com/gorilla/sessions'
        sh 'go get github.com/julienschmidt/httprouter'
        //sh 'cd /go/src/govwa/'
        sh 'depscheck -v .'

           }
         }
*/

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
        echo ' Importing dependencies'
        script {

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
          try
          {
            sh 'gosec -include=G101,G203,G401 -fmt=json -out=results.json ./...'
            echo 'printing results'
          }
          catch (ex)
          {
            print "Error cause: ${ex}"

          }
          finally{
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
  stage ('3. Running Tests')
  {
  parallel
  {
   stage('4. Compile Go Application on Docker')

    {
      agent {
            docker {
              image 'golang'
              //for cache error
              args ' --network=host -d=true -e XDG_CACHE_HOME=\'/tmp/.cache\' -v /var/lib/jenkins/workspace/govwa:/go/src/govwa'
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


    stage('5. Running ZAP')
     {
       agent {
             docker {
               image 'owasp/zap2docker-stable:latest'
               //for cache error
               args ' --network=host -u 0 -v /var/lib/jenkins/workspace/govwa:/zap/wrk:rw '
                   //--network mynetwork1 --name mygolang
                   }
             }
       steps
       {
         echo 'zap running'
         sh 'zap-baseline.py -t http://localhost:8082 -r baseline-scan-report.html -g gen.conf '

       }
     }

}
}
  }
}
