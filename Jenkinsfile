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
        stage('Deploy to Kubernetes Cluster') {
            steps {
                withKubeConfig([credentialsId: 'zeeders']){
                    sh 'kubectl get svc'
                    sh 'helm list'
                    sh "helm lint ./${HELM_CHART_DIRECTORY}"
                    sh "helm upgrade --install --wait --timeout 60s --set image.tag=${DOCKER_TAG} ${HELM_APP_NAME} ./${HELM_CHART_DIRECTORY}"
                    sh "helm list | grep ${HELM_APP_NAME}"
                }
            }
        }
    }
}

def getDockerTag(){
    sh script: 'git rev-parse --short HEAD > .git/commit-id', returnStdout: true
    def tag  = readFile('.git/commit-id').trim()
    return tag
}
