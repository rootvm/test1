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
	post {
		success { build job: 'rootvm/test2/master', wait: false}
}
}
