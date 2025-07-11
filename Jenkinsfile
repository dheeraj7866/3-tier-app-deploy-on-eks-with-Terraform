pipeline {
  agent any

  environment {
    AWS_REGION = 'us-west-1'
    ACCOUNT_ID = '248729599698'
    ECR_REPO = ''
    CLUSTER_NAME = ''
  }

  parameters {
    string(name: 'BRANCH_NAME', defaultValue: 'main', description: 'Git branch to build from')
    choice(name: 'ENVIRONMENT', choices: ['dev', 'uat', 'prod'], description: 'Select the environment to deploy')
  }

  stages {

    stage('Init Config') {
      steps {
        script {
          if (params.ENVIRONMENT == 'dev') {
            ECR_REPO = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/equity-realestate-dev"
            CLUSTER_NAME = "equity-dev-cluster"
          } else if (params.ENVIRONMENT == 'uat') {
            ECR_REPO = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/equity-realestate-uat"
            CLUSTER_NAME = "equity-uat-cluster"
          } else if (params.ENVIRONMENT == 'prod'){
            ECR_REPO = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/equity-realestate-prod"
            CLUSTER_NAME = "equity-prod-cluster"
          }

          echo "✅ ECR: ${ECR_REPO}"
          echo "✅ Cluster: ${CLUSTER_NAME}"
        }
      }
    }

    stage('Checkout') {
      steps {
        git branch: "${params.BRANCH_NAME}",
            credentialsId: 'gitlab-ssh-key',
            url: 'git@gitlab.com:reactcrowdfunding-group/equity-realestate.git'

      }
    }

    stage('Build Frontend and Backend in Parallel') {
      parallel {
        stage('Build Frontend') {
          when {
            expression { fileExists('equity-realestate-script-front/Dockerfile') }
          }
          steps {
            dir('equity-realestate-script-front') {
              script {
                def tag = "frontend-${params.ENVIRONMENT}-${env.BUILD_NUMBER}"
                def image = "${ECR_REPO}:${tag}"
                sh """
                  docker build --build-arg ENV_FILE=envs/.env.${params.ENVIRONMENT} -t ${image} .
                  aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}
                  docker push ${image}
                """
                env.FRONTEND_IMAGE = image
              }
            }
          }
        }

        stage('Build Backend') {
          when {
            expression { fileExists('equity-realestate-login-signup-api/Dockerfile') }
          }
          steps {
            dir('equity-realestate-login-signup-api') {
              script {
                def tag = "backend-${params.ENVIRONMENT}-${env.BUILD_NUMBER}"
                def image = "${ECR_REPO}:${tag}"
                sh """
                  docker build -t ${image} .
                  aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}
                  docker push ${image}
                """
                env.BACKEND_IMAGE = image
              }
            }
          }
        }
      }
    }


    stage('Set Kubeconfig') {
      steps {
        sh """
          aws eks update-kubeconfig \
            --region ${AWS_REGION} \
            --name ${CLUSTER_NAME}
        """
      }
    }

    stage('Deploy to EKS') {
        steps {
            script {
                def envPath = "k8s/${params.ENVIRONMENT}"
                
                // Replace image in frontend deployment YAML
                sh """
                    sed -i 's|image:.*|image: ${FRONTEND_IMAGE}|' ${envPath}/frontend-deployment.yaml
                    kubectl apply -f ${envPath}/frontend-deployment.yaml
                """

                // Replace image in backend deployment YAML
                sh """
                    sed -i 's|image:.*|image: ${BACKEND_IMAGE}|' ${envPath}/backend-deployment.yaml
                    kubectl apply -f ${envPath}/backend-deployment.yaml
                """
            }
        }
    }


  }

  post {
    success {
      echo "✅ Deployed to ${params.ENVIRONMENT} successfully!"
    }
    failure {
      echo "❌ Deployment failed for ${params.ENVIRONMENT}"
    }
    always {
      echo "🧹 Cleaning up..."

      script {
        // Remove Docker images if they exist
        sh '''
          docker rmi -f ${FRONTEND_IMAGE} || true
          docker rmi -f ${BACKEND_IMAGE} || true
        '''
      }
    }
  }
}
