# Microservices Kubernetes Deployment

This directory contains Kubernetes manifests for deploying the microservices architecture to a Kubernetes cluster using Minikube.

## Prerequisites

- Minikube installed and running
- kubectl installed and configured
- Docker installed (for building images)

## Service Dependencies

The microservices are configured with proper startup dependencies:

1. **Config Server** starts first
2. **Discovery Server** waits for Config Server to be ready before starting
3. All other services (Gateway, Customer, Identity, Notification, Order, Product, Cart) wait for Discovery Server to be ready

This dependency chain is implemented using Kubernetes init containers that check the health endpoints of dependent services before allowing a service to start.

## Deployment Options

### Option 1: Manual Deployment with Docker Compose (Recommended)

You can deploy the entire microservices stack using the following commands:

```cmd
# 1. Start Minikube
minikube start

# 2. Configure to use Minikube's Docker daemon
@FOR /f "tokens=*" %i IN ('minikube -p minikube docker-env --shell cmd') DO @%i

# 3. Build all Docker images using docker-compose
cd ..
docker-compose build
cd k8s

# 4. Deploy all Kubernetes resources using Kustomize
kubectl apply -k .

# 5. Check the status of your pods
kubectl get pods -n microservices
```

### Accessing Services

To access the Gateway Server (entry point to the system):

```bash
minikube service gateway-server-service -n microservices
```

### Monitoring

Check the status of all deployments:

```bash
kubectl get all -n microservices
```

View logs for a specific service:

```bash
kubectl logs -f deployment/[service-name] -n microservices
```

### Cleanup

To remove all resources:

```bash
kubectl delete -k .
```

### Troubleshooting

If services are not starting properly, check the logs:

```bash
kubectl logs -f deployment/config-server -n microservices
kubectl logs -f deployment/discovery-server -n microservices
```

For database connection issues, you may need to check if the persistent volumes are properly mounted:

```bash
kubectl describe pv postgres-order-pv -n microservices
kubectl describe pvc postgres-order-pvc -n microservices
```

If you're experiencing ImagePullBackOff errors, make sure:

1. You've built the Docker images with docker-compose build
2. You're using Minikube's Docker daemon (@FOR /f "tokens=\*" %i IN ('minikube -p minikube docker-env --shell cmd') DO @%i)
3. The image names in kustomization.yaml match the ones in your docker-compose.yml file

## Building Docker Images

Before deploying to Kubernetes, you need to build the Docker images for each service:

```bash
# Build all service images
eval $(minikube docker-env)  # Use Minikube's Docker daemon
cd ../config-server && docker build -t config-server:latest .
cd ../discovery-server && docker build -t discovery-server:latest .
cd ../gateway-server && docker build -t gateway-server:latest .
cd ../customer-service && docker build -t customer-service:latest .
cd ../identity-service && docker build -t identity-service:latest .
cd ../notification-service && docker build -t notification-service:latest .
cd ../order-service && docker build -t order-service:latest .
cd ../product-service && docker build -t product-service:latest .
cd ../cart-service && docker build -t cart-service:latest .
```

## Deployment Order

The services should be deployed in the following order to ensure proper startup:

1. Namespace and ConfigMap
2. Persistent Volumes
3. Databases
4. Kafka
5. Config Server
6. Discovery Server
7. Gateway Server
8. Microservices (Customer, Identity, Notification, Order, Product, Cart)

## Deployment Steps

```bash
# Create namespace and configmap
kubectl apply -f 00-namespace.yaml
kubectl apply -f 01-configmap.yaml

# Create persistent volumes
kubectl apply -f 02-persistent-volumes.yaml

# Deploy databases
kubectl apply -f 03-databases.yaml

# Deploy Kafka
kubectl apply -f 04-kafka.yaml

# Deploy Config Server (wait for it to be ready)
kubectl apply -f 05-config-server.yaml
kubectl wait --for=condition=available --timeout=300s deployment/config-server -n microservices

# Deploy Discovery Server (wait for it to be ready)
kubectl apply -f 06-discovery-server.yaml
kubectl wait --for=condition=available --timeout=300s deployment/discovery-server -n microservices

# Deploy Gateway Server
kubectl apply -f 07-gateway-server.yaml

# Deploy Microservices
kubectl apply -f 08-customer-service.yaml
kubectl apply -f 09-identity-service.yaml
kubectl apply -f 10-notification-service.yaml
kubectl apply -f 11-order-service.yaml
kubectl apply -f 12-product-service.yaml
kubectl apply -f 13-cart-service.yaml
```

## Accessing Services

To access the Gateway Server (entry point to the system):

```bash
minikube service gateway-server-service -n microservices
```

## Monitoring

Check the status of all deployments:

```bash
kubectl get all -n microservices
```

View logs for a specific service:

```bash
kubectl logs -f deployment/[service-name] -n microservices
```

## Cleanup

To remove all resources:

```bash
kubectl delete namespace microservices
```

## Troubleshooting

If services are not starting properly, check the logs:

```bash
kubectl logs -f deployment/config-server -n microservices
kubectl logs -f deployment/discovery-server -n microservices
```

For database connection issues, you may need to check if the persistent volumes are properly mounted:

```bash
kubectl describe pv postgres-order-pv -n microservices
kubectl describe pvc postgres-order-pvc -n microservices
```
