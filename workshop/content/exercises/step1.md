Before we start, change into the `demo` directory. This holds the source code for the application we will be working with.

```execute
cd ~/exercises/demo
```

Start a build of the application by running Maven.

```execute
./mvnw package
```

This is just a standard Java build at this point to produce the required build artefacts and the application JAR. Since it is the first time it is being run, it will take a few minutes.

You can see the results from the build by running:

```execute
tree target
```

With the build complete we could have run the application locally from the terminal, which is how you probably usually work on your code, but we will skip that and move straight on to looking at how we can use Skafold to build and deploy the application to Kubernetes as part of a developer workflow.

Normally when deploying applications to Kubernetes we need two key things. First we need a container image, and secondly we need a description for Kubernetes of how to deploy that container image.

With this demo application we already have the latter, in what is called a Kubernetes deployment resource file.

To view the deployment resource file, open the editor on the file `exercises/demo/src/k8s/deployment.yaml`.

```editor:open-file
file: ~/exercises/demo/src/k8s/deployment.yaml
```

Within the resource description you will see:

```
containers:
- image: "{{ REGISTRY_HOST }}/springguides/demo"
  name: demo
```

At the moment that container image doesn't exist, but this is where Skaffold comes in, by coordinating the build of it for us.

To instruct Skaffold as to what it needs to do, open a new file called `skaffold.yaml` with the follow content.

```editor:append-lines-to-file
file: exercises/demo/skaffold.yaml
text: |
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
```

These instructions tell Skaffold a number of things.

The `build.artifacts` section tells Skaffold it needs to create our required image. To do that, we want it to use the listed buildpack builder image.

When the buildpack is run, the container image will be built using the local docker service. The container image will then be pushed to the image registry listed with the image name. The user this workshop environment runs as has already been authenticated with the image registry so we will not need to log into the image registry in order to push the image.

When the build has been done and the image pushed to the image registry, Skaffold will deploy it to Kubernetes. To do this it will use the Kubernetes resource definitions listed under `deploy.kubectl`. In this case it will use the `deployment.yaml` you saw above.

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

At this point the application has been deployed to the Kubernetes cluster.

You can check that the application is deployed by running:

```execute-2
kubectl get all
```

This should produce output similar to:

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

If you were playing close attention you may have noticed we used the `--port-forward` option to the `skaffold dev` command. This instructs Skaffold to set up port forwarding between the local environment and the deployed application running inside of the Kubernetes cluster. This allows you to access the application from your local environment without needing to set up an ingress or expose the application outside of the cluster via a load balancer.

The port used for the port forwarding is displayed in the log output from Skaffold, in this case port 4503. To verify that the application is able to accept requests run:

```execute-2
curl localhost:4503
```

The output should be:

```
Hello
```

As already mentioned, Skaffold is now monitoring for any code changes, so if you make changes it will automatically re-build and re-deploy the application.

For example you could change the home endpoint in the main application class:

```editor:open-file
line: 14
file: exercises/demo/src/main/java/com/example/demo/DemoApplication.java
```

As soon as you save it the build will start. When finished and the application re-deployed, you will be able to inspect the results using curl again.

```execute
curl localhost:4503
```

If you are done with working on the application, you can kill Skaffold.

```terminal:interrupt
```

Because we are in Skaffold developer mode, this will result in the deployment being deleted from the Kubernetes cluster.

You can verify the application is being deleted by running:

```execute
kubectl get all
```

If you are quick enough you may catch it in the process of terminating and removing the deployment.

```
NAME                       READY   STATUS        RESTARTS   AGE
pod/demo-cbddd5b5b-qt5ml   0/1     Terminating   0          55s
```

Otherwise it will say:

```
No resources found in {{ session_namespace }} namespace.
```
