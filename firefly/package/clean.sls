# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as firefly with context %}

include:
  - {{ sls_config_clean }}

Firefly III is absent:
  compose.removed:
    - name: {{ firefly.lookup.paths.compose }}
    - volumes: {{ firefly.install.remove_all_data_for_sure }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if firefly.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ firefly.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if firefly.install.rootless %}
    - user: {{ firefly.lookup.user.name }}
{%- endif %}
    - require:
      - sls: {{ sls_config_clean }}

Firefly III compose file is absent:
  file.absent:
    - name: {{ firefly.lookup.paths.compose }}
    - require:
      - Firefly III is absent

Firefly III user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ firefly.lookup.user.name }}
    - enable: false

Firefly III user account is absent:
  user.absent:
    - name: {{ firefly.lookup.user.name }}
    - purge: {{ firefly.install.remove_all_data_for_sure }}
    - require:
      - Firefly III is absent

{%- if firefly.install.remove_all_data_for_sure %}

Firefly III paths are absent:
  file.absent:
    - names:
      - {{ firefly.lookup.paths.base }}
    - require:
      - Firefly III is absent
{%- endif %}
