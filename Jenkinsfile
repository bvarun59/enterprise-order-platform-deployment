pipeline {

    agent any

    parameters {
        string(
        name: 'IMAGE_TAG',
        defaultValue: '',
        description: 'Git Commit SHA (Example: 7b46ff1)'
        )
    }

    environment {
        IMAGE_NAME = "varundocker3/orderservice"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate Parameters') {

            steps {

                script {

                    if (!params.IMAGE_TAG?.trim()) {
                    error("IMAGE_TAG parameter is required")
                }

            }

        }

    }


        stage('Display Deployment Info') {
            steps {
                echo "Deploying ${IMAGE_NAME}:${params.IMAGE_TAG}"
            }
        }

        stage('Docker Login') {

            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'Dockerhub-Cred',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {

                    sh '''
                        echo "$DOCKER_PASS" | docker login \
                        -u "$DOCKER_USER" \
                        --password-stdin
                    '''

                }

            }

        }
        stage('Pull Docker Image') {

            steps {

                sh """
                docker pull ${IMAGE_NAME}:${params.IMAGE_TAG}
                """

            }

        }

stage('Verify Cosign Signature') {

    steps {

        withCredentials([
            file(
                credentialsId: 'cosign-public-key',
                variable: 'COSIGN_PUBLIC_KEY'
            )
        ]) {

            sh """
            cosign verify \
              --key \$COSIGN_PUBLIC_KEY \
              ${IMAGE_NAME}:${params.IMAGE_TAG}
            """

        }

    }

}

stage('Generate Environment File') {

    steps {

        writeFile file: '.env', text: """
IMAGE_TAG=${params.IMAGE_TAG}
"""

        sh 'cat .env'

    }

}

        }

}