FROM microsoft/dotnet:2.1-runtime-stretch-slim-arm32v7

COPY iot_guestbook /usr/bin/iot_guestbook
COPY mongo-embedded-sdk-4.0.latest-debian9-armhf.tar.gz /tmp/mongo-embedded-sdk-4.0.latest-debian9-armhf.tar.gz
RUN tar xzvf /tmp/mongo-embedded-sdk-4.0.latest-debian9-armhf.tar.gz -C /opt/ && rm /tmp/mongo-embedded-sdk-4.0.latest-debian9-armhf.tar.gz
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/mongo-embedded-sdk-4.0.latest/lib/"

CMD ["/usr/bin/iot_guestbook"]
