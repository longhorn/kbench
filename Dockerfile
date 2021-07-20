FROM alpine

RUN apk --no-cache add fio bash jq

ADD ./fio/ /fio/
WORKDIR ["/fio/"]
ENTRYPOINT ["bash", "/fio/run.sh"]
