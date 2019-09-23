pipeline {
    agent any 

    // If anything fails, the whole Pipeline stops.
    stages {
        
        stage('Checkout'){
            agent { 
                docker { 
                    image 'golang'
                    args ' -u 0 -v ${WORKSPACE}:/go/src/govwa:rw'
                    
                } 
            }
            steps {
                git(url: 'https://github.com/snehakokil/govwa.git', branch: 'master')
            
                stash name:'dockerfile', includes: '**/Dockerfile'
            }
        }
            // Use golang.
        stage('Build') {
            agent { 
                docker { 
                    image 'golang'
                    args ' -u 0 -v ${WORKSPACE}:/go/src/govwa:rw'
                    
                } 
            }
            steps {
                
                sh 'cd /go/src'
                sh 'go get github.com/go-sql-driver/mysql'
                sh 'go get github.com/gorilla/sessions'
                sh 'go get github.com/julienschmidt/httprouter'
                

                // Build the app.
                sh 'go build' 
                stash name:'CompiledSource', includes:'**/**'
            }            
        }
        
        
        stage('Build-time SCA') {

            agent { 
                docker { 
                    image 'golang'
                    args ' -u 0 -v ${WORKSPACE}:/go/src/govwa:rw'
                    
                } 
            }
            steps {
                sh 'go get github.com/divan/depscheck'
                
                sh 'cd /go/src'
                sh 'go get github.com/go-sql-driver/mysql'
                sh 'go get github.com/gorilla/sessions'
                sh 'go get github.com/julienschmidt/httprouter'
                sh 'depscheck -v . | tee depcheck.txt'
                archiveArtifacts 'depcheck.txt'
            }            
        }
        
        stage('Build-time SAST') {

            agent { 
                docker { 
                    image 'golang'
                    args ' -u 0 -v ${WORKSPACE}:/go/src/govwa:rw'
                    
                } 
            }
            steps {
       
                sh 'cd /go/src'
                sh 'go get github.com/go-sql-driver/mysql'
                sh 'go get github.com/gorilla/sessions'
                sh 'go get github.com/julienschmidt/httprouter'
                
                echo 'cloning Gosec'
                sh 'curl -sfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh -s -- -b $GOPATH/bin'
                echo 'listing current folder contents for verification'
                sh 'cd /go/src/govwa'
                echo 'SAST running with GOSEC'
                script {
                    def status = sh returnStatus: true, script:'gosec -fmt=json -out=results.json ./...'
                    echo 'printing results'
                    
                    archiveArtifacts '*.json'
                    print "SAST scanning complete"
                    
                    if(status != 0) {
                        input message: 'SAST results violate severity threshold. Do you want to proceed?', submitter: 'ciuser'  
                    }
                    
                } //end script
            }            
        }

        
        stage('Test-Time Checks'){
            parallel {
                stage('Deploy') {
                    agent {
                        docker {
                            image 'golang'
                            //for cache error
                           
                            args '--name GoContainer --network=host -d -e XDG_CACHE_HOME=$GO_CACHE -v ${WORKSPACE}:/go/src/govwa'
                        }
                    
                    }
                    
                    steps {
    
                       sh 'go env'
                        sh 'cd /go/src/'
                        sh 'go get github.com/go-sql-driver/mysql'
                        sh 'go get github.com/gorilla/sessions'
                        sh 'go get github.com/julienschmidt/httprouter'
                        sh 'go run app.go &'
                        
                        input message: 'Please review DAST results before proceeding.', submitter: 'ciuser'
                    }
                    
                    
                }
                
                stage('DAST'){
                    agent {
                        docker {
                          image 'owasp/zap2docker-stable'
                          args ' --network=host -u 0 -v /var/lib/jenkins/workspace/govwa:/zap/wrk:rw '
                           
                          }
                        }
                    steps {
                        script{
                            try {
                                  
                                  //sh 'zap.sh -daemon -port 2375 -host 127.0.0.1 -config api.disablekey=true -config scanner.attackOnStart=true -config view.mode=attack -config connection.dnsTtlSuccessfulQueries=-1 -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true &'
                                  sh 'zap-cli -p 2375 status -t 120 && zap-cli -p 2375 open-url http://localhost:8082/'
                                  sh 'zap-cli -p 2375 spider http://localhost:8082/'
                                  sh 'zap-cli -p 2375 active-scan -r http://localhost:8082/'
                                  sh 'zap-cli -p 2375 report --output-format html --output owasp-zap.html'
                                  //sh 'zap-cli -p 8090 -v quick-scan -sc -o \'-config api.disablekey=true\' http://localhost:8082/ | tee zap.txt'
                                  
                                  echo 'zap complete'
                                  archiveArtifacts 'owasp-zap.html'
                                  
                            }
                            catch (err) {
                                echo "Caught: ${err}"
                            }
                        } //end script
                    } //end steps
                }
            }
        }
    }
}
