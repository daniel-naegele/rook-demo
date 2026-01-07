#!/usr/bin/env bash
set -Eeuo pipefail

echo "Please define the target IP (e.g. 1.1.1.1)"
read -p "" host

scp nixos@$host:/etc/rancher/k3s/k3s.yaml .

sed -i "s/127.0.0.1/$host/" k3s.yaml
flux install --kubeconfig k3s.yaml
kubectl apply -f k8s/flux/repository.yaml --kubeconfig k3s.yaml
kubectl apply -f k8s/flux/kustomization.yaml --kubeconfig k3s.yaml
