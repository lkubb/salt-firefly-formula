# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as firefly with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Firefly III environment files are managed:
  file.managed:
    - names:
      - {{ firefly.lookup.paths.config_firefly }}:
        - source: {{ files_switch(['firefly.env', 'firefly.env.j2'],
                                  lookup='firefly environment file is managed',
                                  indent_width=10,
                     )
                  }}
      - {{ firefly.lookup.paths.config_db }}:
        - source: {{ files_switch(['db.env', 'db.env.j2'],
                                  lookup='db environment file is managed',
                                  indent_width=10,
                     )
                  }}
      - {{ firefly.lookup.paths.config_importer }}:
        - source: {{ files_switch(['importer.env', 'importer.env.j2'],
                                  lookup='importer environment file is managed',
                                  indent_width=10,
                     )
                  }}
    - mode: '0640'
    - user: root
    - group: {{ firefly.lookup.user.name }}
    - makedirs: True
    - template: jinja
    - require:
      - user: {{ firefly.lookup.user.name }}
    - watch_in:
      - Firefly III is installed
    - context:
        firefly: {{ firefly | json }}
