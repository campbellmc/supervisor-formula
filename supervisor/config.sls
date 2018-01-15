# -*- coding: utf-8 -*-
# vim: ft=sls

{% from slspath+'/map.jinja' import supervisor with context %}

{% if False %}
supervisor_config:
  file.managed:
    - name: {{supervisor.config}}
    - source: salt://{{slspath}}/files/supervisord.conf.jinja
    - template: jinja
    - context:
        config: {{supervisor.supervisord_conf}}
    - mode: {{supervisor.mode}}
    - user: {{supervisor.user}}
    - group: {{supervisor.group}}
    - require_in:
      - service: supervisor.service
    - watch_in:
      - service: supervisor.service
{% endif %}

{% for program,values in supervisor.programs.items() %}
supervisor_program_{{program}}:
{% if ( 'enabled' in values and values.enabled ) or 'enabled' not in values %}
  file.managed:
    - name: {{supervisor.include_path}}/{{program}}.ini
    - source: salt://{{slspath}}/files/program.ini.jinja
    - template: jinja
    - mode: 644
    - user: {{supervisor.user}}
    - group: {{supervisor.group}}
    - defaults:
        program: {{program}}
        values: {{values}}
    - watch_in:
      - service: supervisor.service
{% elif 'enabled' in values and not values.enabled %}
  file.absent:
    - name: {{supervisor.include_path}}/{{program}}.ini
    - watch_in:
        - service: supervisor.service
{% endif %}
{% endfor %}
