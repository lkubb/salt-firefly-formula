# vim: ft=sls


{#-
    Stops the firefly, db, importer container services
    and disables them at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as firefly with context %}

firefly service is dead:
  compose.dead:
    - name: {{ firefly.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if firefly.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ firefly.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if firefly.install.rootless %}
    - user: {{ firefly.lookup.user.name }}
{%- endif %}

firefly service is disabled:
  compose.disabled:
    - name: {{ firefly.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if firefly.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ firefly.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if firefly.install.rootless %}
    - user: {{ firefly.lookup.user.name }}
{%- endif %}
