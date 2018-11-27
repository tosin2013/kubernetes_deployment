# Scheduling
* Use label selectors to schedule Pods.
    * node selector tells kubernetes to deploy a pod only to nodes containing a particular label.
    * http://www.kubernet.io/scheduling_cka_1.9.0.html#use-label-selectors-to-schedule-pods
* Understand the role of DaemonSets.
    * Pods managed by DamenSets by pass the scheduler
* Understand how resource limits can affect Pod scheduling.
    *  If a Container is created in a namespace that has a default memory limit, and the Container does not specify its own memory limit, then the Container is assigned the default memory limit. Kubernetes assigns a default memory request under certain conditions that are explained later in this topic.
    * https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/
    * EXAMPLE: 
    ```
    kubectl create namespace default-mem-example
    kubectl create -f https://k8s.io/examples/admin/resource/memory-defaults.yaml --namespace=default-mem-example
    kubectl create -f https://k8s.io/examples/admin/resource/memory-defaults-pod.yaml --namespace=default-mem-example
    kubectl get pod default-mem-demo --output=yaml --namespace=default-mem-example
    ```
* Understand how to run multiple schedulers and how to configure Pods to use them.
    *
* Manually schedule a pod without a scheduler.
* Display scheduler events.
* Know how to configure the Kubernetes scheduler.
