# -*- coding: utf-8 -*-
# vim: ft=sls

{% from slspath+'/map.jinja' import supervisor with context %}

{% if grains['os_family'] == 'RedHat' %}
{% if supervisor.epel_sls %}
include:
    - {{supervisor.epel_sls}}
{% endif %}
{% endif %}

supervisor_pkg:
  pkg.installed:
    - name: {{supervisor.pkg}}

supervisord_include_path_{{supervisor.include_path}}:
  file.directory:
    - name: {{supervisor.include_path}}
    - user: {{supervisor.user}}
    - group: {{supervisor.group}}
    - dir_mode: {{supervisor.dir_mode}}
    - file_mode: {{supervisor.mode}}
    - require:
      - pkg: {{supervisor.pkg}}
