pipeline {
  agent none
  stages {
    stage('1. Checkout Go Code') {
      agent any
      steps {
        git(url: 'https://github.com/paroksh/govwa.git', branch: 'master')
      }
    }

/*    stage("3. SCA - Dependency Check OWASP")
    {

      environment {
        OWASPDC_DIRECTORY= "${HOME}/OWASP-Dependency-Check"
        DATA_DIRECTORY= "${OWASPDC_DIRECTORY}/data"
        REPORT_DIRECTORY= "${OWASPDC_DIRECTORY}/reports"
      }

       agent {
             docker {
                 image 'owasp/dependency-check'
                 args ' -u 0 --entrypoint=\'\' -v /var/lib/jenkins/workspace/govwa:/src -v /var/lib/jenkins/OWASP-Dependency-Check/data:/usr/share/dependency-check/data -v /var/lib/jenkins/OWASP-Dependency-Check/reports:/report owasp/dependency-check --scan /src  --format "ALL" --project "My OWASP Dependency Check Project" --out /report '
                   }
        }

       steps{
         echo 'Running ODC'
       }
          }

    stage("2. SCA - Dependency Check using DEPSCHECK") {
      agent {
            docker {
                image 'golang:latest'
                args ' -u 0 -v /var/lib/jenkins/workspace/govwa:/go/src/govwa'
                    }
              }

        /*    dockerfile {
              filename 'GoAlpinewithgit'
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



    stage('3. Running Source Code Review using GoSec on Docker')
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

    stage('5. Running ZAP')
     {
       agent {
             docker {
               image 'owasp/zap2docker-weekly'
               //for cache error
               args ' -v /var/lib/jenkins/workspace/govwa:/zap/wrk/:rw -t owasp/zap2docker-weekly zap-api-scan.py -c baseline-scan.conf -t http://$(ifconfig en0 | grep "inet " | cut -d " " -f2):8082 -r baseline-scan-report.html'
                   //--network mynetwork1 --name mygolang
                   }
             }
       steps
       {
         echo 'zap running'

       }
     }



  }
}
