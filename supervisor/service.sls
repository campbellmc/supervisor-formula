# -*- coding: utf-8 -*-
# vim: ft=sls

{% from slspath+"/map.jinja" import supervisor with context %}

supervisor.service:
  service.running:
    - name: {{ supervisor.service_name }}
    - enable: True
