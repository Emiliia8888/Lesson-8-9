pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:latest
    command:
    - /busybox/cat
    tty: true
  - name: helm
    image: alpine/helm:latest
    command:
    - cat
    tty: true
'''
        }
    }
    environment {
        AWS_REGION = "us-east-1"
        ECR_REPO = "123456789012.dkr.ecr.us-east-1.amazonaws.com/django-app"
    }
    stages {
        stage('Build & Push') {
            steps {
                container('kaniko') {
                    sh "/kaniko/executor --context=dir://. --dockerfile=Dockerfile --destination=${ECR_REPO}:${BUILD_NUMBER}"
                }
            }
        }
        stage('Update Helm Chart') {
            steps {
                container('helm') {
                    // Оновлюємо тег у values.yaml перед тим, як Argo CD підхопить зміни
                    sh "sed -i 's/tag:.*/tag: ${BUILD_NUMBER}/g' charts/django-app/values.yaml"
                    // Тут має бути git commit та git push, щоб Argo CD побачив зміни в Git
                }
            }
        }
    }
}