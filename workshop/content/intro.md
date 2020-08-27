Spring Boot provides a number of features to ensure it works well with Kubernetes. This workshop shows how you can use [Skaffold](https://skaffold.dev/) in conjunction with a Spring Boot application to make the job of developing and pushing applications to Kubernetes easier. The topics we will cover are:

1. Configuring the Skaffold tool.
2. Using Skaffold in developer mode.

We don't cover all the features of Spring and Spring Boot. For more information you can check out the [Spring guides](https://spring.io/guides) or [Spring project homepages](https://spring.io/projects).

We also don't cover all the options available for building container images. There is a [Spring Boot topical guide](https://spring.io/guides/top/spring-boot-docker) covering some of those options in more detail.

When it comes to deploying the application to Kubernetes, there are far too many options to cover them all in one tutorial. We can look at one or two, but the emphasis will be on getting something working as quickly as possible, not on how to deploy to a production cluster.

During this workshop we will be using the command line as well as the embedded editor. The editor takes a few moments to start up and be ready, so select the **Editor** tab now to display it, or click on the action block below.

```dashboard:open-dashboard
name: Editor
```

The workshop uses these action blocks for various purposes. Anytime you see such a block with an icon on the right hand side, you can click on it and it will perform the listed action for you.

Although we don't use it for the workshop, web console access is provided to the Kubernetes cluster using [Octant](https://octant.dev/). To access Octant, select the **Console** tab. This will allow you to investigate further any deployments made to the cluster.
