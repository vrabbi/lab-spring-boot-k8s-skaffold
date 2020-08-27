By default Skaffold will watch all the files in your project for changes, and trigger a build if anything changes. You might have noticed that it did a bit too much work already when you edited the home endpoint. That's because it saw a change in the source code, and then the IDE re-compiled it and created a new class file, and this was picked up as a change as well. This can be fixed by being more explicit in the `skaffold.yaml` about the files to watch. Here we restrict the paths to watch to just `pom.xml` and `src/main`.

```editor:insert-value-into-yaml
file: exercises/demo/skaffold.yaml
path: build.artifacts[0].buildpacks
value:
  dependencies:
    paths:
      - pom.xml
      - src/main
```

Run Skaffold in developer mode again:

```execute
skaffold dev --namespace {{ session_namespace }} --port-forward
```

Now if you make a change to one of the source files, it will cause the container to be rebuilt, but changes to other files will not trigger any action.

> NOTE: The Kubernetes manifests are always included in the paths that Skaffold watches, so any change to `deployment.yaml` will cause a re-deploy as well.

Once the build has completed, test the application once more by running:

```execute-2
curl localhost:4503
```

and clean up by killing Skaffold:

```terminal:interrupt
```
