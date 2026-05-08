#!/bin/bash

az aks create \
  --resource-group aks-rg \
  --name devops-aks \
  --location swedencentral \
  --node-count 1 \
  --node-vm-size Standard_B2s_v2 \
  --enable-addons monitoring \
  --attach-acr defdevopsacr \
  --enable-managed-identity \
  --generate-ssh-keys
