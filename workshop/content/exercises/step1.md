{% include "code-server/package.liquid" %}

In the terminal, pop into the `demo` directory and build the app:

```execute
cd demo && ./mvnw package -U
```

Then create a docker container:

```execute
./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName={{ REGISTRY_HOST }}/springguides/demo
```

You can test that the container is working:

```execute
docker run -p 8080:8080 {{ REGISTRY_HOST }}/springguides/demo
```

Sample output:

```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::        (v2.2.1.RELEASE)

2019-11-27 10:13:54.838  INFO 1 --- [           main] com.example.demo.DemoApplication         : Starting DemoApplication on 051fa7c2fe52with PID 1 (/app started by root in /)
2019-11-27 10:13:54.842  INFO 1 --- [           main] com.example.demo.DemoApplication         : No active profile set, falling back to default profiles: default
2019-11-27 10:14:00.070  INFO 1 --- [           main] trationDelegate$BeanPostProcessorChecker : Bean 'org.springframework.transaction.annotation.ProxyTransactionManagementConfiguration' of type [org.springframework.transaction.annotation.ProxyTransactionManagementConfiguration] is not eligible for getting processed by all BeanPostProcessors (for example: not eligible for auto-proxying)
2019-11-27 10:14:01.093  INFO 1 --- [           main] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 2 endpoint(s) beneath base path'/actuator'
2019-11-27 10:14:01.809  INFO 1 --- [           main] o.s.b.web.embedded.netty.NettyWebServer  : Netty started on port(s): 8080
2019-11-27 10:14:01.816  INFO 1 --- [           main] com.example.demo.DemoApplication         : Started DemoApplication in 1.793 seconds(JVM running for 2.061)
```

If the Actuator endpoints are there you can test with

```execute-2
curl localhost:8080/actuator/health
```

```
{"status":"UP"}
```

Once you are sure it is working you can kill the container:

```execute
<ctrl-c>
```

And push it to the local registry:

```execute
docker push {{ REGISTRY_HOST }}/springguides/demo
```

> NOTE: There is a Docker (v2) registry running on `{{ REGISTRY_HOST }}` port 80, just to make the tutorial work smoothly, and so you don't have to authenticate to Dockerhub. If you prefer to use Dockerhub just remove `{{ REGISTRY_HOST }}` from the container labels (or insert another registry host instead).