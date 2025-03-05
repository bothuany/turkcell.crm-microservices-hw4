#!/bin/bash

# Exit on error
set -e

echo "Cleaning up Microservices Kubernetes Deployment..."

# Delete all resources in the microservices namespace
kubectl delete namespace microservices

echo "Cleanup completed successfully!" 