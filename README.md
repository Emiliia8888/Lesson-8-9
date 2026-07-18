# Django GitOps Project

## 1. Як застосувати Terraform
- `terraform init -upgrade`
- `terraform apply`

## 2. Як перевірити Jenkins job
- Посилання: `kubectl get svc -n jenkins`
- Логін: `admin`
- Пароль: `kubectl exec -it $(kubectl get pods -n jenkins -o jsonpath='{.items[0].metadata.name}') -n jenkins -- cat /var/jenkins_home/secrets/initialAdminPassword`

## 3. Як побачити результат в Argo CD
- Посилання: `kubectl get svc -n argocd`
- Логін: `admin`
- Пароль: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode; echo`
- Натисніть New App в Argo CD і вкажіть ваш Git репозиторій Lesson-8-9 та папку k8s.
