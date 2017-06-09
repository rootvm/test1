#!groovy
pipeline {
agent { label 'master' }
    stages {
        stage('Build') {
            steps {
                DdockerBuildTagPush()
            }
        }
    }
}
