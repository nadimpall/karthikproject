
currentBuild.displayName = "Project-"+currentBuild.number

    agent any
    
 parameters {
    gitParameter branch: '', branchFilter: 'origin.*/(.*)', defaultValue: '', name: 'FROM_BRANCH', quickFilterEnabled: false, selectedValue: 'NONE', sortMode: 'NONE', tagFilter: '*', type: 'PT_BRANCH'
}

    options {
    buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '2', numToKeepStr: '4')
    }

    stages {
        stage('Git Clone') {
            steps {
                git 'https://github.com/nadimpall/karthikproject.git'
                echo "Running ${env.BUILD_ID}"
            }
        }
    
        stage("Build"){
           steps{
                echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
                
                bat "mvn clean install"
                          
                echo "Successfully Build with BuildNumber >>>> ${env.BUILD_ID}"
           }    
       } 
        
        stage ('uploading to jfrog repo') {
            steps {
               withCredentials([usernamePassword(credentialsId: 'Jfrog', passwordVariable: 'Password', usernameVariable: 'UserName')]){
               echo "*******************************************************************"
               echo "Uploading latest build number - ${env.BUILD_ID} to the Artifactiory"
               echo "*******************************************************************"
               echo "                                                                "
               echo "                           "
               bat "curl -X PUT -u %UserName%:%Password% -T C:/Windows/System32/config/systemprofile/AppData/Local/Jenkins/.jenkins/workspace/urbanCodeDeploy-jenkinsfile/target/spring-mvc-example.war http://localhost:8081/artifactory/libs-snapshot-local/spring-mvc-example.war.${env.BUILD_ID}"
               
            }
        }
    }
        stage ('Downloading artifactory') {
            steps {
               withCredentials([usernamePassword(credentialsId: 'Jfrog', passwordVariable: 'Password', usernameVariable: 'UserName')]){
               echo "****************************************************************"
               echo "Downloading latest build number - ${env.BUILD_ID} to the webapps"
               echo "****************************************************************"
               echo "                                                                "
               echo "                                                                "
               bat "curl -u %UserName%:%Password% -XGET http://localhost:8081/artifactory/libs-snapshot-local/spring-mvc-example.war.${env.BUILD_ID} --output E:/apache-tomcat-8.5.66/webapps/spring-mvc-example.war"
                //bat "curl -u admin:password -s -O http://localhost:8081/artifactory/libs-snapshot-local/spring-mvc-example.war"               
            }
        }
        
       } 
        
    }
}

/*
post {
    always {
       mail bcc: '', body: '${details}', cc: '', from: 'nkarthik206@gmail.com', replyTo: '', subject: 'Build', to: 'nkarthik206@gmail.com'
    }
}
}
*/
