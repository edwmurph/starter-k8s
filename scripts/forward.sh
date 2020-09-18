#!/bin/bash

if [[ ! "$1" =~ grafana|alertmanager|prometheus ]]; then
  echo "USAGE: npm run forward (grafana|alertmanager|prometheus)"
  exit 1
fi

npm run ctx

if [[ $1 = "grafana" ]]; then
  kubectl port-forward --namespace monitoring svc/monitoring-kube-prometheus-stack-grafana 3000:80
elif [[ $1 = "alertmanager" ]]; then
  kubectl port-forward --namespace monitoring svc/monitoring-kube-prometheus-alertmanager 3000:9093
elif [[ $1 = "prometheus" ]]; then
  kubectl port-forward --namespace monitoring svc/monitoring-kube-prometheus-prometheus 3000:9090
fi
