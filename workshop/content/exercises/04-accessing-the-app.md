If you were paying close attention you may have noticed we used the `--port-forward` option to the `skaffold dev` command. This instructs Skaffold to set up port forwarding between the local environment and the deployed application running inside of the Kubernetes cluster. This allows you to access the application from your local environment without needing to set up an ingress or expose the application outside of the cluster via a load balancer.

The port used for the port forwarding is displayed in the log output from Skaffold, in this case port 4503. To verify that the application is able to accept requests run:

```execute-2
curl localhost:4503
```

The output should be:

```
Hello
```
