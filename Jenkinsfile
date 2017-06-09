#!groovy

pipeline {

    stages {
        stage('Build') {
            steps {
		sh 'docker info'
                DdockerBuildTagPush()
            }
        }
    }
}
