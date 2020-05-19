ARG JMETER_VERSION="5.3"

FROM ubuntu:latest as downloader

LABEL maintainer="Ashok Pon Kumar"

ARG JMETER_VERSION
ENV JMETER_DOWNLOAD_URL https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

RUN apt-get update && apt-get install -y \
curl

RUN mkdir -p /jmeter/extracted \
 && curl -L ${JMETER_DOWNLOAD_URL} > /jmeter/apache-jmeter-${JMETER_VERSION}.tgz \
 && mkdir -p /opt \
 && tar -xzf /jmeter/apache-jmeter-${JMETER_VERSION}.tgz -C /jmeter/extracted/ 


FROM openjdk:15-jdk 

LABEL maintainer="Ashok Pon Kumar"  

ARG JMETER_VERSION
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN ${JMETER_HOME}/bin
ENV PATH $PATH:$JMETER_BIN

COPY --from=downloader /jmeter/extracted/apache-jmeter-${JMETER_VERSION} $JMETER_HOME

EXPOSE 8888

ENTRYPOINT [ "bash", "-c", "${JMETER_HOME}/bin/jmeter-server -Dserver.rmi.localport=8887 -Dserver_port=8888 -Dserver.rmi.ssl.disable=true" ]
