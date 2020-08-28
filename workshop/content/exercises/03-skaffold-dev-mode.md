Skaffold can be used to build the image and then deploy it as separate steps, but we will be using what is called developer mode. That is, we will run Skaffold and it will build the image and then deploy it, but Skaffold will then also monitor for subsequent changes in the source code, and automatically re-build and re-deploy the image whenever changes are made.

To run Skaffold in developer mode run:

```execute
skaffold dev --namespace {{ session_namespace }} --port-forward
```

> NOTE: The `--namespace` option is required when using this workshop environment as that is the only namespace you have access to. For your own cluster where you may have broader access, you may not require it.

You will see the build for the application and container image using the buildpack start. The first time being built using a build pack can also take a few minutes, but for subsequent builds it will be quicker as it will be able to rely on the cached build artefacts from prior builds.

When the build completes, Skaffold will not actually return as it will start monitoring for code changes.

Towards the end of the output from the build phase you will see:

```
...
Deployments stabilized in 273.998843ms
...
Watching for changes...
Port forwarding service/demo in namespace {{ session_namespace }}, remote port 80 -> address 127.0.0.1 port 4503
...
[demo-6f5d49cdf6-wtvs6 demo] 2020-08-27 11:40:00.980  INFO 1 --- [main] o.s.b.web.embedded.netty.NettyWebServer  : Netty started on port(s): 8080
[demo-6f5d49cdf6-wtvs6 demo] 2020-08-27 11:40:00.990  INFO 1 --- [main] com.example.demo.DemoApplication         : Started DemoApplication in 7.294 seconds (JVM running for 8.769)
```

At this point the application has been deployed to the Kubernetes cluster. The latter part of the log is actually the logs from the pod in which the application is deployed.

You can check that the application is deployed by running:

```execute-2
kubectl get all
```

This should produce output similar to:

```
NAME                             READY     STATUS      RESTARTS   AGE
pod/demo-658b7f4997-qfw9l        1/1       Running     0          1m

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/demo         ClusterIP   10.43.138.213   <none>        80/TCP   1m

NAME                   READY     UP-TO-DATE   AVAILABLE   AGE
deployment.apps/demo   1/1       1            1           1m

NAME                              DESIRED   CURRENT   READY     AGE
replicaset.apps/demo-658b7f4997   1         1         1         1m
d
```

> TIP: Keep doing `kubectl get all` until the demo pod shows its status as "Running".
