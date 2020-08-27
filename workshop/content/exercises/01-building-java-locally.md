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
