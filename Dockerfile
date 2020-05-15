FROM python:2.7

COPY entrypoint.sh /entrypoint.sh

RUN pip install xdclient

ENTRYPOINT ["/entrypoint.sh"]
