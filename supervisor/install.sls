# -*- coding: utf-8 -*-
# vim: ft=sls

{% from slspath+'/map.jinja' import supervisor with context %}

{% if grains['os_family'] == 'RedHat' %}
{% if supervisor.epel_sls %}
include:
    - {{supervisor.epel_sls}}
{% endif %}
{% endif %}

supervisor-pkg:
  pkg.installed:
    - name: {{supervisor.pkg}}
