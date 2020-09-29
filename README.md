# Prometheus exporter for Raspberry Pi core temperature

Prometheus Endpoint, written in Python to values from CPU core on a raspberry pi.

[![Build Status](https://ci.devopoly.de/api/badges/lukibahr/prometheus-raspberrypi-temp-exporter/status.svg)](https://ci.devopoly.de/lukibahr/prometheus-raspberrypi-temp-exporter)

## Implementation

Have a look at the sourcecode for details. Generally, you'll have to download and import the required python libraries.
Refer to the official documentation on how to implement a prometheus exporter: https://github.com/prometheus/client_python.

### Development

You'll need to install python (I recommend python3) to prepare your local environment: 

```bash
$ sudo apt-get update
$ sudo apt-get install python3-pip
$ sudo python3 -m pip install --upgrade pip setuptools wheel
$ sudo pip3 install prometheus_client
$ python3 exporter.py --< args[] >
```

## Running in docker

Running the exporter is supported on RaspberryPi 2|3B|+|4. Builds on Raspberry Pi 2 might take some time, so be calm to your Pi.

```bash
 python3 src/exporter.py --help
usage: exporter.py [-h] [-n NODE] [-p PORT] [-i INTERVAL]
                   [-l {DEBUG,INFO,WARNING,ERROR,CRITICAL}]

exporter

optional arguments:
  -h, --help            show this help message and exit
  -n NODE, --node NODE  The node, the exporter runs on
  -p PORT, --port PORT  The port, the exporter runs on
  -i INTERVAL, --interval INTERVAL
                        The sleep interval of the exporter
  -l {DEBUG,INFO,WARNING,ERROR,CRITICAL}, --loglevel {DEBUG,INFO,WARNING,ERROR,CRITICAL}
                        Set the logging level
```

A sample local run can be the following: `python3 src/exporter.py --node=localhost --port=9456 --interval=10 --loglevel=DEBUG`

## Building and running

You can run the exporter either via python itself or in a docker container. The required commands for running it via python are 
also in the supplied Makefile. For docker use:

```bash
$ docker build -t docker.io/lukasbahr/prometheus-raspberrypi-temp-exporter:<VERSION> -f Dockerfile .
$ docker run -p 9234:9234 -v /sys/class/thermal/thermal_zone0/:/sys/class/thermal/thermal_zone0/:ro docker.io/lukasbahr/p
rometheus-raspberrypi-temp-exporter:v0.0.1
```

or refer to the supplied Makefile.

## CI/CD

CICD is dun via drone. Drone looks for tags to create container image build tags:

Create git tag for building a image with a tagged version: `git tag <PROM_VERSION> && git push --tags`


## Open ToDo's

- :heavy_check_mark: Add CI/CD Support.
- :x: Add unit tests
- :x: Fix docs for docker-compose and docker run
