
{% include "code-server/package.liquid" %}

There is already a <span class="editor_link" data-file="/home/eduk8s/exercises/demo/src/k8s/deployment.yaml">basic `deployment.yaml` in the demou can open it up and have a look.

You could use it push the app to the cluster directly. But we are here to learn how to do that with Skaffold. So create a new `skaffold.yaml`:

<pre class="pastable" data-file="/home/eduk8s/exercises/demo/skaffold.yaml">
apiVersion: skaffold/v2beta5
kind: Config
build:
  artifacts:
    - image: {{ REGISTRY_HOST }}/springguides/demo
      buildpacks:
        builder: gcr.io/paketo-buildpacks/builder:base-platform-api-0.3
        dependencies:
          paths:
            - pom.xml
            - src/main/resources
            - target/classes
      sync:
        manual:
          - src: "src/main/resources/**/*"
            dest: /workspace/BOOT-INF/classes
            strip: src/main/resources/
          - src: "target/classes/**/*"
            dest: /workspace/BOOT-INF/classes
            strip: target/classes/
deploy:
  kubectl:
    paths:
      - "src/k8s"
</pre>

Build and run the application in one go (in "dev" mode):

```execute
skaffold dev --port-forward
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
service/demo         ClusterIP   10.43.138.213   <none>        8080/TCP   21h

NAME                   READY     UP-TO-DATE   AVAILABLE   AGE
deployment.apps/demo   1/1       1            1           21h

NAME                              DESIRED   CURRENT   READY     AGE
replicaset.apps/demo-658b7f4997   1         1         1         21h
d
```

> TIP: Keep doing `kubectl get all` until the demo pod shows its status as "Running".

The port that is being forwarded will be printed on the console. Then you can verify that the app [is running](//{{ session_namespace }}-application.{{ ingress_domain }}/actuator/health):

```execute-2
curl localhost:4503/actuator/health
```

```
{"status:"UP"}
```

When you kill Skaffold, the app is rmeoved from the cluster:

```execute
<ctrl-c>
```

```execute
kubectl get all
```

```
No resources found in {{ workshop_namespace }} namespace.
```