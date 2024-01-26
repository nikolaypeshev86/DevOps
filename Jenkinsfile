pipeline {
    agent any

    environment {
        NODE_VERSION = '14'
        DOCKER_IMAGE_NAME = 'your-docker-image-name'
        NEXUS_REPO_URL = 'http://your-nexus-repo-url'
        NEXUS_REPO_CREDENTIALS = credentials('nexus-credentials-id')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    sh "curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -"
                    sh "apt-get install -y nodejs"
                    sh "npm install"
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    sh "npm test"
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
