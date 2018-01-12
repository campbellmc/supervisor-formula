# -*- coding: utf-8 -*-
# vim: ft=sls

{% from slspath+'/map.jinja' import supervisor with context %}

{% if grains['os_family'] == 'RedHat' %}
include:
    - epel
{% endif %}

supervisor-pkg:
  pkg.installed:
    - name: {{supervisor.pkg}}
