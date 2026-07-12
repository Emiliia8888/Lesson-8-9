# Lesson 8–9: CI/CD для Django в Amazon EKS за допомогою Jenkins, Helm, Terraform та Argo CD

# Опис проєкту

Цей проєкт реалізує повний GitOps CI/CD-процес для Django-застосунку в Amazon EKS.

Інфраструктура створюється за допомогою Terraform, Jenkins та Argo CD встановлюються через Helm, а весь процес збірки й розгортання автоматизовано.

Після кожного коміту Jenkins автоматично:

* збирає Docker-образ Django-застосунку;
* публікує образ у Amazon ECR;
* оновлює тег образу в Helm chart окремого Git-репозиторію;
* виконує push змін у гілку `main`.

Після цього Argo CD автоматично виявляє зміни в Git-репозиторії та синхронізує застосунок із Kubernetes-кластером відповідно до принципів GitOps.

---

# Використані технології

* **Terraform** — створення AWS-інфраструктури.
* **Amazon EKS** — Kubernetes-кластер.
* **Amazon ECR** — сховище Docker-образів.
* **Amazon S3 + DynamoDB** — backend для Terraform state.
* **Helm** — встановлення Jenkins, Argo CD та керування Helm chart застосунку.
* **Jenkins** — автоматизація CI/CD.
* **Kubernetes Agent** — виконання Jenkins Pipeline у Kubernetes.
* **Kaniko** — збірка Docker-образів без Docker Daemon.
* **Git** — зберігання Helm chart та GitOps workflow.
* **Argo CD** — автоматичне розгортання застосунку після змін у Git.

---

# Структура проєкту

```text
Project/
│
├── main.tf
├── backend.tf
├── outputs.tf
│
├── modules/
│   ├── s3-backend/
│   ├── vpc/
│   ├── eks/
│   ├── ecr/
│   ├── jenkins/
│   └── argo_cd/
│
├── charts/
│   └── django-app/
│
└── Jenkinsfile
```

---

# Інфраструктура

Terraform автоматично створює:

* VPC
* Amazon EKS
* Amazon ECR
* S3 Backend
* DynamoDB Lock Table

Після створення EKS Terraform встановлює через Helm:

* Jenkins
* Argo CD

---

# Jenkins Pipeline

Pipeline реалізовано в `Jenkinsfile`.

Він виконує такі етапи:

1. Checkout вихідного коду.
2. Збірка Docker-образу за допомогою Kaniko.
3. Публікація образу в Amazon ECR.
4. Клонування репозиторію з Helm chart.
5. Оновлення тегу Docker-образу у `values.yaml`.
6. Commit та Push змін у гілку `main`.

---

# Kubernetes Agent

Jenkins використовує Kubernetes Agent.

Pipeline запускається всередині Pod, який містить два контейнери:

* **Kaniko** — збірка Docker-образу;
* **Git** — робота з Helm-репозиторієм.

Такий підхід не потребує встановлення Docker Engine на Jenkins Master.

---

# Helm

Helm використовується для:

* встановлення Jenkins;
* встановлення Argo CD;
* розгортання Django-застосунку.

Helm chart Django містить:

* Deployment;
* Service;
* ConfigMap;
* Secret;
* Horizontal Pod Autoscaler.

---

# GitOps Workflow

Після кожної зміни вихідного коду відбувається такий процес:

1. Developer виконує push у Git.
2. Jenkins запускає Pipeline.
3. Kaniko збирає Docker-образ.
4. Образ публікується в Amazon ECR.
5. Jenkins оновлює тег образу в Helm chart.
6. Jenkins виконує push змін у репозиторій Helm.
7. Argo CD автоматично виявляє новий commit.
8. Argo CD синхронізує Kubernetes-кластер.
9. У кластері запускається нова версія застосунку.

---

# Argo CD

Argo CD налаштований на автоматичну синхронізацію:

* `automated`
* `prune: true`
* `selfHeal: true`

Після оновлення Helm chart новий Docker-образ автоматично розгортається в Amazon EKS без ручного втручання.

---

# Розгортання інфраструктури

```bash
terraform init
terraform apply -auto-approve
```

Після завершення застосування Terraform буде створено:

* Amazon EKS;
* Amazon ECR;
* Jenkins;
* Argo CD.

---

# Результат

У результаті реалізовано повністю автоматизований GitOps CI/CD процес:

* Terraform автоматично створює інфраструктуру AWS.
* Jenkins автоматично збирає Docker-образ.
* Docker-образ публікується в Amazon ECR.
* Jenkins автоматично оновлює Helm chart.
* Argo CD автоматично синхронізує Kubernetes-кластер після змін у Git.

Таким чином забезпечується безперервне розгортання (Continuous Deployment) Django-застосунку в Amazon EKS відповідно до принципів GitOps.
