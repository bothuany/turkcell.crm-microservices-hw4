#!/bin/bash

# Exit on error
set -e

echo "Starting Microservices Deployment to Kubernetes..."

# Check if minikube is running
if ! minikube status | grep -q "Running"; then
  echo "Minikube is not running. Starting minikube..."
  minikube start
fi

# Use minikube's Docker daemon
echo "Configuring to use Minikube's Docker daemon..."
eval $(minikube docker-env)

# Build Docker images
echo "Building Docker images..."
cd ..

echo "Building Config Server..."
cd config-server
docker build -t config-server:latest .
cd ..

echo "Building Discovery Server..."
cd discovery-server
docker build -t discovery-server:latest .
cd ..

echo "Building Gateway Server..."
cd gateway-server
docker build -t gateway-server:latest .
cd ..

echo "Building Customer Service..."
cd customer-service
docker build -t customer-service:latest .
cd ..

echo "Building Identity Service..."
cd identity-service
docker build -t identity-service:latest .
cd ..

echo "Building Notification Service..."
cd notification-service
docker build -t notification-service:latest .
cd ..

echo "Building Order Service..."
cd order-service
docker build -t order-service:latest .
cd ..

echo "Building Product Service..."
cd product-service
docker build -t product-service:latest .
cd ..

echo "Building Cart Service..."
cd cart-service
docker build -t cart-service:latest .
cd ..

# Return to k8s directory
cd k8s

# Deploy in order
echo "Deploying Kubernetes resources..."

echo "Creating namespace and configmap..."
kubectl apply -f 00-namespace.yaml
kubectl apply -f 01-configmap.yaml

echo "Creating persistent volumes..."
kubectl apply -f 02-persistent-volumes.yaml

echo "Deploying databases..."
kubectl apply -f 03-databases.yaml

echo "Deploying Kafka..."
kubectl apply -f 04-kafka.yaml

echo "Deploying Config Server..."
kubectl apply -f 05-config-server.yaml
echo "Waiting for Config Server to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/config-server -n microservices

echo "Deploying Discovery Server..."
kubectl apply -f 06-discovery-server.yaml
echo "Waiting for Discovery Server to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/discovery-server -n microservices

echo "Deploying Gateway Server..."
kubectl apply -f 07-gateway-server.yaml

echo "Deploying Microservices..."
kubectl apply -f 08-customer-service.yaml
kubectl apply -f 09-identity-service.yaml
kubectl apply -f 10-notification-service.yaml
kubectl apply -f 11-order-service.yaml
kubectl apply -f 12-product-service.yaml
kubectl apply -f 13-cart-service.yaml

echo "Deployment completed successfully!"
echo "To access the Gateway Server, run: minikube service gateway-server-service -n microservices"
echo "To check the status of all deployments, run: kubectl get all -n microservices" 