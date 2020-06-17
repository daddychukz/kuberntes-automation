pipeline {
    agent any
    environment {
        registry = "daddychuks/node-kubernetes"
        registryCredential = 'dockerhub'
        DOCKER_TAG = getDockerTag()
        dockerImage = ''
    }
    stages {
        stage("Checkout code") {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image'){
            steps{
                script {
                    dockerImage = docker.build registry + DOCKER_TAG
                }
            }
        }
        stage('Deploy Image') {
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Remove Unused docker image') {
            steps{
                sh "docker rmi $registry:${DOCKER_TAG}"
            }
        }
        // stage('Docker Deploy Dev'){
        //     steps{
        //         sshagent(['tomcat-dev']) {
        //             withCredentials([string(credentialsId: 'nexus-pwd', variable: 'nexusPwd')]) {
        //                 sh "ssh ec2-user@172.31.0.38 docker login -u admin -p ${nexusPwd} ${USERNAME}"
        //             }
		// 			// Remove existing container, if container name does not exists still proceed with the build
		// 			sh script: "ssh ec2-user@172.31.0.38 docker rm -f nodeapp",  returnStatus: true
                    
        //             sh "ssh ec2-user@172.31.0.38 docker run -d -p 8080:8080 --name nodeapp ${IMAGE_WITH_TAG}"
        //         }
        //     }
        // }
    }
}

def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
