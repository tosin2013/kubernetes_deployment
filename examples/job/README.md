# Example Deployment deploying a job
A [job](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/) creates one or more pods and ensures that a specified number of them successfully terminate. As pods successfully complete, the job tracks the successful completions. When a specified number of successful completions is reached, the job itself is complete. Deleting a Job will cleanup the pods it created.

**[kubectl create](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#create) - Create a resource from a file or from stdin.**
```
kubectl create -f pi-job.yml
```

**[kubectl delete](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#delete) -
Delete a pod based on the type and name in the JSON passed into stdin.***
```
kubectl delete -f pi-job.yml
```

**[kubectl describe](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#describe) - Show details of a specific resource or group of resources***
```
kubectl describe  jobs/pi
```

**[kubectl delete](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#logs) - Print the logs for a container in a pod or specified resource. If the pod has only one container, the container name is optional.***
```
kubectl logs -f pi
```

[Kubernetes Concepts - JOB ](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/)
