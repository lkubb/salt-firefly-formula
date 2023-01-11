# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as firefly with context %}

include:
  - {{ sls_service_clean }}

# This does not lead to the containers/services being rebuilt
# and thus differs from the usual behavior
Firefly III environment files are absent:
  file.absent:
    - names:
      - {{ firefly.lookup.paths.config_firefly }}
      - {{ firefly.lookup.paths.config_db }}
      - {{ firefly.lookup.paths.config_importer }}
      - {{ firefly.lookup.paths.base | path_join(".saltcache.yml") }}
    - require:
      - sls: {{ sls_service_clean }}
