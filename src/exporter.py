#!/usr/bin/env python
"""
Prometheus running in kubernetes will automatically scrape this service.
"""

import time
import argparse
import logging
import socket
from prometheus_client.core import GaugeMetricFamily, REGISTRY
from prometheus_client import start_http_server

LOGFORMAT = "%(asctime)s - %(levelname)s [%(name)s] %(threadName)s %(message)s"

CPUTEMP = "/sys/class/thermal/thermal_zone0/temp"

class CustomCollector():
    """
    Class CustomCollector implements the collect function
    """
    def __init__(self, node=None):
        self.node = node

    def collect(self):
        """collect collects the metrics"""
        c = GaugeMetricFamily("core_temperature_in_celcius", 'Core temperature in celcuis', labels=['node'])
        f = GaugeMetricFamily("core_temperature_in_fahrenheit", 'Core temperature in fahrenheit', labels=['node'])

        with open(CPUTEMP, 'r') as reader:
            celcius_core_temp = reader.read()
            fahrenheit_core_temp = (9/5)* float(celcius_core_temp) + 32

        c.add_metric([self.node], celcius_core_temp)
        f.add_metric([self.node], fahrenheit_core_temp)
        
        yield f
        yield c

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Prometheus raspberry pi temp exporter')
    parser.add_argument('-n', '--node', type=str, help='The node, the exporter runs on', default=socket.gethostname())
    parser.add_argument('-p', '--port', type=int, help='The port, the exporter runs on', default=9234)
    parser.add_argument('-i', '--interval', type=int, help='The sleep interval of the exporter', default=120)
    parser.add_argument("-l", "--loglevel", choices=['DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL'], help="Set the logging level")
    args = parser.parse_args()
    if args.loglevel:
        logging.basicConfig(level=getattr(logging, args.loglevel), format=LOGFORMAT)
    logging.debug("parsing command line arguments: %s", args)
    logging.info("running exporter on port %s", args.port)
    start_http_server(args.port)
    REGISTRY.register(CustomCollector(args.node))
    while True:
        logging.debug("pausing %s seconds", args.interval)
        time.sleep(args.interval)
