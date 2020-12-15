# Makefile

RUNPYTHON = $(shell which python)
RUNLINT = $(shell which pylint)
RUNPIP = $(shell which pip)
RUNDOCKER = $(shell which docker) 

IMAGE = docker.io/lukasbahr/prometheus-raspberrypi-temp-exporter
VERSION = master

EXPORTER_PORT=9456

all: requirements lint run
 
lint: 
	$(RUNLINT) $(PWD)/src/exporter.py

requirements:
	$(RUNPIP) install -r requirements.txt --user

run: 
	$(RUNPYTHON) src/exporter.py

login:
	$(RUNDOCKER) login -u $(DOCKERHUB_USER) -p $(DOCKERHUB_PASSWORD)

build:
	$(RUNDOCKER) $(@) -t $(IMAGE):$(VERSION) -f Dockerfile.armv6 .
	$(RUNDOCKER) $(@) -t $(IMAGE):$(VERSION) -f Dockerfile.armv7 .

tag:
	$(RUNDOCKER) $(@) $(IMAGE):$(VERSION) $(IMAGE):$(VERSION)

push:
	$(RUNDOCKER) $(@) $(IMAGE):$(VERSION)