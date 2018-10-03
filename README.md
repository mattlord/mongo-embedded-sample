This is the source used to build a test container image for the MongoDB 4.0 Embedded SDK on armv7 Operating Systems.

The container image is [available on docker hub](https://hub.docker.com/r/mattalord/mongo-embedded-armv7hf/).

You can run the test app -- ``iot_guestbook`` this way:
```
docker run --rm mattalord/mongo-embedded-armv7hf iot_guestbook "Matt Lord" "Hello from Dockerville"
```

Source for the test app is [available here](https://gist.github.com/mattlord/4926ddb4a1d46292e1296f9951f7ca17). 
