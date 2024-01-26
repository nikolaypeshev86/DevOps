pipeline {
    agent any
    tools {
        nodejs 'node'
    }
    environment {
        DOCKER_IMAGE_NAME = 'nodejs-app:1.0'
        NEXUS_REPO_URL = '172.20.4.14:9093'
        NEXUS_REPO_CREDENTIALS = credentials('nexus-credentials')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run Tests') {
            steps {
                script {
                   // sh "npm test"
                    sh "npm install"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE_NAME} ."
                }
            }
        }

        stage('Push to Nexus Repository') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: NEXUS_REPO_CREDENTIALS, usernameVariable: 'NEXUS_USERNAME', passwordVariable: 'NEXUS_PASSWORD')]) {
                        sh "docker login -u ${NEXUS_USERNAME} -p ${NEXUS_PASSWORD} ${NEXUS_REPO_URL}"
                        sh "docker tag ${DOCKER_IMAGE_NAME} ${NEXUS_REPO_URL}/${DOCKER_IMAGE_NAME}"
                        sh "docker push ${NEXUS_REPO_URL}/${DOCKER_IMAGE_NAME}"
                    }
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh "docker run -p 8080:3000 ${NEXUS_REPO_URL}/${DOCKER_IMAGE_NAME}"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
