This is the source used to build a sample MongoDB Embedded app container image.

The container image is [available on docker hub](https://hub.docker.com/r/mattalord/mongo-embedded-sample/). There is currently only an armhf image which should allow you to run the sample app on any 32 bit ARM OS running on armv7 or armv8 hardware.

You can run [the sample app](https://gist.github.com/mattlord/4926ddb4a1d46292e1296f9951f7ca17) -- ``iot_guestbook`` -- this way:
```
docker run --rm mattalord/mongo-embedded-sample:armhf iot_guestbook --help
Usage: iot_guestbook [name] [message]

docker run --rm -v /tmp:/tmp mattalord/mongo-embedded-sample:armhf
{ "message" : "Hello IoT World", "from" : "anonymous", "date" : { "$date" : 1538545186000 } }

docker run --rm -v /tmp:/tmp mattalord/mongo-embedded-sample:armhf iot_guestbook "Matt Lord" "Hello from Dockerville"
{ "message" : "Hello IoT World", "from" : "anonymous", "date" : { "$date" : 1538545704000 } }
{ "message" : "Hello from Dockerville", "from" : "Matt Lord", "date" : { "$date" : 1538545726000 } }
```

Note: we’re mapping /tmp in the container to /tmp on the host so that we can have a local persistent database (/tmp/mobile.sqlite) as [the sample app stores the database in /tmp](https://gist.github.com/mattlord/4926ddb4a1d46292e1296f9951f7ca17#file-iot_guestbook-c-L44).
