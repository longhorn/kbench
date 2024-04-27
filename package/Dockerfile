FROM ubuntu:20.04

RUN apt update && apt install -y fio bash jq

ADD ./fio/ /fio/
ADD ./bin/metric-exporter /usr/local/sbin/
WORKDIR "/fio/"
ENTRYPOINT ["bash", "/fio/run.sh"]
