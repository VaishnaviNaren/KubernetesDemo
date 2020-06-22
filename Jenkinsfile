pipeline {
    agent any
    stages {
        stage('Build') { 
            steps {
		cd ~/workspace/Test-maven/microservice-kubernetes-demo
		sh 'mvn -B -DskipTests clean package' 
            }
        }
    }
}
