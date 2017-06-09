#!groovy
@Library('DdockerBuildTagPush') _
pipeline {
agent { label 'master' }
    stages {
        stage('Build') {
            steps {
		sh 'docker info'
                DdockerBuildTagPush()
            }
        }
    }
}
