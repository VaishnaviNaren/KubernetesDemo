pipeline {
	agent any
	environment{
		VERSION_TAG = getVersionTag()
    }
	stages {
		stage('Code Build') {
			steps {
				sh script:'''
				#!/bin/bash
				cd ~/workspace/Test-maven/microservice-kubernetes-demo
				./mvnw -B -DskipTests clean package
				'''
			}
		}
		stage ('Building Docker Image') {
			steps {
				withCredentials([usernamePassword(credentialsId: 'vaishnavinaren219', passwordVariable: 'DOCKER_PWD', usernameVariable: 'DOCKER_ACCOUNT')]) {
					sh "docker login -u $DOCKER_ACCOUNT -p $DOCKER_PWD"
					sh "./microservice-kubernetes-demo/docker-build.sh"
				}
			}
		}
	}
}	

def getVersionTag(){
	def tag = sh script: 'git rev-parse HEAD', returnStdout: true
}
