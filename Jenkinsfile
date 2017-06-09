#!groovy
@Library('rootvm') _
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
