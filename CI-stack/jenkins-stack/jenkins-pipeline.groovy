pipeline {
    agent {
        label "maven"
    }

    environment {
        // Define the SSH credentials ID
        SSH_CREDENTIALS_ID = 'jenkins'
    }

    stages { 
        stage('maven validate') {
            steps {
                sh "mvn validate -f /var/jenkins-home/workspace/git-pipeline-job/addressbook-tomcat8/pom.xml"
            }
        }
        stage('maven compile') {
            steps {
                sh "mvn compile -f /var/jenkins-home/workspace/git-pipeline-job/addressbook-tomcat8/pom.xml"
            }
        }
        stage('maven test') {
            steps {
                sh "mvn test -f /var/jenkins-home/workspace/git-pipeline-job/addressbook-tomcat8/pom.xml"
            }
        }
        stage('maven package') {
            steps {
                sh "mvn package -f /var/jenkins-home/workspace/git-pipeline-job/addressbook-tomcat8/pom.xml"
            }
        }
        stage('maven verify') {
            steps {
                sh "mvn verify -f /var/jenkins-home/workspace/git-pipeline-job/addressbook-tomcat8/pom.xml"
            }
        }
        stage('maven install') {
            steps {
                sh "mvn install -f /var/jenkins-home/workspace/git-pipeline-job/addressbook-tomcat8/pom.xml"
            }
        }
    }
}
