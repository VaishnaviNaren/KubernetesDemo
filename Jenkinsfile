pipeline {
	agent any

	stages {
		stage('Code Build') {
			steps {
				sh script:'''
				#!/bin/bash
				cd microservice-kubernetes-demo
				./mvnw -B -DskipTests clean package
				'''
			}
		}
		stage ('Building Docker Image') {
			steps {
				withCredentials([usernamePassword(credentialsId: 'DockerCredentials', passwordVariable: 'DOCKER_PWD', usernameVariable: 'DOCKER_ACCOUNT')]) {
					sh script:'''
					#!/bin/bash
					docker login -u $DOCKER_ACCOUNT -p $DOCKER_PWD
					cd microservice-kubernetes-demo
					./docker-build.sh
					'''
				}
			}
		}
		stage ("Deploy the Microservices to Kubernetes") {
			steps {
				sshagent(['SSHToKube']) {
					sh script:'''
					ssh -o StrictHostKeyChecking=no ec2-user@172.31.35.86 ./config/kubernetes-deploy.sh
					'''
				}
			}
		}
	}
}
