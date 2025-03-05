@echo off
echo Cleaning up Microservices Kubernetes Deployment...

REM Delete all resources using Kustomize
kubectl delete -k .

echo Cleanup completed successfully! 