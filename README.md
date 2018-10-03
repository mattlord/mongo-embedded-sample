This is the source used to build a sample MongoDB Embedded app container image for testing the MongoDB 4.0 Embedded SDK (currently only on armv7 Operating Systems).

The container image is [available on docker hub](https://hub.docker.com/r/mattalord/mongo-embedded-sample/).

You can run [the example app](https://gist.github.com/mattlord/4926ddb4a1d46292e1296f9951f7ca17) -- ``iot_guestbook`` -- this way:
```
docker run --rm mattalord/mongo-embedded-sample:armv7hf iot_guestbook --help
Usage: iot_guestbook [name] [message]

docker run --rm -v /tmp:/tmp mattalord/mongo-embedded-sample:armv7hf
{ "message" : "Hello IoT World", "from" : "anonymous", "date" : { "$date" : 1538545186000 } }

docker run --rm -v /tmp:/tmp mattalord/mongo-embedded-sample:armv7hf iot_guestbook "Matt Lord" "Hello from Dockerville"
{ "message" : "Hello IoT World", "from" : "anonymous", "date" : { "$date" : 1538545704000 } }
{ "message" : "Hello from Dockerville", "from" : "Matt Lord", "date" : { "$date" : 1538545726000 } }
```

Note: we’re mapping /tmp in the container to /tmp on the host so that we can have a local persistent database (/tmp/mobile.sqlite) as [the example app stores the database in /tmp](https://gist.github.com/mattlord/4926ddb4a1d46292e1296f9951f7ca17#file-iot_guestbook-c-L44).
