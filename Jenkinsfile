pipeline {

    agent any

    parameters {
        string(
            name: 'IMAGE_TAG',
            defaultValue: 'latest',
            description: 'Docker image tag'
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

stage('Update Image Tag') {

    steps {

        sh """
            sed -i 's/^IMAGE_TAG=.*/IMAGE_TAG=${params.IMAGE_TAG}/' .env
        """

        sh 'cat .env'
    }

}

        }

}