
{% include "code-server/package.liquid" %}

First lets drop into the demo project folder:

```execute
cd demo
```

There is already a <span class="editor_link" data-file="/home/eduk8s/exercises/demo/src/k8s/deployment.yaml">basic `deployment.yaml` in the demo</span>. You can open it up and have a look (just click on the link).

You could use it push the app to the cluster directly. But we are here to learn how to do that with Skaffold. So create a new `skaffold.yaml`:

<pre class="pastable" data-file="/home/eduk8s/exercises/demo/skaffold.yaml">
apiVersion: skaffold/v2beta5
kind: Config
build:
  artifacts:
    - image: {{ REGISTRY_HOST }}/springguides/demo
      buildpacks:
        builder: gcr.io/paketo-buildpacks/builder:base-platform-api-0.3
deploy:
  kubectl:
    manifests:
      - "src/k8s/*"
</pre>

Build and run the application in one go (in "dev" mode):

```execute
skaffold dev --namespace {{ session_namespace }} --port-forward
```

You will see the build ticking over and also at some point some logging to tell you about the port forward:

```
...
Deployments stabilized in 273.998843ms
Watching for changes...
Port forwarding service/demo in namespace {{ session_namespace }}, remote port 80 -> address 127.0.0.1 port 4503
...
```

Check that the application is running:

```execute-2
kubectl get all
```

```
NAME                             READY     STATUS      RESTARTS   AGE
pod/demo-658b7f4997-qfw9l        1/1       Running     0          146m

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/kubernetes   ClusterIP   10.43.0.1       <none>        443/TCP    2d18h
service/demo         ClusterIP   10.43.138.213   <none>        80/TCP   21h

NAME                   READY     UP-TO-DATE   AVAILABLE   AGE
deployment.apps/demo   1/1       1            1           21h

NAME                              DESIRED   CURRENT   READY     AGE
replicaset.apps/demo-658b7f4997   1         1         1         21h
d
```

> TIP: Keep doing `kubectl get all` until the demo pod shows its status as "Running".

The port that is being forwarded will be printed on the console. Then you can verify that the app [is running](//{{ session_namespace }}-application.{{ ingress_domain }}/actuator/health):

```execute-2
curl localhost:4503
```

```
Hello
```

You can edit the source code and Skaffold will rebuild and redeploy. For example you could change the home endpoint in <span class="editor_link" data-file="/home/eduk8s/exercises/demo/src/main/java/com/example/demo/DemoApplication.java">the main application class</spab>. As soon as you save it the build starts and eventually you will be able to inspect the results using curl as above.

When you kill Skaffold, the app is removed from the cluster:

```execute
<ctrl-c>
```

```execute
kubectl get all
```

```
No resources found in {{ session_namespace }} namespace.
```