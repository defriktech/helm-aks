# Kubernetes + Helm + Production Setup on Azure AKS

Production-style Kubernetes deployment using:

- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Helm
- NGINX Ingress Controller
- cert-manager
- GitHub Actions CI/CD
- Kubernetes Namespaces
- TLS/HTTPS
- Rolling Deployments
- Production Folder Structure

This project simulates how modern DevOps teams deploy applications into Kubernetes clusters in real production environments.

---

# Project Architecture

```text
Internet
   |
NGINX Ingress Controller
   |
Kubernetes Service (ClusterIP)
   |
Pods (Docker Containers)
   |
Azure Kubernetes Service (AKS)
```

CI/CD Flow:

```text
GitHub Push
   |
GitHub Actions
   |
Build Docker Image
   |
Push to Azure Container Registry (ACR)
   |
Helm Upgrade on AKS
```

---

# Technologies Used

| Technology | Purpose |
|---|---|
| Docker | Containerization |
| Kubernetes | Container orchestration |
| Azure AKS | Managed Kubernetes |
| Azure ACR | Private container registry |
| Helm | Kubernetes package manager |
| NGINX Ingress | Traffic routing |
| cert-manager | TLS certificates |
| GitHub Actions | CI/CD automation |
| Python Flask | Sample application |

---

# Project Structure

```text
helm-aks/
│
├── app/
│   ├── app.py
│   ├── requirements.txt
│   └── Dockerfile
│
├── kubernetes/
│   ├── namespace/
│   │   └── namespace.yaml
│   │
│   ├── ingress/
│   │   ├── ingress.yaml
│   │   └── cluster-issuer.yaml
│   │
│   └── helm/
│       └── devops-app/
│           ├── Chart.yaml
│           ├── values.yaml
│           └── templates/
│               ├── deployment.yaml
│               ├── service.yaml
│               ├── ingress.yaml
│               └── _helpers.tpl
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
└── README.md
```

---

# Features Implemented

## Kubernetes Namespace

The application is deployed into a dedicated namespace:

```bash
kubectl create namespace dev
```

Benefits:

- Environment isolation
- Cleaner resource management
- Better production organization

---

# AKS Cluster Setup

AKS cluster created in Sweden Central:

```bash
az aks create \
  --resource-group aks-rg \
  --name devops-aks \
  --location swedencentral \
  --node-count 1 \
  --node-vm-size Standard_B2s_v2 \
  --enable-addons monitoring \
  --generate-ssh-keys
```

Connect to cluster:

```bash
az aks get-credentials \
  --resource-group aks-rg \
  --name devops-aks
```

---

# Azure Container Registry (ACR)

Registry used:

```text
defdevopsacr
```

Login:

```bash
az acr login --name defdevopsacr
```

Attach ACR to AKS:

```bash
az aks update \
  --resource-group aks-rg \
  --name devops-aks \
  --attach-acr defdevopsacr
```

---

# Docker Build & Push

Build image:

```bash
docker build -t defdevopsacr.azurecr.io/devops-app:v1 ./app
```

Push image:

```bash
docker push defdevopsacr.azurecr.io/devops-app:v1
```

---

# Helm Deployment

Install application with Helm:

```bash
helm install devops-app ./kubernetes/helm/devops-app -n dev
```

Upgrade deployment:

```bash
helm upgrade devops-app ./kubernetes/helm/devops-app -n dev
```

Benefits of Helm:

- Versioned deployments
- Reusable templates
- Easier upgrades
- Cleaner Kubernetes management

---

# NGINX Ingress Controller

Installed using Helm:

```bash
helm install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace
```

Purpose:

- External traffic routing
- Single entry point into cluster
- Supports TLS termination

---

# cert-manager + HTTPS

Install cert-manager:

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.yaml
```

ClusterIssuer handles TLS certificates.

HTTPS enabled through:

- cert-manager
- Let's Encrypt
- Ingress TLS configuration

---

# GitHub Actions CI/CD

Pipeline automates:

1. Build Docker image
2. Push image to ACR
3. Deploy to AKS using Helm

Workflow file:

```text
.github/workflows/deploy.yml
```

---

# Kubernetes Commands Used

Check pods:

```bash
kubectl get pods -n dev
```

Check services:

```bash
kubectl get svc -n dev
```

Check ingress:

```bash
kubectl get ingress -n dev
```

View logs:

```bash
kubectl logs <pod-name> -n dev
```

Scale deployment:

```bash
kubectl scale deployment devops-app --replicas=3 -n dev
```

---

# Production Concepts Learned

This project covers:

- Kubernetes orchestration
- AKS administration
- Container image lifecycle
- Helm templating
- CI/CD pipelines
- Rolling deployments
- Namespaces
- TLS certificates
- Ingress networking
- Cloud-native deployment workflows

---

# Deployment Verification

Verify:

```bash
kubectl get all -n dev
```

Expected:

- Running pods
- Active service
- Healthy ingress
- External IP assigned

---

# Destroy Resources

Delete Helm release:

```bash
helm uninstall devops-app -n dev
```

Delete namespace:

```bash
kubectl delete namespace dev
```

Delete ingress controller:

```bash
helm uninstall ingress-nginx -n ingress-nginx
kubectl delete namespace ingress-nginx
```

Delete cert-manager:

```bash
kubectl delete namespace cert-manager
```

Delete AKS cluster:

```bash
az aks delete \
  --resource-group aks-rg \
  --name devops-aks \
  --yes \
  --no-wait
```

Delete ACR:

```bash
az acr delete \
  --name defdevopsacr \
  --resource-group aks-rg
```

Delete resource group:

```bash
az group delete \
  --name aks-rg \
  --yes \
  --no-wait
```

---

# Skills Demonstrated

- Azure Kubernetes Service (AKS)
- Kubernetes Administration
- Helm Package Management
- CI/CD Automation
- GitHub Actions
- Docker & Containerization
- Azure Cloud Infrastructure
- TLS/HTTPS Configuration
- NGINX Ingress Controller
- Infrastructure Automation

---

# Final Result

This project demonstrates a production-style Kubernetes deployment pipeline with:

- Automated CI/CD
- Container registry integration
- Secure ingress routing
- HTTPS support
- Helm-based deployments
- Kubernetes best practices


