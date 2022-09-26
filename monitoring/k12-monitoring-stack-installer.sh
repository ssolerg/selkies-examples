#!/usr/bin/env bash

# Installing helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

export PROJECT_ID=_PROJECT_ID_KEY
export REGION=_REGION_ID_KEY

gcloud config set project ${PROJECT_ID?}
gcloud container clusters get-credentials broker-${REGION?} --region ${REGION?}

kubectl create ns monitoring

helm install kube-prom-stack prometheus-community/kube-prometheus-stack -n monitoring

# For Access to Grafana WebUI
# POD=$(kubectl get pod -n monitoring -l app.kubernetes.io/name=grafana -o jsonpath='{..metadata.name}' | head -1)
# echo "Execute in your localhost: kubectl port-forward --address 0.0.0.0 ${POD} -n monitoring 3000:3000"