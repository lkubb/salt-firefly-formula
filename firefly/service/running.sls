# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as firefly with context %}

include:
  - {{ sls_config_file }}

Firefly III service is enabled:
  compose.enabled:
    - name: {{ firefly.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if firefly.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ firefly.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
    - require:
      - Firefly III is installed
{%- if firefly.install.rootless %}
    - user: {{ firefly.lookup.user.name }}
{%- endif %}

Firefly III service is running:
  compose.running:
    - name: {{ firefly.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if firefly.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ firefly.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if firefly.install.rootless %}
    - user: {{ firefly.lookup.user.name }}
{%- endif %}
    - watch:
      - Firefly III is installed
