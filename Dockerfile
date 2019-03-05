FROM python:2.7-alpine

COPY requirements.txt requirements.txt
RUN apk --no-cache add --virtual=.build-dep \
      build-base \
    && apk --no-cache add bash libzmq \
    && pip install -r requirements.txt \
    && apk del .build-dep

COPY locust-tasks /locust-tasks
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
EXPOSE 5557 5558 8089
ENTRYPOINT ["/entrypoint.sh"]