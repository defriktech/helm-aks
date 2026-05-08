#!/bin/bash

helm uninstall devops-release -n production

helm uninstall ingress-nginx -n ingress-nginx

kubectl delete namespace production

kubectl delete namespace cert-manager

az aks delete \
  --resource-group aks-rg \
  --name devops-aks \
  --yes \
  --no-wait

az acr delete \
  --resource-group aks-rg \
  --name defdevopsacr \
  --yes

az group delete \
  --name aks-rg \
  --yes \
  --no-wait
