# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as firefly with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

Firefly III user account is present:
  user.present:
{%- for param, val in firefly.lookup.user.items() %}
{%-   if val is not none and param != "groups" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - usergroup: true
    - createhome: true
    - groups: {{ firefly.lookup.user.groups | json }}
    # (on Debian 11) subuid/subgid are only added automatically for non-system users
    - system: false

Firefly III user session is initialized at boot:
  compose.lingering_managed:
    - name: {{ firefly.lookup.user.name }}
    - enable: {{ firefly.install.rootless }}
    - require:
      - user: {{ firefly.lookup.user.name }}

Firefly III paths are present:
  file.directory:
    - names:
      - {{ firefly.lookup.paths.base }}
    - user: {{ firefly.lookup.user.name }}
    - group: {{ firefly.lookup.user.name }}
    - makedirs: true
    - require:
      - user: {{ firefly.lookup.user.name }}

Firefly III compose file is managed:
  file.managed:
    - name: {{ firefly.lookup.paths.compose }}
    - source: {{ files_switch(['docker-compose.yml', 'docker-compose.yml.j2'],
                              lookup='Firefly III compose file is present'
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ firefly.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - makedirs: true
    - context:
        firefly: {{ firefly | json }}

Firefly III is installed:
  compose.installed:
    - name: {{ firefly.lookup.paths.compose }}
{%- for param, val in firefly.lookup.compose.items() %}
{%-   if val is not none and param != "service" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
{%- for param, val in firefly.lookup.compose.service.items() %}
{%-   if val is not none %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - watch:
      - file: {{ firefly.lookup.paths.compose }}
{%- if firefly.install.rootless %}
    - user: {{ firefly.lookup.user.name }}
    - require:
      - user: {{ firefly.lookup.user.name }}
{%- endif %}

{%- if firefly.install.autoupdate_service is not none %}

Podman autoupdate service is managed for Firefly III:
{%-   if firefly.install.rootless %}
  compose.systemd_service_{{ "enabled" if firefly.install.autoupdate_service else "disabled" }}:
    - user: {{ firefly.lookup.user.name }}
{%-   else %}
  service.{{ "enabled" if firefly.install.autoupdate_service else "disabled" }}:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}
