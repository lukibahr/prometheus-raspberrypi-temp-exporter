FROM python:3.7-alpine

RUN apk add python3=3.8.5-r0 gcc=9.3.0-r2 python3-dev=3.8.5-r0 libc-dev=0.7.2-r3 --no-cache

WORKDIR /exporter

COPY requirements.txt .

RUN pip3 install -r requirements.txt

COPY src .

ENTRYPOINT ["python3", "exporter.py"]