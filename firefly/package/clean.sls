# vim: ft=sls

{#-
    Removes the firefly, db, importer containers
    and the corresponding user account and service units.
    Has a depency on `firefly.config.clean`_.
    If ``remove_all_data_for_sure`` was set, also removes all data.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as firefly with context %}

include:
  - {{ sls_config_clean }}

{%- if firefly.install.autoupdate_service %}

Podman autoupdate service is disabled for Firefly III:
{%-   if firefly.install.rootless %}
  compose.systemd_service_disabled:
    - user: {{ firefly.lookup.user.name }}
{%-   else %}
  service.disabled:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}

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

{%- if firefly.install.podman_api %}

Firefly III podman API is unavailable:
  compose.systemd_service_dead:
    - name: podman
    - user: {{ firefly.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ firefly.lookup.user.name }}

Firefly III podman API is disabled:
  compose.systemd_service_disabled:
    - name: podman
    - user: {{ firefly.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ firefly.lookup.user.name }}
{%- endif %}

Firefly III user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ firefly.lookup.user.name }}
    - enable: false
    - onlyif:
      - fun: user.info
        name: {{ firefly.lookup.user.name }}

Firefly III user account is absent:
  user.absent:
    - name: {{ firefly.lookup.user.name }}
    - purge: {{ firefly.install.remove_all_data_for_sure }}
    - require:
      - Firefly III is absent
    - retry:
        attempts: 5
        interval: 2

{%- if firefly.install.remove_all_data_for_sure %}

Firefly III paths are absent:
  file.absent:
    - names:
      - {{ firefly.lookup.paths.base }}
    - require:
      - Firefly III is absent
{%- endif %}
