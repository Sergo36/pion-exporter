#!/usr/bin/env python3

from prometheus_client import start_http_server, Metric, REGISTRY
import json
import requests
import sys
import time

class JsonCollector(object):
  def __init__(self, endpoint):
    self._endpoint = endpoint
  def collect(self):
    # Fetch the JSON
    response = json.loads(requests.get(self._endpoint).content.decode('UTF-8'))

    # Convert for the node status
    metric = Metric('node_status',
        'Requests node staus', 'summary')
    metric.add_sample('node_status',
        value=response['network']['nodeInfo']['active'], labels={})
    yield metric


if __name__ == '__main__':
  # Usage: json_exporter.py port endpoint
  start_http_server(int(sys.argv[1]))
  REGISTRY.register(JsonCollector(sys.argv[2]))

  while True: time.sleep(1)