pipeline {
  agent none
  stages {
/*    stage('1. Checkout Go Code')
    {
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



 stage("2. SCA - Dependency Check using DEPSCHECK")
  {
      agent {
            docker {
                    image 'golang:latest'
                    args ' -u 0 -v /var/lib/jenkins/workspace/govwa:/go/src/govwa'
                   }
            }
      steps
      {
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

  stage('2. Running Source Code Review using GoSec on Docker')
  {
      agent {
            docker {
                    image 'golang:latest'
                    args ' -u 0 -v /var/lib/jenkins/workspace/govwa:/go/src/govwa:rw'
                   }
            }
      steps
      {
            sh 'pwd'
            sh 'cd /go/src/'
            echo 'Getting dependencies'
            sh 'go get github.com/go-sql-driver/mysql'
            sh 'go get github.com/gorilla/sessions'
            sh 'go get github.com/julienschmidt/httprouter'
            echo 'cloning Gosec'
            sh 'curl -sfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh -s -- -b $GOPATH/bin'
            echo 'listing current folder contents for verification'
            sh 'cd /go/src/govwa'
            echo 'SAST running with GOSEC'
            script
            {
            try
            {
              sh 'gosec -fmt=json -out=results.json ./...'
              echo 'printing results'
            }
            catch(ex)
            {
            print "Error cause: ${ex}"
            }
            finally
            { print "SAST scanning complete" }

        } //end script
      } //end steps
    } //end stage

    */

    stage ('3. Security Test Environment')
    {
      parallel
      {
        stage('4. Compile and Run GovWA Application on Docker')
        {
          agent {
                 docker
                 {
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
                docker
                  {
                  image 'owasp/zap2docker-stable'
                  //for cache error
                  args ' --network=host -u 0 -v /var/lib/jenkins/workspace/govwa:/zap/wrk:rw '
                   //--network mynetwork1 --name mygolang
                  }
                }
          steps
          {
            script{
            try{
              sh 'sleep 1m'
          //  sh 'zap-baseline.py -t http://localhost:8082 -r  baseline-scan-report.html '
          //  sh 'zap-cli open-url http://localhost:8082 '
              sh 'zap-cli -p 8090 -v quick-scan -sc -l Informational -o \'-config api.disablekey=true\' http://localhost:8082 '
              echo 'zap complete'
              }
          catch (err)
          {
            echo "Caught: ${err}"
          }
          } //end script
        } //end steps
        } //end zap stage
      } // end parallel
    } //end  test stage
  } //end stages
} //end pipeline
