As already mentioned, Skaffold is now monitoring for any code changes, so if you make changes it will automatically re-build and re-deploy the application.

For example you could change the home endpoint in the main application class:

```editor:open-file
line: 14
file: exercises/demo/src/main/java/com/example/demo/DemoApplication.java
```

Change "Hello" to "Goodbye" in the response.

As soon as you save the file, back in the terminal you will see that a new build has started.

When the build has finished and the application re-deployed, you will be able to inspect the results using curl again.

```execute-2
curl localhost:4503
```

Initially you may seen an empty reply from the application as it starts up, so keep trying.

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
