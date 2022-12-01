FROM python:3

RUN pip install pysyslogclient

WORKDIR /var/app

ADD random-log.py /var/app/random-log.py

CMD python /var/app/random-log.py