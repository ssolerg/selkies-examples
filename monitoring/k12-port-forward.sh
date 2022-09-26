#!/usr/bin/env bash



export PROJECT_ID=$1
export REGION=$2

gcloud config set project ${PROJECT_ID?}
gcloud container clusters get-credentials broker-${REGION?} --region ${REGION?}

# For Access to Grafana WebUI
POD=$(kubectl get pod -n monitoring -l app.kubernetes.io/name=grafana -o jsonpath='{..metadata.name}' | head -1)
kubectl port-forward --address 0.0.0.0 ${POD} -n monitoring 3000:3000
echo "https://localhost:3000"