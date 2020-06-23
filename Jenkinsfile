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
					sh script:'''
					#!/bin/bash
					docker login -u $DOCKER_ACCOUNT -p $DOCKER_PWD
					cd ~/workspace/Test-maven/microservice-kubernetes-demo
					./docker-build.sh
					'''
				}
			}
		}
		stage ("Deploy the Microservices to Kubernetes") {
			steps {
				sshagent(['kubectl-machine']) {
					sh script:'''
					cd ~/workspace/Test-maven/microservice-kubernetes-demo
					ssh -o StrictHostKeyChecking=no ec2-user@3.130.186.139 kubectl apply -f ./config/microservices.yaml
					'''
				}
			}
		}
	}
}

def getVersionTag(){
	def tag = sh script: 'git rev-parse HEAD', returnStdout: true
}
