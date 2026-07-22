pipeline {

    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins

  containers:

    - name: kaniko
      image: gcr.io/kaniko-project/executor:latest
      command:
        - /busybox/cat
      tty: true
      volumeMounts:
        - name: docker-config
          mountPath: /kaniko/.docker

    - name: git
      image: alpine/git:latest
      command:
        - cat
      tty: true

    - name: aws
      image: amazon/aws-cli:latest
      command:
        - cat
      tty: true

  volumes:
    - name: docker-config
      emptyDir: {}
'''
        }
    }

    environment {

        AWS_REGION = "eu-central-1"

        ECR_REPO = "034255117140.dkr.ecr.eu-central-1.amazonaws.com/django-app"

        IMAGE_TAG = "${BUILD_NUMBER}"

        APP_REPO = "Lesson-8-9"

        HELM_REPO = "Lesson-8-9"
    }

    stages {

        stage('Checkout Application') {

            steps {

                container('git') {

                    withCredentials([
                        usernamePassword(
                            credentialsId: 'github-creds',
                            usernameVariable: 'GIT_USER',
                            passwordVariable: 'GIT_TOKEN'
                        )
                    ]) {

                        sh '''
                        rm -rf *

                        git clone https://${GIT_USER}:${GIT_TOKEN}@github.com/Emiliia8888/Lesson-8-9.git .

                        git checkout main

                        git status
                        '''
                    }
                }
            }
        }

        stage('Validate Project') {

            steps {

                container('git') {

                    sh '''
                    echo "Checking project..."

                    ls -la

                    test -f Dockerfile

                    echo "Dockerfile found."
                    '''
                }
            }
        }

        stage('Build and Push Image to Amazon ECR') {

            steps {

                container('kaniko') {

                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds']
                    ]) {

                        sh '''
                        mkdir -p /kaniko/.docker

                        cat > /kaniko/.docker/config.json <<EOF
{
  "credsStore":"ecr-login"
}
EOF

                        /kaniko/executor \
                          --context=dir://. \
                          --dockerfile=Dockerfile \
                          --destination=${ECR_REPO}:${IMAGE_TAG} \
                          --cache=true
                        '''
                    }
                }
            }
        }

        stage('Update Helm Chart') {

            steps {

                container('git') {

                    withCredentials([
                        usernamePassword(
                            credentialsId: 'github-creds',
                            usernameVariable: 'GIT_USER',
                            passwordVariable: 'GIT_TOKEN'
                        )
                    ]) {

                        sh '''
                        rm -rf Lesson-8-9

                        git clone https://${GIT_USER}:${GIT_TOKEN}@github.com/Emiliia8888/Lesson-8-9.git

                        cd Lesson-8-9

                        sed -i.bak "s/tag:.*/tag: ${IMAGE_TAG}/" charts/django-app/values.yaml

                        rm -f charts/django-app/values.yaml.bak

                        git config user.name "Jenkins"

                        git config user.email "jenkins@example.com"

                        git add charts/django-app/values.yaml

                        git commit -m "Update image tag to ${IMAGE_TAG}" || echo "Nothing to commit"

                        git push origin main
                        '''
                    }
                }
            }
        }
    }

    post {

        success {

            echo "======================================"
            echo "Pipeline completed successfully."
            echo "Docker image pushed to Amazon ECR."
            echo "Helm chart updated."
            echo "Argo CD will automatically sync changes."
            echo "======================================"

        }

        failure {

            echo "======================================"
            echo "Pipeline failed."
            echo "======================================"

        }

        always {

            cleanWs()

        }
    }
}