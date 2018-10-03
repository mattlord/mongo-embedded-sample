This is the source used to build a test container image for the MongoDB 4.0 Embedded SDK on armv7 Operating Systems.

The container is available on docker hub: https://hub.docker.com/r/mattalord/mongo-embedded-armv7hf/

You can test it this way:
```
docker run --rm mattalord/mongo-embedded-armv7hf:4.0.3 iot_guestbook "Matt Lord" "Hello from Dockerville"
```
