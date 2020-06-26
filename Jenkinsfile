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
				nexusArtifactUploader artifacts: [
					[
						artifactId: 'microservice-kubernetes-demo-catalog', 
						classifier: '', 
						file: 'microservice-kubernetes-demo/microservice-kubernetes-demo-catalog/target/microservice-kubernetes-demo-catalog-0.0.1-SNAPSHOT.jar', 
						type: 'jar'
					], 
					[	artifactId: 'microservice-kubernetes-demo-order', 
						classifier: '', 
						file: 'microservice-kubernetes-demo/microservice-kubernetes-demo-order/target/microservice-kubernetes-demo-order-0.0.1-SNAPSHOT.jar', 
						type: 'jar'
					], 
					[	artifactId: 'microservice-kubernetes-demo-customer', 
						classifier: '', 
						file: 'microservice-kubernetes-demo/microservice-kubernetes-demo-customer/target/microservice-kubernetes-demo-customer-0.0.1-SNAPSHOT.jar', 
						type: 'jar'
					]
				], 
					credentialsId: 'Nexus-Credentials', 
					groupId: 'org.springframework.boot', 
					nexusUrl: 'ec2-18-222-145-169.us-east-2.compute.amazonaws.com:8081', 
					nexusVersion: 'nexus3', 
					protocol: 'http', 
					repository: 'Kubedemo-Release', 
					version: '2.3.0.RELEASE'
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
