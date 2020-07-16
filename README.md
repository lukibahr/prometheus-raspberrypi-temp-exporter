# Prometheus exporter for vcgencmd

Prometheus Endpoint, written in Python to values from vcgencmd on a raspberry pi.

[![Build Status](https://ci.devopoly.de/api/badges/lukibahr/raspbi-vcgencmd-exporter/status.svg)](https://ci.devopoly.de/lukibahr/raspbi-vcgencmd-exporter)

## Implementation

Have a look at the sourcecode for details. Generally, you'll have to download and import the required python libraries.
Refer to the official documentation on how to implement a prometheus exporter: https://github.com/prometheus/client_python.

### Development

You'll need to install python (I recommend python3) to prepare your local environment: 

```bash
$ sudo apt-get update
$ sudo apt-get install python3-pip
$ sudo python3 -m pip install --upgrade pip setuptools wheel
$ sudo pip3 install prometheus_client vcgencmd
$ python3 exporter.py --< args[] >
```

## Running in docker

I've used hypriot os with a RaspberryPi 3B+. It works on a Raspberry Pi 2 too, although docker builds might take some time, so be calm to your Pi.

```bash
 python3 src/exporter.py --help
usage: exporter.py [-h] [-n NODE] [-p PORT] [-i INTERVAL]
                   [-l {DEBUG,INFO,WARNING,ERROR,CRITICAL}]

Prometheus vcgencmd exporter

optional arguments:
  -h, --help            show this help message and exit
  -n NODE, --node NODE  The node, the exporter runs on
  -p PORT, --port PORT  The port, the exporter runs on
  -i INTERVAL, --interval INTERVAL
                        The sleep interval of the exporter
  -l {DEBUG,INFO,WARNING,ERROR,CRITICAL}, --loglevel {DEBUG,INFO,WARNING,ERROR,CRITICAL}
                        Set the logging level
```

A sample local run can be the following: `python3 src/exporter.py --node=localhost --port=9104 --interval=10 --loglevel=DEBUG`

## Building and running

You can run the exporter either via python itself or in a docker container. The required commands for running it via python are 
also in the supplied Makefile. For docker use:

```bash
$ docker build -t lukasbahr/raspbi-vcgencmd-exporter:<VERSION> -f Dockerfile .
$ docker tag lukasbahr/raspbi-vcgencmd-exporter:<VERSION> lukasbahr/raspbi-vcgencmd-exporter:<VERSION>
$ docker run -it -p 9234:9234 lukasbahr/raspbi-vcgencmd-exporter:<VERSION>
```

or refer to the supplied Makefile.

You can also download it from docker hub via `docker pull lukasbahr/raspbi-vcgencmd-exporter:<VERSION>`

## Open ToDo's

- :x: Add CI/CD Support.
- :x: Add unit tests
- :x: use buildx to create the proper image
- :x: Add health metric, error metric, scrape interval, general information about exporter etc.
- :x: Fix docs for docker-compose and docker run

## Further reading

- https://pypi.org/project/vcgencmd/#:~:text=Summary,a%20binding%20to%20that%20tool
