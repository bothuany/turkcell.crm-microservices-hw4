# Kubernetes Configuration for Microservices

This directory contains Kubernetes configuration files for deploying the microservices architecture.

## Directory Structure

The configurations are organized in a structured directory layout:

```
k8s/
├── namespace/
│   └── namespace.yaml
├── databases/
│   ├── postgres-order/
│   │   ├── configmap.yaml
│   │   ├── secret.yaml
│   │   ├── pvc.yaml
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   ├── postgres-identity/
│   ├── mongo-product/
│   ├── mongo-cart/
│   ├── mysql-customer/
│   └── kafka/
├── infrastructure/
│   ├── config-server/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   ├── discovery-server/
│   └── gateway-server/
│       ├── configmap.yaml
│       ├── deployment.yaml
│       ├── service.yaml
│       └── ingress.yaml
├── services/
│   ├── cart-service/
│   │   ├── configmap.yaml
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   ├── customer-service/
│   ├── identity-service/
│   ├── notification-service/
│   ├── order-service/
│   └── product-service/
└── kustomization.yaml
```

## Components

- **Namespace**: Creates the `microservices` namespace
- **Databases**:
  - PostgreSQL for order-service and identity-service
  - MongoDB for product-service and cart-service
  - MySQL for customer-service
  - Kafka for messaging
- **Infrastructure Services**:
  - Config Server: Configuration server
  - Discovery Server: Eureka discovery server
  - Gateway Server: API gateway with Ingress
- **Microservices**:
  - Cart Service
  - Customer Service
  - Identity Service
  - Notification Service
  - Order Service
  - Product Service

## Prerequisites

- Kubernetes cluster (local or cloud-based)
- kubectl installed and configured
- Docker images for all services built and available in a registry

## Deployment

### Using kubectl

To deploy all resources:

```bash
kubectl apply -k .
```

To deploy specific resources:

```bash
kubectl apply -f <directory>/<filename>.yaml
```

For example, to deploy only the databases:

```bash
kubectl apply -f databases/
```

### Using Kustomize

```bash
kustomize build | kubectl apply -f -
```

## Accessing Services

The API Gateway is exposed through an Ingress resource. Access your application through the Ingress endpoint.

## Scaling

To scale a deployment:

```bash
kubectl scale deployment <deployment-name> --replicas=<number> -n microservices
```

## Cleanup

To delete all resources:

```bash
kubectl delete -k .
```

## Environment Variables

The Kubernetes configurations use the following environment variables:

- `DOCKER_REGISTRY`: The Docker registry where your images are stored. Defaults to `localhost` if not set.

Example:

```bash
export DOCKER_REGISTRY=your-registry.com
kubectl apply -k .
```
