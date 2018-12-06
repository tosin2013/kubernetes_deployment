# Scheduling
* Use label selectors to schedule Pods.
    * node selector tells kubernetes to deploy a pod only to nodes containing a particular label.
    * http://www.kubernet.io/scheduling_cka_1.9.0.html#use-label-selectors-to-schedule-pods
* Understand the role of DaemonSets.
    * Pods managed by DamenSets by pass the scheduler
* Understand how resource limits can affect Pod scheduling.
    *  If a Container is created in a namespace that has a default memory limit, and the Container does not specify its own memory limit, then the Container is assigned the default memory limit. Kubernetes assigns a default memory request under certain conditions that are explained later the link below.
    * https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/
    * EXAMPLE Using Memory Limits:
    ```
    kubectl create namespace default-mem-example
    kubectl create -f https://k8s.io/examples/admin/resource/memory-defaults.yaml --namespace=default-mem-example
    kubectl create -f https://k8s.io/examples/admin/resource/memory-defaults-pod.yaml --namespace=default-mem-example
    kubectl get pod default-mem-demo --output=yaml --namespace=default-mem-example
    ```
    * A Kubernetes cluster can be divided into namespaces. If a Container is created in a namespace that has a default CPU limit, and the Container does not specify its own CPU limit, then the Container is assigned the default CPU limit. Kubernetes assigns a default CPU request under certain conditions that are explained later in this topic.
    * https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/cpu-default-namespace/
    * EXAMPLE Using CPU Limits:
    ```
    kubectl create namespace default-cpu-example
    kubectl create -f https://k8s.io/examples/admin/resource/cpu-defaults.yaml --namespace=default-cpu-example
    kubectl create -f https://k8s.io/examples/admin/resource/cpu-defaults-pod.yaml --namespace=default-cpu-example
    kubectl get pod default-cpu-demo --output=yaml --namespace=default-cpu-example
    ```
* Understand how to run multiple schedulers and how to configure Pods to use them.
    * Kubernetes ships with a default scheduler that is described here. If the default scheduler does not suit your needs you can implement your own scheduler. Not just that, you can even run multiple schedulers simultaneously alongside the default scheduler and instruct Kubernetes what scheduler to use for each of your pods.
    * https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/
* Manually schedule a pod without a scheduler.
    * https://kubernetes.io/docs/tasks/administer-cluster/static-pod/
* Display scheduler events.
    * [kubectl describe](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#describe)
    * kubectl get events
    * kubectl get events --watch
    * [kubectl logs](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#logs) kube-scheduler-bk8s-node0 -n kube-system (if scheduler is a pod)
    * /var/log/kube-scheduler.log on the control/master node (if schedule is standalone service)

* Know how to configure the Kubernetes scheduler.
    * https://kubernetes.io/docs/reference/generated/kube-scheduler/
    * https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/
    * https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/08-bootstrapping-kubernetes-controllers.md
