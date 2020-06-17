pipeline {
    agent any
    environment {
        registry = "daddychuks/node-kubernetes"
        registryCredential = 'dockerhub'
        DOCKER_TAG = getDockerTag()
        dockerImage = ''
        HELM_CHART_DIRECTORY = 'deployment-config/nodeapp'
        HELM_APP_NAME = 'node-app'
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
                    dockerImage = docker.build registry + ":$DOCKER_TAG"
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
        stage('Apply Kubernetes files') {
            withKubeConfig([credentialsId: 'zeeders']){
                sh 'kubectl get nodes'
            }
        }
        // stage('Deploy to Kubernetes') {
        //     steps{
        //         sh 'helm list'
        //         sh "helm lint ./${HELM_CHART_DIRECTORY}"
        //         sh "helm upgrade --wait --timeout 60 --set image.tag=${BUILD_NUMBER} ${HELM_APP_NAME} ./${HELM_CHART_DIRECTORY}"
        //         sh "helm list | grep ${HELM_APP_NAME}"
        //     }
        // }
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
    sh script: 'git rev-parse --short HEAD > .git/commit-id', returnStdout: true
    def tag  = readFile('.git/commit-id').trim()
    return tag
}
