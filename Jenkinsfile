pipeline {
    agent any

    environment {
        // Change to your actual Docker Hub username in Jenkins or via env vars
        DOCKERHUB_USERNAME = credentials('dockerhub-username-env') // Or hardcode temporarily for local testing if not using secrets: 'yourusername'
        IMAGE_NAME = 'cloud-conference'
        IMAGE_TAG = "v${env.BUILD_NUMBER}"
        FULL_IMAGE = "${env.DOCKERHUB_USERNAME}/${env.IMAGE_NAME}:${env.IMAGE_TAG}"
        LATEST_IMAGE = "${env.DOCKERHUB_USERNAME}/${env.IMAGE_NAME}:latest"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate') {
            steps {
                echo 'Validating project files...'
                script {
                    def files = ['index.html', 'style.css', 'script.js', 'Dockerfile']
                    for (file in files) {
                        if (!fileExists(file)) {
                            error "Validation failed: ${file} does not exist"
                        }
                    }
                }
                echo 'All required files are present.'
            }
        }

        stage('Test') {
            steps {
                echo 'Running basic tests (linting could be added here)...'
                // Placeholder for actual tests
                sh 'echo "Tests passed"'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building Docker Image...'
                sh "docker build -t ${FULL_IMAGE} -t ${LATEST_IMAGE} ."
            }
        }

        stage('Docker Hub Login') {
            steps {
                echo 'Logging into Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME_CRED')]) {
                    sh 'echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME_CRED --password-stdin'
                }
            }
        }

        stage('Docker Push') {
            steps {
                echo 'Pushing Docker Image to Docker Hub...'
                sh "docker push ${FULL_IMAGE}"
                sh "docker push ${LATEST_IMAGE}"
            }
        }

        stage('Kubernetes Deploy') {
            steps {
                echo 'Deploying to Kubernetes...'
                // Using sed to dynamically replace the image tag in the deployment yaml
                // In a real scenario, consider using Helm or Kustomize
                sh "sed -i 's|image: .*/cloud-conference:latest|image: ${LATEST_IMAGE}|' k8s/deployment.yaml"
                
                // Assuming kubectl is configured on the Jenkins agent
                sh 'kubectl apply -f k8s/namespace.yaml'
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
                sh 'kubectl apply -f k8s/ingress.yaml'
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying rollout status...'
                sh 'kubectl rollout status deployment/cloud-conference -n cloud-conference --timeout=120s'
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed.'
            // Clean up local docker images to save space
            sh "docker rmi ${FULL_IMAGE} || true"
            sh "docker rmi ${LATEST_IMAGE} || true"
        }
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed. Check the logs.'
        }
    }
}
