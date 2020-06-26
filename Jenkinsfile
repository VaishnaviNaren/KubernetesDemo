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
                                                file: 'microservice-kubernetes-demo/microservice-kubernetes-demo-catalog/target/microservice-kube
rnetes-demo-catalog-0.0.1-SNAPSHOT.jar',
                                                type: 'jar'
                                        ],
                                        [       artifactId: 'microservice-kubernetes-demo-order',
                                                classifier: '',
                                                file: 'microservice-kubernetes-demo/microservice-kubernetes-demo-order/target/microservice-kubern
etes-demo-order-0.0.1-SNAPSHOT.jar',
                                                type: 'jar'
                                        ],
                                        [       artifactId: 'microservice-kubernetes-demo-customer',
                                                classifier: '',
                                                file: 'microservice-kubernetes-demo/microservice-kubernetes-demo-customer/target/microservice-kub
ernetes-demo-customer-0.0.1-SNAPSHOT.jar',
                                                type: 'jar'
                                        ]
                                ],
                                        credentialsId: 'Nexus-credentials',
                                        groupId: 'com.ewolff',
                                        nexusUrl: 'ec2-18-222-145-169.us-east-2.compute.amazonaws.com:8081',
                                        nexusVersion: 'nexus3',
                                        protocol: 'http',
                                        repository: 'Kubedemo-Release',
                                        version: '0.0.1-SNAPSHOT'
                        }
                }
                stage ('Building Docker Image') {
                        steps {
                                withCredentials([usernamePassword(credentialsId: 'Docker-credentials', passwordVariable: 'DOCKER_PWD', usernameVar
iable: 'DOCKER_ACCOUNT')]) {
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
                                                cd microservice-kubernetes-demo
						./kubernetes-deploy.sh
						'''
                                        }
                                }
                        }
                }
        }
}

