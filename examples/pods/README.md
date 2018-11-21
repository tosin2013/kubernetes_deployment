# Example Deployment deploying a pod
A [pod](https://kubernetes.io/docs/concepts/workloads/pods/pod/) (as in a pod of whales or pea pod) is a group of one or more containers (such as Docker containers), with shared storage/network, and a specification for how to run the containers.

**[kubectl create](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#create) - Create a resource from a file or from stdin.**
```
kubectl create -f nginx-test.yml
```

**[kubectl delete](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#delete) -
Delete a pod based on the type and name in the JSON passed into stdin.***
```
kubectl delete -f nginx-test.yml
```

**[kubectl describe](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#describe) - Show details of a specific resource or group of resources***
```
kubectl describe  pod nginx
```

**[kubectl delete](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#logs) - Print the logs for a container in a pod or specified resource. If the pod has only one container, the container name is optional.***
```
kubectl logs -f nginx-pod
```

[Kubernetes Concepts - PODS ](https://kubernetes.io/docs/concepts/workloads/pods/pod/)
