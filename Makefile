# Makefile

RUNPYTHON = $(shell which python)
RUNLINT = $(shell which pylint)
RUNPIP = $(shell which pip)
RUNDOCKER = $(shell which docker) 

IMAGE = docker.io/lukasbahr/prometheus-raspberrypi-temp-exporter
VERSION = 0.0.4

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
	$(RUNDOCKER) $(@) -t $(IMAGE):$(VERSION)-armv6 -f Dockerfile.armv6 .
	$(RUNDOCKER) $(@) -t $(IMAGE):$(VERSION)-armv7 -f Dockerfile.armv7 .

push: build
	$(RUNDOCKER) $(@) $(IMAGE):$(VERSION)-armv6
	$(RUNDOCKER) $(@) $(IMAGE):$(VERSION)-armv7