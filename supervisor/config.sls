# -*- coding: utf-8 -*-
# vim: ft=sls

{% from slspath+'/map.jinja' import supervisor with context %}

supervisor-config:
  file.managed:
    - name: {{ supervisor.config }}
    - source: salt://supervisor/templates/supervisord.conf.tmpl
    - template: jinja
    - mode: 644
    - user: {{supervisor.user}}
    - group: {{supervisor.group}}
    - require_in:
      - service: supervisor.service
    - watch_in:
      - service: supervisor.service

{% for program,values in supervisor.programs.items() %}
supervisor-program-{{ program }}:
{% if ( 'enabled' in values and values.enabled ) or 'enabled' not in values %}
  file.managed:
{% if 'legacy' in supervisor and supervisor.legacy %}
    - name: {{ supervisor.program_dir }}/{{ program }}-prog.conf
{% else %}
    - name: {{ supervisor.program_dir }}/{{ program }}.conf
{% endif %}
    - source: salt://supervisor/templates/program.conf.tmpl
    - template: jinja
    - mode: 644
    - user: {{supervisor.user}}
    - group: {{supervisor.group}}
    - defaults:
        program: {{ program }}
        values: {{ values }}
    - watch_in:
      - service: supervisor.service
{% elif 'enabled' in values and not values.enabled %}
  file.absent:
{% if 'legacy' in supervisor and supervisor.legacy %}
    - name: {{ supervisor.program_dir }}/{{ program }}-prog.conf
{% else %}
    - name: {{ supervisor.program_dir }}/{{ program }}.conf
{% endif %}
    - watch_in:
        - service: supervisor.service
{% endif %}

{% endfor %}

