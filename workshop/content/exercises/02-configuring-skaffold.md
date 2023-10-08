Normally when deploying applications to Kubernetes we need two key things. First we need a container image, and secondly we need a description for Kubernetes of how to deploy that container image.

With this demo application we already have the latter, in what is called a Kubernetes deployment resource file.

To view the deployment resource file, open the editor on the file `~/exercises/demo/src/k8s/deployment.yaml`.

```editor:open-file
file: ~/exercises/demo/src/k8s/deployment.yaml
```

Within the resource description you will see:

```
containers:
- image: "{{ registry_host }}/springguides/demo"
  name: demo
```

At the moment that container image doesn't exist, but this is where Skaffold comes in, by coordinating the build of it for us.

To instruct Skaffold as to what it needs to do, open a new file called `~/exercises/demo/skaffold.yaml` with the follow content.

```editor:append-lines-to-file
file: ~/exercises/demo/skaffold.yaml
text: |
  apiVersion: skaffold/v2beta5
  kind: Config
  build:
    artifacts:
      - image: {{ registry_host }}/springguides/demo
        buildpacks:
          builder: gcr.io/paketo-buildpacks/builder:base-platform-api-0.3
          env:
            - 'BP_JVM_VERSION=11'
  deploy:
    kubectl:
      manifests:
        - "src/k8s/*"
```

These instructions tell Skaffold a number of things.

The `build.artifacts` section tells Skaffold it needs to create our required image. To do that, we want it to use the listed buildpack builder image.

When the buildpack is run, the container image will be built using the local docker service. The container image will then be pushed to the image registry listed with the image name. The user this workshop environment runs as has already been authenticated with the image registry so we will not need to log into the image registry in order to push the image.

When the build has been done and the image pushed to the image registry, Skaffold will deploy it to Kubernetes. To do this it will use the Kubernetes resource definitions listed under `deploy.kubectl`. In this case it will use the `deployment.yaml` you saw above.
