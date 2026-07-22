pipeline {

    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: django-app-pipeline
spec:

  securityContext:
    fsGroup: 1000

  serviceAccountName: jenkins

  containers:

  - name: git
    image: alpine/git:latest
    command:
    - cat
    tty: true
    volumeMounts:
    - name: workspace-volume
      mountPath: /home/jenkins/agent

  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
    - name: workspace-volume
      mountPath: /home/jenkins/agent
    - name: docker-config
      mountPath: /kaniko/.docker

  - name: aws
    image: amazon/aws-cli:latest
    command:
    - cat
    tty: true
    volumeMounts:
    - name: workspace-volume
      mountPath: /home/jenkins/agent

  volumes:

  - name: workspace-volume
    emptyDir: {}

  - name: docker-config
    emptyDir: {}

"""
        }
    }


    environment {

        AWS_REGION = "eu-central-1"

        ECR_REPOSITORY =
        "034255117140.dkr.ecr.eu-central-1.amazonaws.com/django-app"

        IMAGE_TAG = "${BUILD_NUMBER}"

    }


    stages {


        stage('Checkout Application') {

            steps {

                container('git') {

                    sh '''
                    echo "Using Declarative SCM checkout"
                    ls -la
                    '''

                }

            }

        }


        stage('Validate Project') {

            steps {

                container('git') {

                    sh '''
                    echo "Checking project..."

                    test -f Dockerfile
                    echo "Dockerfile found."

                    test -f requirements.txt
                    echo "requirements.txt found."

                    test -f charts/django-app/values.yaml
                    echo "Helm values.yaml found."
                    '''

                }

            }

        }


        stage('Build Docker Image with Kaniko') {

            steps {

                container('kaniko') {

                    sh '''

                    echo "Building image..."

                    /kaniko/executor \
                    --dockerfile=Dockerfile \
                    --context=$WORKSPACE \
                    --destination=${ECR_REPOSITORY}:${IMAGE_TAG}

                    '''

                }

            }

        }


        stage('Update Helm Values') {

            steps {

                container('git') {

                    sh '''

                    echo "Updating image tag..."

                    sed -i "s/tag: .*/tag: ${IMAGE_TAG}/" charts/django-app/values.yaml

                    echo "Updated values.yaml:"

                    cat charts/django-app/values.yaml

                    '''

                }

            }

        }


    }


    post {


        always {

            container('git') {

                sh '''

                echo "Cleaning workspace permissions"

                chmod -R u+rwX,g+rwX,o+rwX $WORKSPACE || true

                '''

            }

        }


        success {

            echo "Pipeline completed successfully."

        }


        failure {

            echo "Pipeline failed."

        }

    }

}
