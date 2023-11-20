FROM ubuntu:22.04

RUN apt update && apt install -y fio bash jq vim atop sysstat util-linux

ADD ./fio/ /fio/
WORKDIR /fio
ENTRYPOINT ["bash", "/fio/run.sh"]
