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
		stage ('Uploading the artifacts to Nexus') {
			steps{
				nexusArtifactUploader artifactId: 'microservice-kubernetes-demo-catalog', 
				classifier: '', 
				credentialsId: 'Nexus-credentials', 
				file: 'microservice-kubernetes-demo/microservice-kubernetes-demo-catalog/target/microservice-kube rnetes-demo-catalog-0.0.1-SNAPSHOT.jar', 
				groupId: 'com.ewolff', 
				nexusPassword: '', nexusUrl: 'ec2-18-222-145-169.us-east-2.compute.amazonaws.com:8081', 
				nexusUser: '', 
				packaging: 'jar', 
				protocol: 'http', 
				repository: 'Kubedemo-Release', 
				type: '', 
				version: '0.0.1-SNAPSHOT'
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
					withCredentials([string(credentialsId: 'Kube_IP', variable: 'KubeIP')]) {
						sh script:'''
						ssh -o StrictHostKeyChecking=no ec2-user@$KubeIP "kubectl apply -f ./config/microservices.yaml"
						'''
					}
				}
			}
		}
	}
}
