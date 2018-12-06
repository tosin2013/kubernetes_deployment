# Example Deployment deploying a Services
A [Kubernetes Service](https://kubernetes.io/docs/concepts/services-networking/service/) is an abstraction which defines a logical set of Pods and a policy by which to access them - sometimes called a micro-service. The set of Pods targeted by a Service is (usually) determined by a Label Selector (see below for why you might want a Service without a selector).

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
