pipeline {
    agent any
    stages {
        stage('Build') {
		steps {
                	sh script:'''
          		#!/bin/bash
          		cd ~/workspace/Test-maven/microservice-kubernetes-demo
          		mvn -B -DskipTests clean package
        		'''
            }	 
        }
    }
}
