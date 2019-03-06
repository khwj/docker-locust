FROM python:2.7-alpine
LABEL MAINTAINER "Khwunchai Jaengsawang <khwunchai.j@ku.th>"

COPY requirements.txt requirements.txt
RUN apk --no-cache add --virtual=.build-dep \
      build-base \
    && apk --no-cache add bash libzmq \
    && pip install -r requirements.txt \
    && apk del .build-dep

# Temporary fix for https://stackoverflow.com/a/35404652/2420789
RUN sed -i s/ssl_version=PROTOCOL_SSLv3/ssl_version=PROTOCOL_SSLv23/g \
  /usr/local/lib/python2.7/site-packages/gevent/ssl.py

COPY locust-tasks /locust-tasks
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
EXPOSE 5557 5558 8089
ENTRYPOINT ["/entrypoint.sh"]