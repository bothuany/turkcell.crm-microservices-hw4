@echo off
echo Starting Microservices Deployment to Kubernetes with Kustomize...

REM Check if minikube is running
minikube status | findstr "Running" > nul
if errorlevel 1 (
  echo Minikube is not running. Starting minikube...
  minikube start
)

REM Use minikube's Docker daemon
echo Configuring to use Minikube's Docker daemon...
FOR /F "tokens=*" %%i IN ('minikube docker-env --shell cmd') DO %%i

REM Build Docker images
echo Building Docker images...
cd ..

echo Building Config Server...
cd config-server
docker build -t config-server:latest .
cd ..

echo Building Discovery Server...
cd discovery-server
docker build -t discovery-server:latest .
cd ..

echo Building Gateway Server...
cd gateway-server
docker build -t gateway-server:latest .
cd ..

echo Building Customer Service...
cd customer-service
docker build -t customer-service:latest .
cd ..

echo Building Identity Service...
cd identity-service
docker build -t identity-service:latest .
cd ..

echo Building Notification Service...
cd notification-service
docker build -t notification-service:latest .
cd ..

echo Building Order Service...
cd order-service
docker build -t order-service:latest .
cd ..

echo Building Product Service...
cd product-service
docker build -t product-service:latest .
cd ..

echo Building Cart Service...
cd cart-service
docker build -t cart-service:latest .
cd ..

REM Return to k8s directory
cd k8s

REM Deploy using Kustomize
echo Deploying Kubernetes resources using Kustomize...
kubectl apply -k .

REM Wait for Config Server to be ready
echo Waiting for Config Server to be ready...
kubectl wait --for=condition=available --timeout=300s deployment/config-server -n microservices

REM Wait for Discovery Server to be ready
echo Waiting for Discovery Server to be ready...
kubectl wait --for=condition=available --timeout=300s deployment/discovery-server -n microservices

echo Deployment completed successfully!
echo To access the Gateway Server, run: minikube service gateway-server-service -n microservices
echo To check the status of all deployments, run: kubectl get all -n microservices 