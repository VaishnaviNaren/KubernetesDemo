pipeline {
    agent any
    stages {
        stage('Build') { 
            steps {
                cd microservice-kubernetes-demo
		sh 'mvn -B -DskipTests clean package' 
            }
        }
    }
}
